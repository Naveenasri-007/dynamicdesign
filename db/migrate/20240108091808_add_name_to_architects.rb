# frozen_string_literal: true

class AddNameToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :name, :string
  end
end
