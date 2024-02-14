# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { Fabricate.create(:user) }
  let(:architect) { Fabricate.create(:architect) }
  let(:design) { Fabricate.create(:design, architect:) }
  let(:comment) { Fabricate.create(:comment, design:, user:) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new comment' do
        expect do
          post :create, params: { design_id: design.id, comment: { content: 'A great design!' } }
        end.to change(Comment, :count).by(1)

        expect(response).to redirect_to(design_path(design))
        expect(flash[:notice]).to eq('Comment was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new comment' do
        expect do
          post :create, params: { design_id: design.id, comment: { content: '' } }
        end.not_to change(Comment, :count)

        expect(response).to render_template('designs/show')
        expect(flash[:alert]).to eq('Comment could not be saved.')
      end
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { design_id: design.id, id: comment.id }
      expect(response).to render_template(:edit)
    end

    it 'redirects to the design page if unauthorized' do
      sign_out user
      get :edit, params: { design_id: design.id, id: comment.id }
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the comment' do
        patch :update, params: { design_id: design.id, id: comment.id, comment: { content: 'Updated comment' } }
        expect(response).to redirect_to(design_path(design))
        expect(flash[:notice]).to eq('Comment was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the comment' do
        patch :update, params: { design_id: design.id, id: comment.id, comment: { content: '' } }
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to eq('Comment could not be updated.')
      end
    end

    describe 'set_comment' do
      it 'redirects to designs_path with a flash message if comment does not exist' do
        get :update, params: { design_id: design.id, id: 999 }

        expect(response).to redirect_to(designs_path)
        expect(flash[:alert]).to eq('Comment does not exist.')
      end
    end
    it 'authorizes comment owner' do
      sign_in user

      patch :update, params: { design_id: design.id, id: comment.id, comment: { content: 'Updated comment' } }
      expect(response).to redirect_to(design_path(design))
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the comment' do
      expect do
        delete :destroy, params: { design_id: design.id, id: comment.id }
      end.to change(Comment, :count).by(0)

      expect(response).to redirect_to(design_path(design))
      expect(flash[:notice]).to eq('Comment was successfully destroyed.')
    end

    it 'authorizes comment owner' do
      sign_in user

      delete :destroy, params: { design_id: design.id, id: comment.id }
      expect(response).to redirect_to(design_path(design))
    end
  end

  describe 'set_design' do
    it 'redirects to designs_path with a flash message if design does not exist' do
      get :create, params: { design_id: 'nonexistent_id' }

      expect(response).to redirect_to(designs_path)
      expect(flash[:alert]).to eq('Design does not exist.')
    end
  end

  describe 'authorize_comment_owner!' do
    it 'redirects to the comment design with a flash message if user is not the owner' do
      another_user = Fabricate.create(:user)
      sign_in another_user

      get :edit, params: { design_id: design.id, id: comment.id }
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      expect(response).to redirect_to(comment.design)
    end
  end
end
