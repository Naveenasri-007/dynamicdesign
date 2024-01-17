class AddAddressToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :address, :string
  end
end
