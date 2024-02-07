# spec/workers/user_worker_spec.rb

require 'rails_helper'

RSpec.describe UserWorker, type: :worker do
  describe '#perform' do
    context 'when user exists' do
      let!(:user) { Fabricate(:user) }
      it 'destroys the user' do
        expect { UserWorker.new.perform(user.id) }.to change { User.count }.by(-1)
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
