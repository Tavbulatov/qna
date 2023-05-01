require 'rails_helper'

feature 'Author can delete his question', '
  I am an authorized user
  being on the page of all questions
  I have the option to delete my question.
' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Removal of question' do
    background { sign_in(user) }

    scenario 'removal of question by its author' do
      click_on 'Delete ||'
      expect(page).to have_content('Your question has been successfully deleted')
    end

    scenario 'If there are no questions, then there is no "Delete ||" button' do
      expect(page).to_not have_link("'Delete ||'")
    end
  end

  describe 'Removal by non-author' do
    scenario 'attempt to delete question' do
      sign_in(other_user)
      click_on 'Delete ||'

      expect(page).to have_content("You can't delete someone else's question")
    end
  end
end
