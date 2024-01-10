class AddDegreeCertificatePhotoToArchitects < ActiveRecord::Migration[7.1]
  def change
    add_column :architects, :degree_certificate_photo, :string
  end
end
