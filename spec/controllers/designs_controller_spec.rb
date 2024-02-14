# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DesignsController, type: :controller do
  let(:architect) { Fabricate.create(:architect) }
  let(:design) { Fabricate.create(:design, architect:) }
  let(:user) { Fabricate.create(:user) }

  before { sign_in architect }

  describe 'GET #index' do
    context 'The index for user' do
      before { sign_in user }
      it 'returns a success response for designs for user' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end

      it 'renders designs in JSON format' do
        authenticate_user(user)
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response[0]).to be_falsey
      end

      it 'renders designs in JSON format check auth' do
        invalid_password = 'Abcdef@123'
        request.headers['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Basic.encode_credentials(user.email, invalid_password)
        get :index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not signin to both user and architect access denied ' do
        invalid_password = 'Abcdef@123'
        request.headers['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Basic.encode_credentials(nil, invalid_password)
        get :index, format: :json
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end

    it 'returns a success response for designs' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end

    context 'when format is JSON' do
      it 'renders designs in JSON format' do
        authenticate_architect(architect)
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response[0]).to be_falsey
      end

      context 'when authentication is ' do
        it 'renders designs in JSON format check auth' do
          invalid_password = 'Abcdef@123'
          request.headers['HTTP_AUTHORIZATION'] =
            ActionController::HttpAuthentication::Basic.encode_credentials(architect.email, invalid_password)
          get :index, format: :json
          expect(response).to have_http_status(:unauthorized)
        end
      end

      it 'renders designs with search parameter' do
        authenticate_architect(architect)
        design_with_search = Fabricate.create(:design, design_name: 'Design', architect:)
        get :index, params: { design_name: 'Design' }, format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          hash_including('id' => design_with_search.id)
        )
      end

      it 'renders designs with category parameter' do
        authenticate_architect(architect)
        design_with_category = Fabricate.create(:design, category: 'livingroom', architect:)
        get :index, params: { category: 'livingroom' }, format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          hash_including('id' => design_with_category.id)
        )
      end

      it 'renders designs sorted by likes in descending order' do
        authenticate_architect(architect)

        design_with_likes_three = Fabricate(:design, architect:)
        3.times { Fabricate(:like, design: design_with_likes_three, user:) }

        design_with_likes_five = Fabricate(:design, architect:)
        5.times { Fabricate(:like, design: design_with_likes_five, user:) }

        get :index, params: { sort_by: 'likes', sort_type: 'DESC' }, format: :json

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        design_ids = json_response.map { |design| design['id'] }
        expect(design_ids).to include(design_with_likes_three.id, design_with_likes_five.id)
      end
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
      authenticate_architect(architect)
      design = Fabricate(:design, architect:)
      get :show, params: { id: design.id }, format: :json
    end

    it 'returns a success response with json' do
      authenticate_user(user)
      design = Fabricate(:design, architect:)
      get :show, params: { id: design.id }, format: :json
    end

    context 'when format is HTML' do
      it 'renders the show template' do
        get :show, params: { id: design.id }
        expect(response).to render_template(:show)
      end

      it 'assigns @design' do
        get :show, params: { id: design.id }
        expect(assigns(:design)).to eq(design)
      end
    end

    context 'when format is JSON' do
      it 'renders design in JSON format' do
        authenticate_architect(architect)
        get :show, params: { id: design.id }, format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_instance_of(Hash)
        expect(json_response['id']).to eq(design.id)
      end
    end

    context 'when design is not found' do
      it 'sets a flash alert and redirects to designs_path for HTML format' do
        get :show, params: { id: 'nonexistent' }
        expect(flash[:alert]).to eq('Design not found')
        expect(response).to redirect_to(designs_path)
      end

      it 'returns the design in JSON format' do
        authenticate_architect(architect)
        get :show, params: { id: design.id }, format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(design.id)
      end
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

    context 'with valid parameters' do
      it 'creates a new design' do
        authenticate_architect(architect)

        expect do
          post :create, params: { design: valid_design_params, format: :json }
        end.to change(Design, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response['id']).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new design' do
        authenticate_architect(architect)
        invalid_design_params = { design_name: '', style: 'Traditional' }

        expect do
          post :create, params: { design: invalid_design_params, format: :json }
        end.not_to change(Design, :count)

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Design name design Name must be between 3 and 30 characters')
        expect(json_response['errors']).to include('Bio Bio must be between 4 and 80 characters')
        expect(json_response['errors']).to include('Brief Brief must be between 10 and 2000 characters')
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

    context 'when the architect is the owner' do
      it 'updates the design with valid parameters' do
        authenticate_architect(architect)
        new_design_params = { design_name: 'Updated Design' }

        put :update, params: { id: design.id, design: new_design_params, format: :json }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        design.reload
        expect(design.design_name).to eq('Updated Design')

        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(design.id)
        expect(json_response['design_name']).to eq('Updated Design')
      end

      it 'fails to update the design with invalid parameters' do
        authenticate_architect(architect)
        invalid_design_params = { design_name: '' }

        put :update, params: { id: design.id, design: invalid_design_params, format: :json }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Design name design Name must be between 3 and 30 characters')

        design.reload
        expect(design.design_name).not_to eq('')
      end
    end

    context 'when format is HTML' do
      it 'sets flash alert and redirects to designs_path' do
        another_user = Fabricate.create(:user)
        sign_in another_user
        allow(controller).to receive(:current_user).and_return(another_user)
        put :update, params: { id: design.id, design: valid_design_params, format: :html }
        expect(flash[:alert]).to eq('You do not have access to modify this design.')
        expect(response).to redirect_to(designs_path)
      end
    end

    context 'when format is JSON' do
      it 'renders JSON with an error message and :unauthorized status' do
        another_user = Fabricate.create(:user)
        sign_in another_user
        allow(controller).to receive(:current_user).and_return(another_user)
        put :update, params: { id: design.id, design: valid_design_params, format: :json }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
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

    context 'when the architect is the owner' do
      it 'destroys the design' do
        authenticate_architect(architect)

        expect do
          delete :destroy, params: { id: design.id, format: :json }
        end.to change(Design, :count).by(0)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the architect is not the owner' do
      it 'does not destroy the design and responds with no_content status' do
        authenticate_architect(architect)

        expect do
          delete :destroy, params: { id: design.id, format: :json }
        end.not_to change(Design, :count)

        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end

    context 'when format is JSON' do
      it 'renders JSON with an error message and :unauthorized status' do
        another_user = Fabricate.create(:user)
        sign_in another_user
        allow(controller).to receive(:current_user).and_return(another_user)
        delete :destroy, params: { id: design.id, format: :json }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end

  private

  def authenticate_architect(architect)
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(architect.email, architect.password)
  end

  def authenticate_user(user)
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password)
  end

  def valid_design_params
    Fabricate.attributes_for(:design, architect:)
  end

  def invalid_design_params
    { invalid_attribute: 'value' }
  end
end
