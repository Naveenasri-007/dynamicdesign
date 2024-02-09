# frozen_string_literal: true

# Architect model represents an architect in the system.
# Architects can have designs and bookings associated with them.
# Devise modules are used for authentication and other features.
class Architect < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :designs, dependent: :delete_all
  has_many :bookings, dependent: :delete_all

  validates :name, presence: true
  validates :profile_photo, presence: true
  validates :password, presence: true,
                       format: { with: /(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]).{8,}/,
                                 message: 'password is not valid' }
  validates :email, presence: true,
                    format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/,
                              message: 'Email address is not valid' }
  validates :number, format: { with: /\A(\+?91)?\d{10}\z/, message: 'Phone number is not valid' }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
