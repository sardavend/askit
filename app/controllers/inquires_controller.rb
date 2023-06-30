class InquiresController < ApplicationController
  before_action :set_document, :set_chat_session

  def create
    @inquire = @chat_session.inquires.new(question_params)
    if @inquire.save
      @inquire.exe_async(:answer_question)
      respond_to do |format|
        # format.html redirect_to document_chat_sessions_path(@document, @chat_session)
        format.turbo_stream
      end
    else
    end

  end

  def index
  end

  private
  def question_params
    params.require(:inquire)
          .permit(:question)
  end

  def set_document
    @document = Document.find(2)
  end

  def set_chat_session
    @chat_session = @document.chat_sessions.find(params[:chat_session_id])
  end
end
