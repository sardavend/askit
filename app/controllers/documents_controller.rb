class DocumentsController < ApplicationController
  before_action :set_document, only: :show
  before_action :set_documents, only: :index

  def show
    @inquires = Inquire.last(2)
  end

  def index
  end

  private
  def set_document
    @document = Document.first
  end

  def set_documents
    @documents = Document.all
  end
end
