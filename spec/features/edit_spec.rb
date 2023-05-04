require 'rails_helper'

feature 'The user can change the data about himself', '
  As a registered user
  Passing authentication in the system
  I want to update my details
' do
  given(:user) { create(:user) }

  scenario 'I completely change all the information about me' do
    sign_in(user)

    visit edit_user_registration_path

    fill_in 'First name',            with: 'Stiven'
    fill_in 'Last name',             with: 'Sigl'
    fill_in 'Email',                 with: 'testststst@mail.com'
    fill_in 'Password',              with: 789_789
    fill_in 'Password confirmation', with: 789_789
    fill_in 'Current password',      with: 123_123
    click_on 'Update'
    expect(page).to have_content('Your account has been updated successfully.')
  end
end
