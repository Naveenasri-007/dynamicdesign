# frozen_string_literal: true

class AddCoverPhotoToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :cover_photo, :string
  end
end
