# frozen_string_literal: true

# The Rating class represents the ratings given by users to designs.
# It belongs to a design and a user and validates that the value is
# between 1 and 5.
class Rating < ApplicationRecord
  belongs_to :design
  belongs_to :user
  validates :value, inclusion: { in: 1..5, message: 'Rating must be between 1 and 5' }
end
