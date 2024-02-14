# frozen_string_literal: true

# spec/workers/user_worker_spec.rb

require 'rails_helper'

RSpec.describe UserWorker, type: :worker do
  describe '#perform' do
    let!(:user) { Fabricate(:user) }

    context 'when user exists' do
      it 'destroys the user and associated records' do
        expect do
          UserWorker.new.perform(user.id)
        end.to change { User.count }.by(-1)

        expect(Rating.find_by(user_id: user.id)).to be_nil
        expect(Comment.find_by(user_id: user.id)).to be_nil
        expect(Like.find_by(user_id: user.id)).to be_nil
        expect(Booking.find_by(user_id: user.id)).to be_nil
      end
    end

    it 'is valid when the user is deleted, the association is also deleted' do
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
      user.destroy
      expect(User.exists?(user.id)).to be_falsey
      expect(Rating.exists?(rating.id)).to be_falsey
      expect(Like.exists?(like.id)).to be_falsey
      expect(Comment.exists?(comment.id)).to be_falsey
      expect(Booking.exists?(booking.id)).to be_falsey
    end

    context 'when user does not exist' do
      it 'does not raise an error' do
        non_existing_user_id = 999
        expect { UserWorker.new.perform(non_existing_user_id) }.not_to raise_error
      end
    end
  end
end
