require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:user) { Fabricate.create(:user) }
  let(:architect) { Fabricate.create(:architect) }

  it 'has a valid rating' do
    design = Fabricate.create(:design, architect:)
    rating = Fabricate.build(:rating, user:, design:, value: 3)
    expect(rating).to be_valid
  end

  it 'is invalid with a value outside the specified range' do
    design = Fabricate.create(:design, architect:)
    rating = Fabricate.build(:rating, user:, design:, value: 6)
    rating.valid?
    expect(rating.errors[:value]).to include('Rating must be between 1 and 5')
    expect(rating).to be_invalid
  end
end
