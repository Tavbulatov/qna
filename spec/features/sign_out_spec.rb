require 'rails_helper'

feature 'User can sign out', '
  As registered user
  I want to log out in system
' do
  given(:user) { create(:user) }

  scenario 'Authenticated user logs out' do
    sign_in(user)
    click_on 'Sign out'
    expect(page).to have_content('Signed out successfully.')
  end
end
