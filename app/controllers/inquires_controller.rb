class InquiresController < ApplicationController
  def create
    new_inquire = Inquire.create(question_params)
    if new_inquire.answer_question
      redirect_to demo_path
    else
      redirect_to demo_path
    end

  end

  def index
  end

  private

  def question_params
    params.require(:inquire)
          .permit(:question)
  end
end
