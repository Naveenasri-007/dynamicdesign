class DesignsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show], if: -> { current_user.present? }
  before_action :authenticate_architect!, only: %i[index show new create edit update destroy], if: lambda {
                                                                                                     current_architect.present?
                                                                                                   }
  before_action :set_design, only: %i[edit update destroy]
  include Pagy::Backend

  def index
    if current_architect.present?
      if params[:design_name].present?
        @pagy, @designs = pagy(current_architect.designs.where('design_name LIKE ?', "%#{params[:design_name]}%"),
                               items: 12)
      elsif params[:category].present?
        @pagy, @designs = pagy(current_architect.designs.where('category LIKE ?', "%#{params[:category]}%"), items: 12)
      elsif params[:sort] == 'likes'
        @pagy, @designs = pagy(current_architect.designs.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC'),
                               items: 12)
      elsif params[:sort] == 'dislikes'
        @pagy, @designs = pagy(current_architect.designs.left_joins(:likes).group(:id).order('COUNT(likes.id) ASC'),
                               items: 12)
      else
        @pagy, @designs = pagy(current_architect.designs, items: 12)
      end
    elsif params[:design_name].present?
      @pagy, @designs = pagy(Design.where('design_name LIKE ?', "%#{params[:design_name]}%"), items: 12)
    elsif params[:category].present?
      @pagy, @designs = pagy(Design.where('category LIKE ?', "%#{params[:category]}%"),  items: 12)
    elsif params[:sort] == 'likes'
      @pagy, @designs = pagy(Design.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC'), items: 12)
    elsif params[:sort] == 'dislikes'
      @pagy, @designs = pagy(Design.left_joins(:likes).group(:id).order('COUNT(likes.id) ASC'), items: 12)
    else
      @pagy, @designs = pagy(Design.all, items: 12)
    end
  end

  def show
    @design = Design.find_by(params[:id])
    return unless @design.blank?

    flash[:alert] = 'Design not found!'
    redirect_to designs_path
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
      flash[:errors] = @design.errors.full_messages
      render :new
    end
  end

  def edit
    return if @design.architect == current_architect

    flash[:alert] = 'You do not have access to edit this design.'
    redirect_to designs_path
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
      nil
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
      nil
    end
  end

  private

  def set_design
    @design = Design.find(params[:id])
  end

  def design_params
    params.require(:design).permit(:design_name, :style, :price_per_sqft, :square_feet, :category, :floorplan,
                                   :time_required, :bio, :brief, :architect_id, :design_url)
  end
end
