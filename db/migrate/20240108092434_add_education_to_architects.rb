# frozen_string_literal: true

class AddEducationToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :education, :string
  end
end
