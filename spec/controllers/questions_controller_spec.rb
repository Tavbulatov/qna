require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigning a variable to view the question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { login(user) }

    before { post :create, params: { question: attributes_for(:question) } }

    context 'with valid attributes' do
      it 'saves a new Question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show' do
        expect(response).to redirect_to assigns(:question)
      end

      it 'sets a flash message' do
        expect(flash[:notice]).to eq('Your question successfully created.')
      end
    end

    context 'with invalid attributes' do
      it 'Question not saved' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end
      it 'render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let(:question) { create(:question, author: user) }

    context 'with valid attributes' do
      before { patch :update, params: { id: question, question: {title: "Question", body: "text text"} }, format: :js }

      it 'Edit title' do
        question.reload
        expect(question.title).to eq("Question")
      end

      it 'Edit body' do
        question.reload
        expect(question.body).to eq("text text")
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end

      it 'sets a flash message' do
        expect(flash[:notice]).to eq('Your question has been successfully edited.')
      end
    end

    context 'with invalid attributes' do
      it 'Title attribute has not changed' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid)}, format: :js
        end.to_not change(question, :title)
      end

      it 'Body attribute has not changed' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid)}, format: :js
        end.to_not change(question, :body)
      end

      it 'render new view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid)}, format: :js
        expect(response).to render_template :update
      end
    end

    context "Not the author trying to edit" do
      let(:other_user) { create(:user) }

      before { login(other_user) }

      it 'Title attribute has not changed' do
        expect do
          patch :update, params: { id: question, question: {title: "Question", body: "text text"} }, format: :js
        end.to_not change(question, :title)
      end

      it 'Body attribute has not changed' do
        expect do
          patch :update, params: { id: question, question: {title: "Question", body: "text text"} }, format: :js
        end.to_not change(question, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user) }
    before { login(user) }

    context 'delete from db' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
    end

    context 'removal of question by its author' do
      before { delete :destroy, params: { id: question } }

      it 'redirect to questions page' do
        expect(response).to redirect_to questions_path
      end

      it 'sets a flash message' do
        expect(flash[:notice]).to eq('Your question has been successfully deleted')
      end
    end

    context "trying to delete someone else's question" do
      let(:other_user) { create(:user) }

      before { login(other_user) }
      before { delete :destroy, params: { id: question } }

      it 'redirect to questions page' do
        expect(response).to redirect_to questions_path
      end

      it 'sets a flash message' do
        expect(flash[:alert]).to eq("You can't delete someone else's question")
      end
    end
  end
end
