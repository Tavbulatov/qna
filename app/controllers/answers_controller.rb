class AnswersController < ApplicationController
  before_action :find_answer, only: %i[destroy update best]
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

  def best
    question = @answer.question
    question.update(best_answer: @answer)
    @best_answer = question.best_answer
    @answers = question.answers.where.not(id: @best_answer.id)

    flash[:notice] = 'Best answer selected successfully'
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
