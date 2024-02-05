require 'rails_helper'

RSpec.describe DesignsController, type: :controller do
  let(:architect) { Fabricate.create(:architect) }

  before { sign_in architect }

  describe 'GET #index' do
    it 'returns a success response for designs' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      design = Fabricate(:design, architect:)
      get :show, params: { id: design.id }
      expect(response).to be_successful
      expect(response).to render_template(:show)
    end

    it 'returns a success response with json' do
      authenticate_architect
      design = Fabricate(:design, architect:)
      get :show, params: { id: design.id }, format: :json
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new design' do
        expect do
          post :create, params: { design: valid_design_params }
        end.to change(Design, :count).by(1)
      end

      it 'redirects to the created design' do
        post :create, params: { design: valid_design_params }
        expect(response).to redirect_to(Design.last)
      end
    end

    context 'with invalid parameters' do
      it 'renders the new template' do
        post :create, params: { design: invalid_design_params }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      design = Fabricate(:design, architect:)
      get :edit, params: { id: design.id }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      it 'updates the requested design' do
        design = Fabricate(:design, architect:)
        put :update, params: { id: design.id, design: { design_name: 'Updated Design' } }
        design.reload
        expect(design.design_name).to eq('Updated Design')
      end

      it 'redirects to the design' do
        design = Fabricate(:design, architect:)
        put :update, params: { id: design.id, design: { design_name: 'Updated Design' } }
        expect(response).to redirect_to(design)
      end
    end

    context 'with invalid parameters' do
      it 'renders the edit template' do
        design = Fabricate(:design, architect:)
        put :update, params: { id: design.id, design: { design_name: nil } }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested design' do
      design = Fabricate(:design, architect:)
      expect do
        delete :destroy, params: { id: design.id }
      end.to change(Design, :count).by(-1)
    end

    it 'redirects to the designs list' do
      design = Fabricate(:design, architect:)
      delete :destroy, params: { id: design.id }
      expect(response).to redirect_to(designs_url)
    end
  end

  private

  def authenticate_architect
    user = architect.email
    pw = architect.password
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, pw)
  end

  def valid_design_params
    Fabricate.attributes_for(:design, architect:)
  end

  def invalid_design_params
    { invalid_attribute: 'value' }
  end
end
