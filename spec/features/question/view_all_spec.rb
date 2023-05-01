require 'rails_helper'

feature 'Wiev all questions', "
  I'm on the questions page
  I see all questions.
  By going to the question page by clicking on the title
" do
  given!(:question) { create(:question) }

  background { visit questions_path }

  describe 'List questions' do
    scenario 'displaying a list of questions on the main page' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_link question.title
    end

    scenario 'go to the question page by clicking on the question title' do
      click_on("#{question.title}")

      expect(page).to have_content question.title
    end
  end
end
