class AnswersController < ApplicationController
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[show destroy]
  before_action :authenticate_user!, except: [:show]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)

    @answer.author = current_user
    if @answer.save
      redirect_to question_answer_path(@question, @answer), notice: 'Answer created successfully'
    else
      render :new
    end
  end

  def destroy
    if @answer.author == current_user
      @answer.destroy
      redirect_to @answer.question, notice: 'Your reply has been successfully deleted'
    else
      redirect_to @answer.question, alert: "You cannot delete someone else's answer"
    end
  end

  def show; end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
