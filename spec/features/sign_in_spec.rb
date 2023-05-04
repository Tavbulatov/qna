require 'rails_helper'

feature 'User can sign in', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
" do
  given(:user) { create(:user) }

  describe 'Sign in ' do
    background { sign_in(user) }

    scenario 'Registered user tries to sign in' do
      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_current_path(root_path)
    end

    scenario 'Authenticated user tries to login again' do
      visit new_user_session_path

      expect(page).to have_content('You are already signed in.')
    end
  end

  scenario 'The user entered the password incorrectly' do
    visit new_user_session_path

    fill_in 'Email',    with: user.email
    fill_in 'Password', with: 789_789
    click_on 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end
end
