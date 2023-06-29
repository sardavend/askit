class Inquire < ApplicationRecord
  has_neighbors :embedding
  after_validation :generate_vector_embbeding
  belongs_to :chat_session

  # after_update_commit -> {
  #   broadcast_replace_to(:questions, partial: 'inquires/question_answer')
  # }

  MINIMAL_QUESTION_DISTANCE = 0.95

  def embedded_input
    <<~INPUT
    Question: #{question}
    INPUT
  end


  def answer_question
    if similar_question
      similar_question.answer
    else
      content = Document
        .first.related_content(self)

      puts "Context #{content}"

      context = [{role: 'system', content: chabot_context_message(question, content)}]

      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: context,
          temperature: 0.2
        })
      self.answer = response.dig("choices",0, "message", "content")
      save!
    end
  end

  def similar_question
    Inquire
      .nearest_neighbors(
        :embedding,
        embedding,
        distance: 'inner_product'
      ).filter{|inquire| inquire.id != self.id && inquire.neighbor_distance > MINIMAL_QUESTION_DISTANCE}.first
  end

  private
  def generate_vector_embbeding
    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: Gpt::Tiktoken::DEFAULT_MODEL,
        input: embedded_input
      }
    )

    self.embedding = response.dig('data', 0, 'embedding')
  end

  def chabot_context_message(query, context)
    <<~INPUT
    You are a friendly chatbot, your task is to respondo to a query question delimited by <#{query}>
    based in the information provided: #{context}
    INPUT
  end
end
