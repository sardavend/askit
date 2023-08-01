class ChatSessionsController < ApplicationController
  before_action :set_document, except: [:demo]
  before_action :set_chat_session, only: [:edit, :update, :destroy, :show]
  before_action :set_chat_sessions, only: [:index]
  before_action :set_inquires, only: [:show]

  def create
    @new_chat_session = @document.chat_sessions.new(chat_session_params)
    if @new_chat_session.save
      respond_to do |format|
        format.html { redirect_to document_chat_sessions_path }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @chat_session.update(chat_session_params)
    respond_to do |format|
      format.html { redirect_to document_chat_sessions_path}
      format.turbo_stream
    end
  end

  def destroy
    @chat_session.destroy
  end

  def new
    @chat_session = ChatSession.new
  end

  def demo
    @document = Document.first
    @chat_sessions = @document.chat_sessions
    render :index
  end

  private
  def chat_session_params
    params.require(:chat_session)
          .permit(:title)
  end
  def set_document
    @document = Document.find(params[:document_id])
    # @document = Document.find(2)
  end

  def set_chat_session
    @chat_session = @document.chat_sessions.find(params[:id])
  end

  def set_chat_sessions
    @chat_sessions = @document.chat_sessions
  end

  def set_inquires
    @inquires= @chat_session.inquires
  end
end
