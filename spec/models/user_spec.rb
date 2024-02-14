# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    user = Fabricate.build(:user)
    expect(user).to be_valid
  end

  it 'is valid when the user is created, the associated is also able to create' do
    user = Fabricate(:user)
    architect = Fabricate(:architect)
    design = Fabricate(:design, architect:)
    rating = Fabricate(:rating, user:, design:)
    like = Fabricate(:like, user:, design:)
    comment = Fabricate(:comment, user:, design:)
    booking = Fabricate(:booking, user:, design:, architect:)
    expect(User.exists?(user.id)).to be_truthy
    expect(Rating.exists?(rating.id)).to be_truthy
    expect(Like.exists?(like.id)).to be_truthy
    expect(Comment.exists?(comment.id)).to be_truthy
    expect(Booking.exists?(booking.id)).to be_truthy
  end

  it 'is valid when the user is deleted, the association is also deleted' do
    user = Fabricate(:user)
    architect = Fabricate(:architect)
    design = Fabricate(:design, architect:)
    rating = Fabricate(:rating, user:, design:)
    like = Fabricate(:like, user:, design:)
    comment = Fabricate(:comment, user:, design:)
    booking = Fabricate(:booking, user:, design:, architect:)
    user.destroy
    expect(User.exists?(user.id)).to be_falsey
    expect(Rating.exists?(rating.id)).to be_falsey
    expect(Like.exists?(like.id)).to be_falsey
    expect(Comment.exists?(comment.id)).to be_falsey
    expect(Booking.exists?(booking.id)).to be_falsey
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

  it 'is invalid when ratings are already present' do
    user = Fabricate.build(:user, ratings: [Fabricate.build(:rating), Fabricate.build(:rating)])
    expect(user).to be_invalid
  end

  it 'is invalid when bookings are present' do
    user = Fabricate.build(:user, bookings: [Fabricate.build(:booking), Fabricate.build(:booking)])
    expect(user).to be_invalid
  end

  it 'is invalid when comments are present' do
    user = Fabricate.build(:user, comments: [Fabricate.build(:comment), Fabricate.build(:comment)])
    expect(user).to be_invalid
  end

  it 'is invalid when likes are present' do
    user = Fabricate.build(:user, likes: [Fabricate.build(:like), Fabricate.build(:like)])
    expect(user).to be_invalid
  end
end
