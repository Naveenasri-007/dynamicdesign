class User < ApplicationRecord
  has_many :likes, dependent: :delete_all
  has_many :ratings, dependent: :delete_all
  has_many :comments,dependent: :delete_all
  has_many :bookings,dependent: :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
