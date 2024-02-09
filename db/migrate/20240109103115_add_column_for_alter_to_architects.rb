# frozen_string_literal: true

class AddColumnForAlterToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :number, :string
  end
end
