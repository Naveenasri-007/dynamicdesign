class User < ApplicationRecord
  has_many :likes, dependent: :delete_all
  has_many :ratings, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :bookings, dependent: :delete_all

  validates :name, presence: true
  validates :password, presence: true,
                       format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=])(?=.*[^\s]).{8,}\z/, message: 'User password is not valid' }
  validates :email, presence: true,
                    format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/, message: 'Email address is not valid' }
  validates :phone_number, format: { with: /\A(\+?91)?[6-9]\d{9}\z/, message: 'Phone number is not valid' }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
