# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:user) { Fabricate.create(:user) }
  let(:architect) { Fabricate.create(:architect) }

  it 'valid bookings' do
    design = Fabricate(:design, architect:)
    booking = Fabricate(:booking, user:, design:, architect:)
    expect(Booking.exists?(booking.id)).to be_truthy
    design.destroy
    expect(Booking.exists?(booking.id)).to be_falsey
  end

  it 'is invalid without expected amount' do
    booking = Fabricate.build(:booking, user:, architect:, expected_amount: nil)
    expect(booking).to be_invalid
    expect(booking.errors[:expected_amount]).to include('Expected amount must be a positive integer')
  end

  it 'is invalid with non-positive expected amount' do
    booking = Fabricate.build(:booking, user:, architect:, expected_amount: -1)
    expect(booking).to be_invalid
    expect(booking.errors[:expected_amount]).to include('Expected amount must be a positive integer')
  end

  it 'is invalid without expected months' do
    booking = Fabricate.build(:booking, user:, architect:, expected_months: nil)
    expect(booking).to be_invalid
    expect(booking.errors[:expected_months]).to include('Expected months must be a positive integer')
  end

  it 'is invalid with non-positive expected months' do
    booking = Fabricate.build(:booking, user:, architect:, expected_months: -1)
    expect(booking).to be_invalid
    expect(booking.errors[:expected_months]).to include('Expected months must be a positive integer')
  end

  it 'is invalid without design name' do
    booking = Fabricate.build(:booking, user:, architect:, design_name: nil)
    expect(booking).to be_invalid
    expect(booking.errors[:design_name]).to include('Design name is null or empty')
  end

  it 'is invalid without design URL' do
    booking = Fabricate.build(:booking, user:, architect:, design_url: nil)
    expect(booking).to be_invalid
    expect(booking.errors[:design_url]).to include('Design URL is null or empty')
  end

  it 'is invalid without message' do
    booking = Fabricate.build(:booking, user:, architect:, message: nil)
    expect(booking).to be_invalid
    expect(booking.errors[:message]).to include('Message is null or empty')
  end
end
