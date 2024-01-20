class ChangeStatusDefaultToPending < ActiveRecord::Migration[7.1]
  def change
    change_column_default :your_table_name, :status, 'pending'
  end
end
