class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :design
  belongs_to :architect


  validates_presence_of :expected_amount, message: 'Expected amount is not valid'
  validates_numericality_of :expected_amount, greater_than: 0, only_integer: true, message: 'Expected amount must be a positive integer'
  validates_numericality_of :expected_months, greater_than: 0, only_integer: true, message: 'Expected months must be a positive integer'
  validates_numericality_of :architect_id, greater_than: 0, only_integer: true, message: 'Architect ID must be a positive integer'
  validates_presence_of :design_name, message: 'Design name is null or empty'
  validates_presence_of :design_url, message: 'Design URL is null or empty'
  validates_presence_of :message, message: 'Message is null or empty'
  
end
