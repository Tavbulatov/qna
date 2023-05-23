class Answer < ApplicationRecord
  has_many_attached :files

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true
end
