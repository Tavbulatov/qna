require 'rails_helper'

feature 'The user can edit the question', "
  As the author of the question
  I want to be able
  Edit your question
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on "Edit"
    end

    scenario 'edit question' do
      within '.question_show' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Update Question'
        sleep 0.5
        expect(page).to have_content 'Your question has been successfully edited.'
        expect(page).to have_content 'Question title: Test question'
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'Editing with errors' do
      within '.question_show' do
        fill_in 'Title', with: nil
        fill_in 'Body', with: nil
        click_on "Update Question"
        sleep 0.5
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'form hiding' do
      within '.question_show' do
        click_on 'Update Question'
        expect(page).to_not have_selector 'textfield'
        expect(page).to_not have_selector 'textarea'
        expect(page).to_not have_link 'Update Question'
        expect(page).to have_link 'Edit'
      end
    end
  end

  scenario 'Non-author of the question does not see the edit button', js: true do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link("Edit")
  end
end
