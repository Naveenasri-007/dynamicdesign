class API::DesignsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show], if: -> { current_user.present? }
  before_action :authenticate_architect!, only: %i[index show new create edit update destroy], if: lambda {
                                                                                                     current_architect.present?
                                                                                                   }
  before_action :set_design, only: %i[show edit update destroy]
  include Pagy::Backend

  def index
    if current_architect.present?
      render json: current_architect.designs
      # @designs = current_architect.designs
    elsif current_user.present?
      render json: Design.all
      # @designs = Design.all
    else
      render json: { error: 'Unauthorized access, try to login again' }, status: :forbidden
    end
  end

  def show
    render json: @design
  end

  def new
    @design = current_architect.designs.new
  end

  def create
    @design = current_architect.designs.new(design_params)
    if @design.save
      respond_to do |format|
        format.html { redirect_to designs_path }
        format.json  { render json: @design, status: :created }
      end
    else
      render json: { errors: @design.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    if @design.architect == current_architect
      render json: @design
    else
      render json: { error: 'Design not found or unauthorized access' }, status: :not_found
    end
  end

  def update
    if @design.architect == current_architect
      if @design.update(design_params)
        render json: @design
      else
        render json: { errors: @design.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You do not have access to update this design.' }, status: :forbidden
    end
  end

  def destroy
    if @design.architect == current_architect
      @design.destroy
      head :no_content
    else
      render json: { error: 'You do not have access to delete this design.' }, status: :forbidden
    end
  end

  private

  def set_design
    @design = Design.find_by(id: params[:id])
    return if @design

    render json: { error: 'Design not found' }, status: :not_found
  end

  def design_params
    params.require(:design).permit(:design_name, :style, :price_per_sqft, :square_feet, :category, :floorplan,
                                   :time_required, :bio, :brief, :architect_id, :design_url)
  end
end
