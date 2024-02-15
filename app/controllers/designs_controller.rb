# frozen_string_literal: true

# DesignsController handles actions related to architect , such as creating, updating,
# and deleting designs. It also includes methods for displaying designs to users and architects.
# This controller requires authentication for certain actions, and supports both HTML and JSON formats.
# Pagination using the Pagy gem is integrated for better user experience.
class DesignsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_auth, if: proc { |c| c.request.format.json? }
  before_action :restrict_access, if: -> { current_architect.nil? && current_user.nil? }
  before_action :authenticate_user!, only: %i[index show], if: -> { current_user.present? }
  before_action :authenticate_architect!, only: %i[index show new create edit update destroy],
                                          if: -> { current_architect.present? }
  before_action :load_designs, only: %i[index]
  before_action :design_by_user_respond, only: %i[new update edit destroy], if: -> { current_user.present? }
  before_action :set_design_for_user, only: %i[show], if: -> { current_user.present? }
  before_action :set_design_for_architect, only: %i[show edit update destroy], if: -> { current_architect.present? }
  include Pagy::Backend
  ITEMS_PER_PAGE = 9

  def index
    respond_to do |format|
      format.html { index_format_for_design }
      format.json { render json: index_format_for_design[1] }
    end
  end

  def show
    respond_to do |format|
      format.html { show_html_response }
      format.json { render json: @design }
    end
  end

  def new
    @design = current_architect.designs.new
  end

  def create
    @design = current_architect.designs.new(design_params)
    @design.save ? design_create_save_respond : design_create_failed_respond
  end

  def update
    @design.update(design_params) ? design_update_success_respond : design_update_fail_respond
  end

  def destroy
    @design.destroy
    design_destroy_success_respond
  end

  private

  # index
  def load_designs
    @all_designs = if current_user.present?
                     Design.all.includes(:likes, :ratings)
                   else
                     current_architect.designs.includes(:likes, :ratings)
                   end
  end

  def index_format_for_design
    if params[:design_name].present? then search_by_design_name
    elsif params[:category].present? then search_by_category
    elsif params[:sort_by].present? then sort_by_likes
    else
      default_search
    end
  end

  def search_by_design_name
    @pagy, @designs = pagy(@all_designs.where('design_name LIKE ?', "%#{params[:design_name]}%"), items: ITEMS_PER_PAGE)
  end

  def search_by_category
    @pagy, @designs = pagy(@all_designs.where(category: params[:category]), items: ITEMS_PER_PAGE)
  end

  def sort_by_likes
    @pagy, @designs = pagy(@all_designs.left_joins(:likes).group(:id).order("COUNT(likes.id) #{params[:sort_type]}"),
                           items: ITEMS_PER_PAGE)
  end

  def default_search
    @pagy, @designs = pagy(@all_designs, items: ITEMS_PER_PAGE)
  end

  # show
  def show_html_response
    return unless @design.nil?

    flash[:alert] = 'Design not found'
    redirect_to designs_path
  end

  # create
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

  # update
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

  def design_by_user_respond
    respond_to do |format|
      format.html do
        flash[:alert] = 'You do not have access to modify this design.'
        redirect_to designs_path
      end
      format.json { render json: { errors: 'You do not have access to modify this design.' }, status: :forbidden }
    end
  end

  # destroy
  def design_destroy_success_respond
    respond_to do |format|
      format.html do
        flash[:notice] = 'Design deleted successfully!'
        redirect_to designs_path
      end
      format.json { head :no_content }
    end
  end

  def restrict_access
    redirect_to root_path
  end

  # json
  def check_auth
    authenticate_or_request_with_http_basic do |username, password|
      if (resource = Architect.find_by(email: username))
        sign_in :architect, resource if resource.valid_password?(password)
      elsif (resource = User.find_by(email: username))
        sign_in(:user, resource) if resource.valid_password?(password)
      else
        restrict_access
      end
    end
  end

  # setdesign
  def set_design_for_user
    @design = Design.find_by(id: params[:id])
  end

  def set_design_for_architect
    @design = current_architect.designs.find_by(id: params[:id])
  end

  # params
  def design_params
    params.require(:design).permit(:design_name, :style, :price_per_sqft, :square_feet, :category, :floorplan,
                                   :time_required, :bio, :brief, :architect_id, :design_url)
  end
end
