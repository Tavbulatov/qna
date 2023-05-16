require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(Answer, :count).by(1)
      end

      before { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js  }

      it 'render create view' do
        expect(response).to render_template :create
      end

      it 'sets a flash message' do
        expect(flash[:notice]).to eq('Answer created successfully')
      end
    end

    context 'with invalid attributes' do
      it 'answer not saved' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js  }.to_not change(Answer, :count)
      end

      it 'render create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    before { patch :update, params: {id: answer, answer: {body: 'answer'} }, format: :js }

    context 'with valid attributes' do
      it 'Edit body' do
        answer.reload
        expect(answer.body).to eq('answer')
      end

      it 'render update view' do
        expect(response).to render_template :update
      end

      it 'sets a flash message' do
        expect(flash[:notice]).to eq('Answer edited successfully')
      end
    end

    context 'with invalid attributes' do
      it 'answer not saved' do
        expect { patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid) },format: :js }.to_not change(answer, :body)
      end

      it 'render update view' do
        patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context "Not the author trying to edit" do
      let(:other_user) { create(:user) }

      before { login(other_user) }

      it 'Title attribute has not changed' do
        expect {patch :update, params: {id: answer, answer: {body: 'answer'} }, format: :js}.to_not change(answer, :body)
      end
    end
  end

  describe 'DELETE #destroy' do


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
