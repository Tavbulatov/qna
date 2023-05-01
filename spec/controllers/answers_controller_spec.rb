require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer) }

    it 'assigning a variable to view the answer' do
      get :show, params: { question_id: question, id: answer }
      expect(assigns(:answer)).to eq(answer)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.to change(Answer, :count).by(1)
      end

      before { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'redirect to show' do
        expect(response).to redirect_to(question_answer_path(question, Answer.last))
      end

      it 'sets a flash message' do
        expect(flash[:notice]).to eq('Answer created successfully')
      end
    end

    context 'with invalid attributes' do
      it 'answer not saved' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        end.to_not change(Answer, :count)
      end

      it 'render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }

    before { login(user) }

    context 'delete from db' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end
    end

    context 'removal of answer by its author' do
      before { delete :destroy, params: { question_id: question, id: answer } }

      it 'redirect to question page' do
        expect(response).to redirect_to question_path(question)
      end

      it 'sets a flash message' do
        expect(flash[:notice]).to eq('Your reply has been successfully deleted')
      end
    end

    context "trying to delete someone else's answer" do
      let(:other_user) { create(:user) }

      before { login(other_user) }
      before { delete :destroy, params: { question_id: question, id: answer } }

      it 'redirect to question page' do
        expect(response).to redirect_to question_path(question)
      end

      it 'sets a flash message' do
        expect(flash[:alert]).to eq("You cannot delete someone else's answer")
      end
    end
  end
end
