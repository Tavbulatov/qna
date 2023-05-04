class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :find_question, only: %i[show destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if @question.author == current_user
      @question.destroy
      redirect_to questions_path, notice: 'Your question has been successfully deleted'
    else
      redirect_to questions_path, alert: "You can't delete someone else's question"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
