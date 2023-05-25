require 'rails_helper'

feature 'The author can remove question attachments', '
  As an authorized user
  I want to remove attachments
  to my question
' do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question_with_file, author: user) }

  background {  }

  scenario 'Deleting attach by the author', js: true do
    sign_in(user)
    visit question_path(question)
    click_on("Delete attach")
    accept_alert 'Are you sure?'
    sleep 0.5

    expect(page).to_not have_link('rails_helper.rb')
    expect(page).to have_content('File deleted successfully')
  end

  scenario 'Not the author trying to delete attach', js: true do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link("Delete attach")
  end
end
