class Inquire < ApplicationRecord
  include ExceAsync

  store_accessor  :metadata,
                  :result_pages

  has_neighbors :embedding
  after_validation :generate_vector_embbeding
  belongs_to :chat_session
  delegate :document, to: :chat_session

  after_update_commit -> {
    broadcast_update_to(
      "questions",
      partial: 'inquires/inquire',
      locals: { inquire: self, typewriter: true},
      target: "chat_session_question_list"
    )
  }

  MINIMAL_QUESTION_DISTANCE = 0.95

  def embedded_input
    <<~INPUT
    Question: #{question}
    INPUT
  end

  def answer_question
    if similar_question
      self.answer = similar_question.answer
      save!
    else
      related_content  = document.related_content(self)

      content = related_content.pluck(:content).join(' ')
      pages = related_content.pluck(:identifier)

      context = [{role: 'system', content: chabot_context_message(question, content)}]

      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: context,
          temperature: 0.2
        })
      self.answer = response.dig("choices",0, "message", "content")
      self.result_pages = pages
      save!
    end
  end

  def similar_question
    @similar_question ||= Inquire
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
