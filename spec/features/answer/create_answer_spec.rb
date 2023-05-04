require 'rails_helper'

feature 'User can create answer', '
  I am an authorized user
  Being on the list of questions page I can answer the question
  I can answer the question on the question page
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'creating an answer on the question page' do
      sign_in(user)

      visit question_path(question)

      fill_in 'Body', with: 'answer to question'
      click_on('Create Answer')

      expect(page).to have_content('answer to question')
      expect(page).to have_content('Answer created successfully')
    end
  end

  scenario 'unauthenticated user creates an answer on the question page' do
    visit question_path(question)

    fill_in 'Body', with: 'answer to question'
    click_on('Create Answer')

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
