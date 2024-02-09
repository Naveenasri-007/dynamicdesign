# frozen_string_literal: true

# Represents the Like model, associating users with designs they like.
# This model is used to track the likes given to specific designs by users.
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :design
end
