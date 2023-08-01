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
    related_pages = document_pages
      .nearest_neighbors(
        :embedding,
        question.embedding,
        distance: 'inner_product')
      .filter{ |page| page.neighbor_distance > MINIMAL_CONTENT_RELATEDNESS }

    truncate_content(related_pages)
  end

  def attachment_to_base64
    return unless file.attached?
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

    content_list = new_document_pages.pluck(:content)
    embeddings = Gpt::Embeddings.embed(content_list)

    embeddings.each do |embed|
      # Each index attribute in the response correspond to each index in the
      # input array
      new_document_pages[embed["index"]].merge!(embedding: embed["embedding"])
    end

    DocumentPage.insert_all!(new_document_pages)

    self.tokens = total_tokens
    save
  end

  private
  def truncate_content(content, max_tokens = Gpt::Tiktoken::MAX_NUM_OF_TOKENS)
    current_tokens = 0
    content.filter do |content_page|
      current_tokens += Gpt::Tiktoken.count(content_page.content)
      current_tokens < max_tokens
    end
  end
end
