require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name('User') }
  it { should belong_to(:best_answer).class_name('Answer').optional(true)  }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  it { expect(question.user?(user)).to eq(true) }

  it { should have_many_attached(:files) }
end
