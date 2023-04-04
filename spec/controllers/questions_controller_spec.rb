require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'GET #new' do
    before {get :new}

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saves a new Question in the database' do
        expect { post :create, params: {question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show' do
        post :create, params: {question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'Question not saved' do
        expect { post :create, params: {question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 'render new view' do
        post :create, params: {question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end
