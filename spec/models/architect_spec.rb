require 'rails_helper'

RSpec.describe Architect, type: :model do
  it 'has a valid factory' do
    architect = Fabricate.build(:architect)
    expect(architect).to be_valid
  end

  it 'is invalid without a name' do
    architect = Fabricate.build(:architect, name: nil)
    expect(architect).to_not be_valid
  end

  it 'is invalid without an email' do
    architect = Fabricate.build(:architect, email: nil)
    expect(architect).to_not be_valid
  end

  it 'is invalid without a phone_number' do
    architect = Fabricate.build(:architect, number: nil)
    expect(architect).to_not be_valid
  end

  it 'is invalid without a password' do
    architect = Fabricate.build(:architect, password: nil)
    expect(architect).to_not be_valid
  end

  it 'is invalid without a profile image' do
    architect = Fabricate.build(:architect, profile_photo: nil)
    expect(architect).to_not be_valid
  end
end
