# frozen_string_literal: true

class RemoveGenderAddressProfileImageCoverPhotoEducationExperienceDegreeCertificatePhotoNataCertificatePhotoFromArchitects < ActiveRecord::Migration[7.1]
  def change
    remove_column :architects, :gender, :string
    remove_column :architects, :address, :string
    remove_column :architects, :profile_image, :string
    remove_column :architects, :cover_photo, :string
    remove_column :architects, :education, :string
    remove_column :architects, :experience, :integer
    remove_column :architects, :degree_certificate_photo, :string
    remove_column :architects, :nata_certificate_photo, :string
  end
end
