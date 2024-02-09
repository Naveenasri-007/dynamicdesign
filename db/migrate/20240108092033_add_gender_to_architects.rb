# frozen_string_literal: true

class AddGenderToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :gender, :string
  end
end
