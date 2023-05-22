class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show ]

  before_action :find_question, only: %i[show destroy update]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.where.not(id: @question.best_answer)
  end

  def new
    @question = current_user.questions.new
  end

  def update
    if @question.user?(current_user)
      @question.update(question_params)
      flash[:notice] = 'Your question has been successfully edited.'
    end
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to questions_path, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if @question.user?(current_user)
      @question.destroy
      redirect_to questions_path, notice: 'Your question has been successfully deleted'
    else
      redirect_to questions_path, alert: "You can't delete someone else's question"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
