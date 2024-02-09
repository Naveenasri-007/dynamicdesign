# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Architect, type: :model do
  it 'has a valid factory' do
    architect = Fabricate.build(:architect)
    expect(architect).to be_valid
  end

  it 'is invalid without a name' do
    architect = Fabricate.build(:architect, name: nil)
    expect(architect).to_not be_valid
    expect(architect.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without an email' do
    architect = Fabricate.build(:architect, email: nil)
    expect(architect).to_not be_valid
    expect(architect.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a phone_number' do
    architect = Fabricate.build(:architect, number: nil)
    expect(architect).to_not be_valid
    expect(architect.errors[:number]).to include('Phone number is not valid')
  end

  it 'is invalid without a password' do
    architect = Fabricate.build(:architect, password: nil)
    expect(architect).to_not be_valid
    expect(architect.errors[:password]).to include("can't be blank")
  end

  it 'is invalid without a profile image' do
    architect = Fabricate.build(:architect, profile_photo: nil)
    expect(architect).to_not be_valid
    expect(architect.errors[:profile_photo]).to include("can't be blank")
  end

  it 'is valid when designs are present' do
    architect = Fabricate.build(:architect, designs: [Fabricate.build(:design), Fabricate.build(:design)])
    expect(architect).to be_valid
  end

  it 'is invalid when bookings are present' do
    architect = Fabricate.build(:architect, bookings: [Fabricate.build(:booking), Fabricate.build(:booking)])
    expect(architect).to be_invalid
  end

  it 'is valid when the architect is deleted, the associated designs are also deleted' do
    architect = Fabricate.build(:architect)
    design = Fabricate(:design, architect:)
    architect.destroy
    expect(Design.exists?(design.id)).to be_falsey
  end
end
