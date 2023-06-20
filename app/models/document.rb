class Document < ApplicationRecord
  store_accessor :metadata,
                  :author,
                  :pages,
                  :tokens

  has_one_attached :file

  has_many :pages


  def extract_pages
    raw = StringIO.new(file.download)
    reader = PDF::Reader.new(raw)
    tokens = reader.pages.reduce(0) do |accum, page|
      next if page.text.size < 8
      content = page.text.split.join(' ')
      new_page = Page.new(num: page.number, content: content, document_id: id)
      new_page.save

      accum += Gpt::Tiktoken.count(page.text)
      accum
    end

    self.tokens = tokens
    self.pages = reader.pages
    save
  end

end
