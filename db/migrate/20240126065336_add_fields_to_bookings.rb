# frozen_string_literal: true

class AddFieldsToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :design_name, :string
    add_column :bookings, :design_url, :string
    add_column :bookings, :expected_amount, :integer
    add_column :bookings, :expected_months, :integer
    add_column :bookings, :message, :text
    add_column :bookings, :status, :string
    add_reference :bookings, :user, null: false, foreign_key: true
    add_reference :bookings, :architect, null: false, foreign_key: true
    add_reference :bookings, :design, null: false, foreign_key: true
  end
end
