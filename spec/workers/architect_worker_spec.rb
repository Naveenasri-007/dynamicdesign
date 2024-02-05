# spec/workers/architect_worker_spec.rb

require 'rails_helper'

RSpec.describe ArchitectWorker, type: :worker do
  describe '#perform' do
    let(:architect_id) { 1 }

    context 'when architect exists' do
      let!(:architect) { Fabricate(:architect, id: architect_id) }

      it 'destroys the architect' do
        expect { ArchitectWorker.new.perform(architect_id) }.to change { Architect.count }.by(-1)
      end
    end

    context 'when architect does not exist' do
      it 'does not raise an error' do
        expect { ArchitectWorker.new.perform(architect_id) }.not_to raise_error
      end
    end
  end
end
