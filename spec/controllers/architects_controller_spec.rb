# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArchitectsController, type: :controller do
  let(:user) { Fabricate.create(:user) }
  let(:architect) { Fabricate.create(:architect) }
  let(:design) { Fabricate.create(:design, architect:) }
  let(:booking) { Fabricate.create(:booking, architect:, user:, design:) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    context 'when architect exists' do
      it 'returns a successful response' do
        get :show, params: { id: architect.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when architect does not exist' do
      it 'redirects to architects_path with an error message' do
        get :show, params: { id: 'invalid_id' }
        expect(response).to redirect_to(architects_path)
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'PUT #update_status' do
    before do
      sign_in architect
    end

    context 'when status is accept' do
      it 'updates booking status to accepted' do
        put :update_status, params: { id: booking.id, status: 'accept' }
        expect(booking.reload.status).to eq('accepted')
        expect(response).to redirect_to(bookings_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'when status is reject' do
      it 'updates booking status to rejected' do
        put :update_status, params: { id: booking.id, status: 'reject' }
        expect(booking.reload.status).to eq('rejected')
        expect(response).to redirect_to(bookings_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'when status is invalid' do
      it 'redirects to bookings_path with an alert message' do
        put :update_status, params: { id: booking.id, status: 'invalid_status' }
        expect(response).to redirect_to(bookings_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe '#validate_params' do
    it 'permits the status parameter' do
      params = { architect: { status: 'accepted' } }
      controller.params = ActionController::Parameters.new(params)

      validated_params = controller.send(:validate_params)

      expect(validated_params.to_unsafe_h).to eq({ 'status' => 'accepted' })
    end

    it 'raises an error if architect is missing' do
      params = { some_other_key: 'value' }
      controller.params = ActionController::Parameters.new(params)

      expect { controller.send(:validate_params) }.to raise_error(ActionController::ParameterMissing)
    end

    it 'permits only the status parameter' do
      params = { architect: { status: 'accepted', other_param: 'value' } }
      controller.params = ActionController::Parameters.new(params)

      validated_params = controller.send(:validate_params)

      expect(validated_params.to_unsafe_h).to eq({ 'status' => 'accepted' })
    end
  end
end
