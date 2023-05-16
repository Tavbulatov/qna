require 'rails_helper'

feature 'User can create answer', '
  I am an authorized user
  Being on the list of questions page I can answer the question
  I can answer the question on the question page
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'creating an answer on the question page', js: true do
      sign_in(user)

      visit question_path(question)

      fill_in 'Body', with: 'answer to question'
      click_on('Create Answer')

      sleep 0.5
      expect(page).to have_content('answer to question')
      expect(page).to have_content('Answer created successfully')
    end
  end
end
