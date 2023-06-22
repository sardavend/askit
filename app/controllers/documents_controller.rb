class DocumentsController < ApplicationController
  before_action :set_document, only: :show
  def show

  end

  def index
  end

  private
  def set_document
    @document = Document.first
  end
end
