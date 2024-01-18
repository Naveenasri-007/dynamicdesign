class Design < ApplicationRecord
  belongs_to :architect
  has_many :likes, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments,dependent: :destroy
  scope :by_likes, -> { joins(:likes).group('designs.id').order('COUNT(likes.id) DESC') }
  scope :by_dislikes, -> { joins(:likes).group('designs.id').order('COUNT(likes.id) ASC') }
end
