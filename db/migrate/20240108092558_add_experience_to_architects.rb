# frozen_string_literal: true

class AddExperienceToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :experience, :integer
  end
end
