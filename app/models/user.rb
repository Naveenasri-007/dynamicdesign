# frozen_string_literal: true

# This is the user model
# It has associations with likes, ratings, comments, and bookings.
# It also includes Devise modules for authentication.
class User < ApplicationRecord
  has_many :likes, dependent: :delete_all
  has_many :ratings, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :bookings, dependent: :delete_all

  validates :name, presence: true
  validates :password, presence: true,
                       format: { with: /(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]).{8,}/,
                                 message: 'User password is not valid' }
  validates :email, presence: true,
                    format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/,
                              message: 'Email address is not valid' }
  validates :phone_number, format: { with: /\A(\+?91)?\d{10}\z/, message: 'Phone number is not valid' }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
