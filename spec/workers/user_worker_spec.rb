# spec/workers/user_worker_spec.rb

require 'rails_helper'

RSpec.describe UserWorker, type: :worker do
  describe '#perform' do
    context 'when user exists' do
      let!(:user) { Fabricate(:user) }

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

    context 'when user does not exist' do
      let!(:user) { Fabricate(:user) }
      it 'does not raise an error' do
        expect { UserWorker.new.perform(user.id) }.not_to raise_error
      end
    end

  end
end
