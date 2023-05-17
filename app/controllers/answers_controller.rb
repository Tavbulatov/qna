class AnswersController < ApplicationController
  before_action :find_answer, only: %i[destroy update]
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(author: current_user ))
    if @answer.persisted?
      flash[:notice] = 'Answer created successfully'
    end
  end

  def update
    if @answer.user?(current_user)
      @answer.update(answer_params)
      flash[:notice] = 'Answer edited successfully'
    end
  end

  def destroy

    if @answer.author == current_user
      @answer.destroy

      flash[:notice] = 'Your reply has been successfully deleted'
    else
      flash[:alert] = "You cannot delete someone else's answer"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
