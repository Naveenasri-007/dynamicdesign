require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:user) { Fabricate.create(:user) }
  let(:architect) { Fabricate.create(:architect) }
  let(:design) { Fabricate.create(:design, architect:) }

  it 'has a valid rating' do
    rating = Fabricate.build(:rating, user:, design:)
    expect(rating).to be_valid
  end

  it 'is invalid with a value outside the specified range' do
    rating = Fabricate.build(:rating, user:, design:, value: Faker::Number.number(digits: 2))
    expect(rating).to be_invalid
    expect(rating.errors[:value]).to include('Rating must be between 1 and 5')
  end
end
