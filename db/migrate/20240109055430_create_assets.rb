# frozen_string_literal: true

class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.references :design, null: false, foreign_key: true
      t.string :image_url, limit: 255

      t.timestamps
    end
  end
end
