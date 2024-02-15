# frozen_string_literal: true

# Represents a design model in the application.
# Designs are associated with architects, bookings, likes, ratings, comments, and bookings.
# They have various validations for fields such as design_name, design_url, price_per_sqft, etc.
# The class also defines scopes for sorting designs by likes and dislikes.
class Design < ApplicationRecord
  belongs_to :architect
  belongs_to :booking, optional: true
  has_many :likes, dependent: :delete_all
  has_many :ratings, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :bookings, dependent: :delete_all
  validates_length_of :design_name, within: 3..30, message: 'design Name must be between 3 and 30 characters'
  validates :design_url, presence: { message: 'Design URLs are null or empty' }
  validates_numericality_of :price_per_sqft, greater_than_or_equal_to: 0, message: 'Price must be a non-negative value'
  validates_numericality_of :square_feet, greater_than_or_equal_to: 0,
                                          message: 'Square feet must be a non-negative value'
  validates :category, inclusion: { in: %w[bedroom livingroom kitchen bathroom], message: 'Invalid design category' }
  validates :floorplan, inclusion: { in: %w[1BHK 2BHK 3BHK 3+BHK], message: 'Invalid design floor plan' }
  validates_length_of :bio, within: 4..80, message: 'Bio must be between 4 and 80 characters'
  validates_length_of :brief, within: 10..200_000, message: 'Brief must be between 10 and 200_000 characters'

  scope :by_likes, -> { joins(:likes).group('designs.id').order('COUNT(likes.id) DESC') }
  scope :by_dislikes, -> { joins(:likes).group('designs.id').order('COUNT(likes.id) ASC') }
end
