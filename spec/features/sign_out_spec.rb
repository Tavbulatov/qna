require 'rails_helper'

feature 'User can sign out', %q{
  As registered user
  I want to log out in system
} do

  given(:user) {create(:user)}

  scenario 'Authenticated user logs out' do
    visit new_user_session_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    click_on 'Sign out'
    expect(page).to have_content('Signed out successfully.')
  end
end
