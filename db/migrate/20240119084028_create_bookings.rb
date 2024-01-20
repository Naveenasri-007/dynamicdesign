class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.string :design_name
      t.string :design_url
      t.integer :expected_amount
      t.integer :expected_months
      t.text :message
      t.references :user, null: false, foreign_key: true
      t.references :architect, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
