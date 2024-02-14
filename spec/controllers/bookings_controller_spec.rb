# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  let(:user) { Fabricate.create(:user) }
  let(:architect) { Fabricate.create(:architect) }
  let(:design) { Fabricate.create(:design, architect:) }
  let(:booking) { Fabricate.attributes_for(:booking, architect:, design:) }

  before { sign_in user }

  describe 'GET #index' do
    context 'when user is signed in' do
      it 'returns a success response' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'assigns user bookings to @bookings' do
        design = Fabricate.create(:design, architect:)
        booking = Fabricate.create(:booking, user:, architect:, design:)
        get :index
        expect(assigns(:bookings)).to eq([booking])
      end
    end

    context 'when architect is signed in' do
      before do
        sign_out user
        sign_in architect
      end

      it 'returns a success response to the current architect' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end

      it 'assigns architect bookings to @bookings' do
        design = Fabricate.create(:design, architect:)
        booking = Fabricate.create(:booking, user:, architect:, design:)
        get :index
        expect(assigns(:bookings)).to eq([booking])
      end
    end

    context 'when the person is not both the user and the architect' do
      before do
        sign_out user
        sign_out architect
      end

      it 'does not return a success response' do
        get :index
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(nil)
      end
    end
  end

  describe 'GET #new' do
    context 'with a valid design_id' do
      let(:booking) { Fabricate.create(:booking, user:, architect:, design:) }

      it 'returns a success response' do
        get :new, params: { design_id: design.id }
        expect(response).to have_http_status(:success)
        expect(booking.architect_id).to eq(design.architect_id)
      end
    end

    context 'with an invalid design_id' do
      it 'redirects to designs_path with an error flash message' do
        get :new, params: { design_id: 'invalid_id' }
        expect(response).to redirect_to(designs_path)
        expect(flash[:error]).to eq('Design not found.')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:design) { Fabricate.create(:design, architect:) }

      it 'creates a new booking' do
        expect do
          post :create, params: { booking: }
        end.to change(Booking, :count).by(1)
        expect(response).to redirect_to(architects_path)
        expect(flash[:notice]).to eq('Booking created successfully.')
      end
    end

    context 'with invalid parameters' do
      it 'renders the new template' do
        post :create, params: { booking: { invalid_attribute: 'value' } }
        expect(response).to render_template('new')
      end
    end
  end
end
