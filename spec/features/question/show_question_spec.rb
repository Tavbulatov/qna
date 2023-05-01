require 'rails_helper'

feature 'Show question and answers', '
  Me as a user
  I have the ability to go to the question page
  see the title of the question and the answers to the question
' do
  given(:question) { create(:question) }

  describe 'go to the question page and view the answers' do
    given(:answer) { create(:answer, question: question) }

    scenario 'view the question and its answers' do
      visit question_path(question)
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content answer.body
    end
  end
end
