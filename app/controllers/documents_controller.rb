class DocumentsController < ApplicationController
  before_action :set_document, only: :show
  def show
    @inquires = Inquire.last(2)
  end

  def index
  end

  private
  def set_document
    @document = Document.first
  end
end
