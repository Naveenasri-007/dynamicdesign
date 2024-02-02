require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    user = Fabricate.build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without a name' do 
    user = Fabricate.build(:user, name: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid without an email' do
    user = Fabricate.build(:user, email: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid without a phone_number' do
    user = Fabricate.build(:user, phone_number: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid without a password' do 
    user = Fabricate.build(:user, password: nil)
    expect(user).to_not be_valid
  end
end
