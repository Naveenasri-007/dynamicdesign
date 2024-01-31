require 'rails_helper'

RSpec.describe Architect, type: :model do
  it 'has a valid factory' do
    architect = Fabricate(:architect)
    expect(architect).to be_valid
  end

  it 'is invalid without an name' do
    architect = Fabricate(:architect, name: nil)
    expect(architect).to_not be_valid
  end

  it 'is invalid without an email' do
    architect = Fabricate(:architect, email: nil)
    expect(architect).to_not be_valid
  end

  it 'is invalid without an phone_number' do
    architect = Fabricate(:architect, number: nil)
    expect(architect).to_not be_valid
  end

  it 'is invalid without an password' do
    architect = Fabricate(:architect, password: nil)
    expect(architect).to_not be_valid
  end

  it 'is invalid without an profile image' do
    architect = Fabricate(:architect, profile_photo: nil)
    expect(architect).to_not be_valid
  end
end
