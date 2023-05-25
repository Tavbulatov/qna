require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer_with_file, question: question, author: user) }

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

    context 'The author wants to change the files' do
      let(:new_file) { fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'application/ruby') }

      it 'attachment list change' do
        patch :update, params: {id: answer, answer: {files: [new_file] } }, format: :js
        answer.reload

        expect(answer.files.first.filename).to eq('spec_helper.rb')
      end
    end
  end

  describe 'DELETE #destroy' do


    before { login(user) }

    context 'delete from db' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'removal of answer by its author' do
      before { delete :destroy, params: { question_id: question, id: answer }, format: :js }

      it 'render destroy view' do
        expect(response).to render_template :destroy
      end

      it 'sets a flash message' do
        expect(flash[:notice]).to eq('Your reply has been successfully deleted')
      end
    end

    context "trying to delete someone else's answer" do
      let(:other_user) { create(:user) }
      before {login(other_user) }

      it 'answer is not deleted' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to_not change(Answer, :count)
      end

      before { delete :destroy, params: { question_id: question, id: answer }, format: :js }

      it 'render view destroy' do
        expect(response).to render_template :destroy
      end

      it 'sets a flash message' do
        expect(flash[:alert]).to eq("You cannot delete someone else's answer")
      end
    end
  end

  describe 'PATCH #best' do
    let!(:answers) { create_list(:answer, 3, question: question) }
    let!(:best_answer) { create(:answer, question: question)}

    before { login(user) }
    before { patch :best, params: {id: answer}, format: :js }

    it 'all answers except the best answer' do
      patch :best, params: {id: best_answer}, format: :js
      expect(assigns(:answers)).to_not include(best_answer)
    end

    it 'setting variable best_answer' do
      expect(assigns(:best_answer)).to eq(answer)
    end

    it 'assigning the best answer' do
      question.reload
      expect(question.best_answer).to eq(answer)
    end

    it "render view 'best'" do
      expect(response).to render_template :best
    end

    it 'set flash message' do
      expect(flash[:notice]).to eq('Best answer selected successfully')
    end
  end
end
