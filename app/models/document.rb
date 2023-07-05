class Document < ApplicationRecord
  store_accessor :metadata,
                 :author,
                 :tokens

  has_one_attached :file

  has_many :document_pages, dependent: :destroy
  has_many :chat_sessions, dependent: :destroy

  MINIMUN_PAGE_SIZE = 8
  MINIMAL_CONTENT_RELATEDNESS = 0.75


  def related_content(question)
    document_pages
      .nearest_neighbors(
        :embedding,
        question.embedding,
        distance: 'inner_product')
      .filter{|page| page.neighbor_distance > MINIMAL_CONTENT_RELATEDNESS}
      .pluck(:content).join(' ')
  end

  def attachment_to_base64
    Base64.encode64(file.download)
  end


  def extract_pages
    total_tokens = 0
    extractor = Gpt::PdfExtractor.new(file.download)

    new_document_pages = extractor.pages.map do |page|
      content = page.text.split.join(' ')
      next if content.size < MINIMUN_PAGE_SIZE

      total_tokens += Gpt::Tiktoken.count(content)
      {num: page.number, content: content, document_id: self.id}
    end

    client = OpenAI::Client.new
    content_list = new_document_pages.pluck(:content)
    response = client
                .embeddings(
                  parameters: {
                    model: Gpt::Tiktoken::DEFAULT_MODEL,
                    input: content_list
                  }
                )

    response.dig("data").each do |embed|
      # Each index attribute in the response correspond to each index in the
      # input array
      new_document_pages[embed["index"]].merge!(embedding: embed["embedding"])
    end

    DocumentPage.insert_all!(new_document_pages)

    self.tokens = total_tokens
    save
  end
end
