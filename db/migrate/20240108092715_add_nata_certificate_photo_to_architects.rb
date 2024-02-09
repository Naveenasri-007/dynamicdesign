# frozen_string_literal: true

class AddNataCertificatePhotoToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :nata_certificate_photo, :string
  end
end
