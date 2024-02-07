class Rating < ApplicationRecord
  belongs_to :design
  belongs_to :user
  validates :value, inclusion: { in: 1..5, message: 'Rating must be between 1 and 5' }
end
