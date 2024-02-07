class AddPhoneNumberToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :phone_number, :string
  end
end