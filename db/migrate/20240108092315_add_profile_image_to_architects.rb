class AddProfileImageToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :profile_image, :string
  end
end
