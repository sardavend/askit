class Inquire < ApplicationRecord
  has_neighbors :embedding
  after_validation :generate_vector_embbeding

  def embedded_input
    <<~INPUT
    Question: #{question}
    INPUT
  end

  def related_question
    Inquire
      .nearest_neighbors(
        :embedding,
        embedding,
        distance: 'inner_product'
      ).filter{|inquire| inquire.neighbor_distance > Document::MINIMAL_CONTENT_RELATEDNESS}.first
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
end
