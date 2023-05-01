require 'rails_helper'

feature 'User can create answer', '
  I am an authorized user
  Being on the list of questions page I can answer the question
  I can answer the question on the question page
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'creating an answer on the question page' do
      visit question_path(question)

      fill_in 'Body', with: 'answer to question'
      click_on('Create Answer')

      expect(page).to have_content('answer to question')
      expect(page).to have_content('Answer created successfully')
    end

    scenario 'answering a question on the all questions page' do
      click_on 'Answer the question'

      fill_in 'Body', with: 'answer to question'
      click_on('Create Answer')

      expect(page).to have_content('answer to question')
      expect(page).to have_content('Answer created successfully')
    end
  end

  scenario 'Unauthenticated user is trying to answer a question' do
    visit questions_path
    click_on 'Answer the question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'unauthenticated user creates an answer on the question page' do
    visit question_path(question)

    fill_in 'Body', with: 'answer to question'
    click_on('Create Answer')

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
