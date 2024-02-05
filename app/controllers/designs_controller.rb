class DesignsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_auth, if: proc { |c| c.request.format.json? }

  before_action :authenticate_user!, only: %i[index show], if: -> { current_user.present? }
  before_action :authenticate_architect!, only: %i[index show new create edit update destroy], if: lambda {
                                                                                                     current_architect.present?
                                                                                                   }
  before_action :set_design, only: %i[show edit update destroy]
  include Pagy::Backend
  ITEMS_PER_PAGE = 12

  def index
    if current_architect.present?
      architect_index
    elsif current_user.present?
      user_index
    else
      render json: { error: 'Unauthorized access, try to login again' }, status: :forbidden
    end
  end

  def show
    respond_to do |format|
      format.html do
        return unless @design.nil?

        flash[:alert] = 'Design not found'
        redirect_to designs_path
      end
      format.json { render json: @design }
    end
  end

  def new
    @design = current_architect.designs.new
  end

  def create
    @design = current_architect.designs.new(design_params)
    if @design.save
      design_create_save_respond
    else
      design_create_failed_respond
    end
  end

  def update
    if @design.architect == current_architect
      if @design.update(design_params)
        design_update_success_respond
      else
        design_update_fail_respond
      end
    else
      design_update_by_user_respond
    end
  end

  def destroy
    if @design.architect == current_architect
      @design.destroy
      design_destroy_respond
    else
      design_destory_respond
    end
  end

  private

  def design_create_save_respond
    respond_to do |format|
      format.html do
        flash[:notice] = 'Design added successfully!'
        redirect_to design_path(@design)
      end
      format.json { render json: @design, status: :created }
    end
  end

  def design_create_failed_respond
    respond_to do |format|
      format.html do
        flash[:alert] = 'Failed to save design'
        flash[:errors] = @design.errors.full_messages
        render :new
      end
      format.json { render json: { errors: @design.errors.full_messages }, status: :unprocessable_entity }
    end
  end

  def design_update_success_respond
    respond_to do |format|
      format.html do
        flash[:notice] = 'Design updated successfully!'
        redirect_to design_path(@design)
      end
      format.json { render json: @design, status: :ok }
    end
  end

  def design_update_fail_respond
    respond_to do |format|
      format.html do
        flash[:alert] = 'Failed to update design'
        render :edit
      end
      format.json { render json: { errors: @design.errors.full_messages }, status: :unprocessable_entity }
    end
  end

  def design_update_by_user_respond
    respond_to do |format|
      format.html do
        flash[:alert] = 'You do not have access to update this design.'
        redirect_to designs_path
      end
      format.json { render json: { errors: 'You do not have access to update this design.' }, status: :forbidden }
    end
  end

  def design_destroy_respond
    respond_to do |format|
      format.html do
        flash[:notice] = 'Design deleted successfully!'
        redirect_to designs_path
      end
      format.json { head :no_content }
    end
  end

  def design_destory_respond
    respond_to do |format|
      format.html do
        flash[:alert] = 'You do not have access to delete this design.'
        redirect_to designs_path
      end
      format.json { render json: { error: 'You do not have access to delete this design.' }, status: :forbidden }
    end
  end

  def architect_index
    respond_to do |format|
      format.html { architect_index_format }
      format.json { render json: current_architect.designs }
    end
  end

  def user_index
    respond_to do |format|
      format.html { user_index_format }
      format.json { render json: Design.all }
    end
  end

  def user_index_format
    if params[:design_name].present?
      @pagy, @designs = pagy(Design.where('design_name LIKE ?', "%#{params[:design_name]}%"), items: ITEMS_PER_PAGE)
    elsif params[:category].present?
      @pagy, @designs = pagy(Design.where('category LIKE ?', "%#{params[:category]}%"),  items: ITEMS_PER_PAGE)
    elsif params[:sort] == 'likes'
      @pagy, @designs = pagy(Design.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC'), items: ITEMS_PER_PAGE)
    elsif params[:sort] == 'dislikes'
      @pagy, @designs = pagy(Design.left_joins(:likes).group(:id).order('COUNT(likes.id) ASC'), items: ITEMS_PER_PAGE)
    else
      @pagy, @designs = pagy(Design.all.includes(:likes, :ratings), items: ITEMS_PER_PAGE)
    end
  end

  def architect_index_format
    if params[:design_name].present?
      @pagy, @designs = pagy(current_architect.designs.where('design_name LIKE ?', "%#{params[:design_name]}%"),
                             items: ITEMS_PER_PAGE)
    elsif params[:category].present?
      @pagy, @designs = pagy(current_architect.designs.where('category LIKE ?', "%#{params[:category]}%"),
                             items: ITEMS_PER_PAGE)
    elsif params[:sort] == 'likes'
      @pagy, @designs = pagy(current_architect.designs.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC'),
                             items: ITEMS_PER_PAGE)
    elsif params[:sort] == 'dislikes'
      @pagy, @designs = pagy(current_architect.designs.left_joins(:likes).group(:id).order('COUNT(likes.id) ASC'),
                             items: ITEMS_PER_PAGE)
    else
      @pagy, @designs = pagy(current_architect.designs.includes(:likes, :ratings), items: ITEMS_PER_PAGE)
    end
  end

  def check_auth
    authenticate_or_request_with_http_basic do |username, password|
      resource = Architect.find_by(email: username)
      sign_in :architect, resource if resource.valid_password?(password)
    end
  end

  def set_design
    @design = Design.find_by(id: params[:id])
  end

  def design_params
    params.require(:design).permit(:design_name, :style, :price_per_sqft, :square_feet, :category, :floorplan,
                                   :time_required, :bio, :brief, :architect_id, :design_url)
  end
end
