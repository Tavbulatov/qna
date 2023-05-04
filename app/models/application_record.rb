class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def user?(user)
    author == user
  end
end
