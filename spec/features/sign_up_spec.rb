require 'rails_helper'

feature 'User registers', '
  To login
  I am not a registered user
  I want to register
' do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'First name',            with: user.last_name
    fill_in 'Last name',             with: user.first_name
    fill_in 'Email',                 with: 'test@mail.com'
    fill_in 'Password',              with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_current_path(root_path)
  end

  scenario 'When registering, the password does not match the password confirmation and the password is less than 6 characters' do
    fill_in 'First name',            with: user.last_name
    fill_in 'Last name',             with: user.first_name
    fill_in 'Email',                 with: user.email
    fill_in 'Password',              with: 1231
    fill_in 'Password confirmation', with: 123
    click_on 'Sign up'

    expect(page).to have_content('Password is too short (minimum is 6 characters)')
    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  scenario 'Empty fields' do
    click_on 'Sign up'

    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("First name can't be blank")
  end

  scenario 'The email has already been taken' do
    fill_in 'First name',            with: user.last_name
    fill_in 'Last name',             with: user.first_name
    fill_in 'Email',                 with: user.email
    fill_in 'Password',              with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content('Email has already been taken')
  end
end
