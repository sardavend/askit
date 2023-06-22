module Gpt
  class PdfExtractor
    attr_reader :blob, :io_string

    def initialize(attachment_blob)
      @blob = attachment_blob
      @io_string = StringIO.new(blob)
    end

    def pages
      reader.pages
    end

    private
    def reader
      PDF::Reader.new(io_string)
    end

  end
end
