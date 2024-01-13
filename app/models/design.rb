class Design < ApplicationRecord
  belongs_to :architect
  has_many :likes, dependent: :destroy

end
