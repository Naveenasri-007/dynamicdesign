class CreateDesigns < ActiveRecord::Migration[7.1]
  def change
    create_table :designs do |t|
      t.string :design_name, limit: 255
      t.string :style, limit: 255
      t.decimal :price_per_sqft
      t.integer :square_feet
      t.string :category, limit: 255
      t.string :floorplan, limit: 255
      t.string :time_required, limit: 255
      t.string :bio, limit: 255
      t.text :brief
      t.references :architect, null: false, foreign_key: true

      t.timestamps
    end
  end
end
