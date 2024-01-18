# frozen_string_literal: true

# something
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :design
  validates :content, presence: true
end
