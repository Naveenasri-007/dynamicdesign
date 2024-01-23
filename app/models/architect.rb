class Architect < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :designs , dependent: :delete_all
  has_many :bookings , dependent: :delete_all

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
