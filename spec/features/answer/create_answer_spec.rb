require 'rails_helper'

feature 'User can create answer', '
  I am an authorized user
  Being on the list of questions page I can answer the question
  I can answer the question on the question page
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true  do
    background {sign_in(user)}

    scenario 'creating an answer on the question page'do
      visit question_path(question)

      fill_in 'Body', with: 'answer to question'
      click_on('Create Answer')

      sleep 0.5
      expect(page).to have_content('answer to question')
      expect(page).to have_content('Answer created successfully')
    end

    scenario 'creating a answer with adding files' do
      visit question_path(question)
      fill_in 'Body', with: 'answer to question'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on('Create Answer')
      sleep 0.5
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end
