class Design < ApplicationRecord
  belongs_to :architect
  belongs_to :booking, optional: true
  has_many :likes, dependent: :delete_all
  has_many :ratings, dependent: :delete_all
  has_many :comments,dependent: :delete_all
  has_many :bookings,dependent: :delete_all
  scope :by_likes, -> { joins(:likes).group('designs.id').order('COUNT(likes.id) DESC') }
  scope :by_dislikes, -> { joins(:likes).group('designs.id').order('COUNT(likes.id) ASC') }
end
