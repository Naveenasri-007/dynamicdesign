# frozen_string_literal: true

# spec/models/comment_spec.rb

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { Fabricate(:user) }
  let(:architect) { Fabricate(:architect) }
  let(:design) { Fabricate(:design, architect:) }
  let(:comment) { Fabricate(:comment, user:, design:) }

  describe 'creating a valid comment' do
    it 'is valid with content, associated user, and associated design' do
      new_comment = Comment.new(user:, design:, content: 'This is a valid comment.')
      expect(new_comment).to be_valid
    end
  end

  describe 'creating an invalid comment' do
    it 'is invalid without content' do
      invalid_comment = Fabricate.build(:comment, user:, design:, content: nil)
      expect(invalid_comment).to be_invalid
      expect(invalid_comment.errors[:content]).to include("can't be blank")
    end

    it 'is invalid without design' do
      invalid_comment = Fabricate.build(:comment, user:, design: nil)
      expect(invalid_comment).to be_invalid
      expect(invalid_comment.errors[:design]).to include('must exist')
    end

    it 'is invalid without user' do
      invalid_comment = Fabricate.build(:comment, user: nil, design:)
      expect(invalid_comment).to be_invalid
      expect(invalid_comment.errors[:user]).to include('must exist')
    end
  end
end
