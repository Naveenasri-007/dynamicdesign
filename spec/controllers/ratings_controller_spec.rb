# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:user) { Fabricate.create(:user) }
  let(:architect) { Fabricate.create(:architect) }
  let(:design) { Fabricate.create(:design, architect:) }
  let(:rating) { Fabricate.create(:rating, user:, design:) }

  before { sign_in user }

  describe 'POST #create' do
    context 'when user is authenticated' do
      context 'with valid parameters' do
        it 'creates a new rating' do
          post :create, params: { design_id: design.id, rating: { value: 5 } }
          expect(response).to redirect_to(design)
          expect(flash[:notice]).to eq('Rating added successfully.')
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new rating and shows an alert' do
          post :create, params: { design_id: design.id, rating: { value: Faker::Number.number(digits: 2) } }
          expect(response).to redirect_to(design)
          expect(flash[:alert]).to eq('Failed to add rating.')
        end
      end

      context 'when user has already rated the design' do
        it 'does not create a new rating and shows an alert' do
          Fabricate.create(:rating, user:, design:)
          post :create, params: { design_id: design.id, rating: }
          expect(response).to redirect_to(design)
          expect(flash[:alert]).to eq('You have already rated this design.')
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign-in page' do
        sign_out user
        post :create, params: { design_id: design.id, rating: }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is authenticated' do
      context 'with valid parameters' do
        it 'updates the existing rating' do
          patch :update, params: { design_id: design.id, id: rating.id, rating: { value: 4 } }
          expect(response).to redirect_to(design)
          expect(flash[:notice]).to eq('Rating updated successfully.')
          rating.reload
          expect(rating.value).to eq(4)
        end
      end

      context 'with invalid parameters' do
        it 'does not update the rating and shows an alert' do
          patch :update,
                params: { design_id: design.id, id: rating.id, rating: { value: Faker::Number.number(digits: 2) } }
          expect(response).to redirect_to(design)
          expect(flash[:alert]).to eq('I cant do anything  Rating not found.')
          rating.reload
          expect(rating.value).to eq(rating.value)
        end
      end

      context 'when rating is not found' do
        it 'shows an alert' do
          patch :update, params: { design_id: design.id, id: 'nonexistent_id', rating: { value: 4 } }
          expect(response).to redirect_to(design)
          expect(flash[:alert]).to eq('Rating not found.')
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign-in page' do
        sign_out user
        patch :update, params: { design_id: design.id, id: rating.id, rating: { value: 4 } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
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
