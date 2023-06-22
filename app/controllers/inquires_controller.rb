class InquiresController < ApplicationController
  def create
    new_inquire = Inquire.create(question_params)

    new_question.similar_question
  end

  def index
  end

  private

  def question_params
    params.require(:inquire)
          .permit(:question)
  end
end
