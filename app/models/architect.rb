class Architect < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :designs, dependent: :delete_all
  has_many :bookings, dependent: :delete_all

  validates :name, presence: true
  validates :profile_photo, presence: true
  validates :password, presence: true,
                       format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=])(?=.*[^\s]).{8,}\z/, message: 'password is not valid' }
  validates :email, presence: true,
                    format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/, message: 'Email address is not valid' }
  validates :number, format: { with: /\A(\+?91)?[6-9]\d{9}\z/, message: 'Phone number is not valid' }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
