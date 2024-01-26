class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :design
  belongs_to :architect
end
