require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_with_file, author: user) }

  describe 'Deleting an attachment' do
    before {login(user)}

    it 'destroy attachment' do
      expect { delete :destroy, params: {id: question.files.first}, format: :js }.to change(question.files, :count).by(-1)
    end

    it 'set flash message' do
      delete :destroy, params: {id: question.files.first}, format: :js
      expect(flash[:notice]).to eq('File deleted successfully')
    end
  end
end
