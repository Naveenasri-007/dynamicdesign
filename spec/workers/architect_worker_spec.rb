# frozen_string_literal: true

# spec/workers/architect_worker_spec.rb

require 'rails_helper'

RSpec.describe ArchitectWorker, type: :worker do
  describe '#perform' do
    let!(:architect) { Fabricate(:architect) }

    context 'when architect exists' do
      it 'destroys the architect' do
        expect { ArchitectWorker.new.perform(architect.id) }.to change { Architect.count }.by(-1)
        expect(Design.find_by(architect_id: architect.id)).to be_nil
        expect(Booking.find_by(id: architect.id)).to be_nil
      end
    end

    context 'when architect does not exist' do
      it 'does not raise an error' do
        non_existing_architect_id = 999
        expect { ArchitectWorker.new.perform(non_existing_architect_id) }.not_to raise_error
      end
    end
  end
end
