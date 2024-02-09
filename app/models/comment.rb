# frozen_string_literal: true

#  The comment class for the user can create , edit and delete comment the design
#  but the architect can only see the comment of the user from their design only
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :design
  validates :content, presence: true
end
