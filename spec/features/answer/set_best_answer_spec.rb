require 'rails_helper'

feature 'The user chooses the best answer', '
  As the author of the question
  I want to choose the best answer to my question
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:best_answer) { create(:answer, question: question, author: user)}

  describe 'Authenticated user', js: true do
    scenario 'choosing the best answer on the question page' do
      sign_in(user)
      visit question_path(question)
      click_on('Best')
      sleep 0.5
      within '.best_answer' do
        expect(page).to have_content(best_answer.body)
      end

      expect(page).to have_content('Best answer selected successfully')
    end
  end
end
