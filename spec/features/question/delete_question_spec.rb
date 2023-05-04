require 'rails_helper'

feature 'Author can delete his question', '
  I am an authorized user
  be on the all questions page
  I have the option to delete my question
  There is no delete button for another user
' do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Removal of question' do

    scenario 'removal of question by its author' do
      sign_in(user)
      click_on 'Delete'
      expect(page).to have_content('Your question has been successfully deleted')
    end

    scenario 'If there are no questions, then there is no "Delete" button' do
      Question.delete_all
      sign_in(user)
      expect(page).to_not have_link("Delete")
    end
  end

  describe 'Removal by non-author' do
    scenario 'attempt to delete question' do
      sign_in(other_user)
      expect(page).to_not have_link("Delete")
    end
  end
end
