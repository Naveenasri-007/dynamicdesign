# frozen_string_literal: true

# spec/models/design_spec.rb

require 'rails_helper'

RSpec.describe Design, type: :model do
  it 'has a valid design' do
    # Create a valid Architect instance first
    architect = Fabricate(:architect)
    # Now create a Design instance with the associated Architect
    design = Fabricate(:design, architect:)
    expect(design).to be_valid
  end

  it 'is invalid without architect' do
    design = Fabricate.build(:design, architect: nil)
    expect(design).to be_invalid
    expect(design.errors[:architect]).to include('must exist')
  end

  it 'is invalid without design url' do
    design = Fabricate.build(:design, design_url: nil)
    expect(design).to be_invalid
    expect(design.errors[:design_url]).to include('Design URLs are null or empty')
  end

  it 'is invalid without design name' do
    design = Fabricate.build(:design, design_name: nil)
    expect(design).to be_invalid
    expect(design.errors[:design_name]).to include('design Name must be between 3 and 30 characters')
  end

  it 'is invalid price per sqft' do
    design = Fabricate.build(:design, price_per_sqft: -1)
    expect(design).to be_invalid
    expect(design.errors[:price_per_sqft]).to include('Price must be a non-negative value')
  end

  it 'is invalid design category' do
    design = Fabricate.build(:design, category: '6bhk')
    expect(design).to be_invalid
    expect(design.errors[:category]).to include('Invalid design category')
  end

  it 'is invalid design floorplan' do
    design = Fabricate.build(:design, floorplan: 'LivingRoom')
    expect(design).not_to be_valid
    expect(design.errors[:floorplan]).to include('Invalid design floor plan')
  end

  it 'is invalid design squarefeet' do
    design = Fabricate.build(:design, square_feet: -1)
    expect(design).not_to be_valid
    expect(design.errors[:square_feet]).to include('Square feet must be a non-negative value')
  end

  it 'is invalid with a brief outside the specified length range' do
    design = Fabricate.build(:design, brief: 'A' * 5)
    expect(design).to be_invalid
    expect(design.errors[:brief]).to include('Brief must be between 10 and 2000 characters')
  end

  it 'is invalid with a bio outside the specified length range' do
    design = Fabricate.build(:design, bio: 'A')
    expect(design).to be_invalid
    expect(design.errors[:bio]).to include('Bio must be between 4 and 80 characters')
  end
end
