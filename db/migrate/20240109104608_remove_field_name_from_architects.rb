class RemoveFieldNameFromArchitects < ActiveRecord::Migration[7.1]
  def change
    remove_column :architects, :phone_number, :string
  end
end
