class DocumentPage < ApplicationRecord
  has_neighbors :embedding
  belongs_to :document

  # after_validation :generate_vector_embbeding

  def embedded_input
    <<~INPUT
      Content: #{content}
    INPUT
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
