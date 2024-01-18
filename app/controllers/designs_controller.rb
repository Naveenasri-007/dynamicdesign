class DesignsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show], if: -> { current_user.present? }
  before_action :authenticate_architect!, only: [:index, :show, :new, :create,  :edit, :update, :destroy], if: -> { current_architect.present? }
  before_action :set_design, only: [:edit, :update, :destroy]  
  include Pagy::Backend

  def index
    if current_architect.present?
      if params[:design_name].present?
        @pagy, @designs = pagy(current_architect.designs.where("design_name LIKE ?", "%#{params[:design_name]}%"), items: 2)
      elsif params[:category].present?
        @pagy, @designs = pagy(current_architect.designs.where("category LIKE ?", "%#{params[:category]}%"), items: 2)
      elsif params[:sort] == 'likes'
        @pagy, @designs = pagy(current_architect.designs.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC'), items: 2)
      elsif params[:sort] == 'dislikes'
        @pagy, @designs = pagy(current_architect.designs.left_joins(:likes).group(:id).order('COUNT(likes.id) ASC'), items: 2)
      else
        @pagy, @designs = pagy(current_architect.designs, items: 2)
      end
    else
      if params[:design_name].present?
        @pagy, @designs = pagy(Design.where("design_name LIKE ?", "%#{params[:design_name]}%"),  items: 2)
      elsif params[:category].present?
        @pagy, @designs = pagy(Design.where("category LIKE ?", "%#{params[:category]}%"),  items: 2)
      elsif params[:sort] == 'likes'
        @pagy, @designs = pagy(Design.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC'), items: 2)
      elsif params[:sort] == 'dislikes'
        @pagy, @designs = pagy(Design.left_joins(:likes).group(:id).order('COUNT(likes.id) ASC'), items: 2)
      else
        @pagy, @designs = pagy(Design.all ,  items: 2)
      end
    end
  end

  def show
    @design = Design.find(params[:id])
  end

  def new
    @design = current_architect.designs.new
  end

  def create
    @design = current_architect.designs.new(design_params)
    if @design.save
      flash[:notice] = 'Design added successfully!'
      redirect_to design_path(@design)
    else
      flash[:alert] = 'Failed to create design'
      render :new
    end
  end

  def edit
    unless @design.architect == current_architect
      flash[:alert] = 'You do not have access to edit this design.'
      redirect_to designs_path
    end
  end

  def update
    if @design.architect == current_architect
      if @design.update(design_params)
        flash[:notice] = 'Design updated successfully!'
        redirect_to design_path(@design)
      else
        flash[:alert] = 'Failed to update design'
        render :edit
      end
    else
     flash[:alert] = 'You do not have access to update this design.'
     redirect_to designs_path
     return
    end
  end

  def destroy
    if @design.architect == current_architect
      @design.destroy
      flash[:notice] = 'Design deleted successfully!'
      redirect_to designs_path
    else
      flash[:alert] = 'You do not have access to delete this design.'
      redirect_to designs_path
      return
    end
  end

  private

  def set_design
    @design = Design.find(params[:id])
  end

  def design_params
    params.require(:design).permit(:design_name, :style, :price_per_sqft, :square_feet, :category, :floorplan, :time_required, :bio, :brief, :architect_id)
  end
end
