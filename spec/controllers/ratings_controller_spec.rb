require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:user) { Fabricate.create(:user) }
  let(:architect) { Fabricate.create(:architect) }

  describe 'POST #create' do
    let(:design) { Fabricate.create(:design, architect:) }

    context 'when user is authenticated' do
      before { sign_in user }

      it 'creates a new rating' do
        post :create, params: { design_id: design.id, rating: { value: 5 } }
        expect(response).to redirect_to(design)
        expect(flash[:notice]).to eq('Rating added successfully.')
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign-in page' do
        post :create, params: { design_id: design.id, rating: { value: 3 } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:design) { Fabricate.create(:design, architect:) }
    let(:rating) { Fabricate.create(:rating, user:, design:) }

    before { sign_in user }

    it 'updates an existing rating' do
      patch :update, params: { design_id: design.id, id: rating.id, rating: { value: 4 } }
      expect(response).to redirect_to(design)
      expect(flash[:notice]).to eq('Rating updated successfully.')
    end

    it 'handles non-existing rating' do
      patch :update, params: { design_id: design.id, id: 999, rating: { value: 4 } }
      expect(response).to redirect_to(design)
      expect(flash[:alert]).to eq('Rating not found.')
    end
  end

  describe 'DELETE #destroy' do
    let(:design) { Fabricate.create(:design, architect:) }
    let(:rating) { Fabricate.create(:rating, user:, design:) }

    before { sign_in user }

    it 'deletes an existing rating' do
      delete :destroy, params: { design_id: design.id, id: rating.id }
      expect(response).to redirect_to(design)
      expect(flash[:notice]).to eq('Rating deleted successfully.')
    end

    it 'handles non-existing rating' do
      delete :destroy, params: { design_id: design.id, id: 999 }
      expect(response).to redirect_to(design)
      expect(flash[:alert]).to eq('Rating not found.')
    end
  end
end
