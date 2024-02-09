# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    user = Fabricate.build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = Fabricate.build(:user, name: nil)
    expect(user).to be_invalid
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without an email' do
    user = Fabricate.build(:user, email: nil)
    expect(user).to be_invalid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a phone_number' do
    user = Fabricate.build(:user, phone_number: nil)
    expect(user).to be_invalid
    expect(user.errors[:phone_number]).to include('Phone number is not valid')
  end

  it 'is invalid without a password' do
    user = Fabricate.build(:user, password: nil)
    expect(user).to be_invalid
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid when ratings are present' do
    user = Fabricate.build(:user, ratings: [Fabricate.build(:rating), Fabricate.build(:rating)])
    expect(user).to be_invalid
  end

  it 'is valid when the user is deleted, the associated rating is also deleted' do
    user = Fabricate.build(:user)
    architect = Fabricate.build(:architect)
    design = Fabricate.build(:design, architect:)
    rating = Fabricate(:rating, user:, design:)
    user.destroy
    expect(Rating.exists?(rating.id)).to be_falsey
  end

  it 'is invalid when ratings are present' do
    user = Fabricate.build(:user, ratings: [Fabricate.build(:rating), Fabricate.build(:rating)])
    expect(user).to be_invalid
  end

  it 'is invalid when bookings are present' do
    user = Fabricate.build(:user, bookings: [Fabricate.build(:booking), Fabricate.build(:booking)])
    expect(user).to be_invalid
  end
end
