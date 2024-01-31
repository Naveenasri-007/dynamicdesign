require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    user = Fabricate(:user)
    expect(user).to be_valid
  end

  it 'is invalid without an name' do 
    user = Fabricate(:user, name: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid without an email' do
    user = Fabricate(:user, email: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid without an phone_number' do
    user = Fabricate(:user, phone_number: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid without an password' do 
    user = Fabricate(:user , password: nil)
    expect(user).to_not be_valid
  end
end
