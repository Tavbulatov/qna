require 'rails_helper'

feature 'The author can delete his answer', '
  I am an authenticated user
  being on the question page
  I have the option to delete my answer.
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  given(:other_user) { create(:user) }

  describe 'Removal of answer' do
    scenario 'removal of answer by its author' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete answer'
      expect(page).to have_content('Your reply has been successfully deleted')
    end

    scenario 'attempt to delete answer by another user' do
      sign_in(other_user)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content("You cannot delete someone else's answer")
    end
  end
end
