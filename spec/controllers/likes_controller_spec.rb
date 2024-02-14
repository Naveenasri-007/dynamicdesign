# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { Fabricate.create(:user) }
  let(:architect) { Fabricate.create(:architect) }
  let(:design) { Fabricate.create(:design, architect:) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'when the user has not already liked the design' do
      it 'creates a new like' do
        expect do
          post :create, params: { design_id: design.id }
        end.to change(Like, :count).by(1)

        expect(response).to redirect_to(design_path(design))
        expect(flash[:notice]).to be_nil
      end
    end

    context 'when the user has already liked the design' do
      before do
        design.likes.create(user_id: user.id)
      end

      it 'does not create a new like and sets flash notice' do
        expect do
          post :create, params: { design_id: design.id }
        end.not_to change(Like, :count)

        expect(response).to redirect_to(design_path(design))
        expect(flash[:notice]).to eq("You can't like more than once")
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:like) { design.likes.create(user_id: user.id) }

    it 'deletes the like' do
      expect do
        delete :destroy, params: { design_id: design.id, id: like.id }
      end.to change(Like, :count).by(-1)

      expect(response).to redirect_to(design_path(design))
      expect(flash[:notice]).to eq('like deleted successfully')
    end
  end

  describe 'authentication checks' do
    context 'when user is not authenticated' do
      before do
        sign_out user
      end

      it 'redirects to the sign-in page for create action' do
        post :create, params: { design_id: design.id }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to the sign-in page for destroy action' do
        delete :destroy, params: { design_id: design.id, id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
