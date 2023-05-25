require 'rails_helper'

feature 'The author wants to change the answer','
  I am author the answerer
  I want to be able to change my answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  given(:other_user) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
    end

    scenario 'Edit answer' do
      within '.answers' do
        fill_in 'Body', with: 'answer'
        click_on 'Update Answer'
        sleep 1

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'answer'
      end
    end

    scenario 'Answer errors' do
      within '.answers' do
        fill_in 'Body', with: nil
        click_on 'Update Answer'
        sleep 0.5

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'The form hides and showing the edit button' do
      within '.answers' do
        click_on 'Update Answer'
        sleep 0.5

        expect(page).to have_link 'Edit answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario 'Not the author does not see the edit button' do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end
end
