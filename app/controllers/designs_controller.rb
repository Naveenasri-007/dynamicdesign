class DesignsController < ApplicationController
  before_action :set_design, only: [:show, :edit, :update, :destroy]

  def index
    @designs = Design.all
  end

  def show
  end

  def new
    @design = Design.new
  end

  def create
    @design = Design.new(design_params)
    if @design.save
      flash[:notice] = 'Design added successfully!'
      redirect_to design_path(@design)
    else
      flash[:alert] = 'Failed to create design'
      render :new
    end
  end
  #this edit code

  def edit
  end

  def update
    if @design.update(design_params)
      flash[:notice] = 'Design updated successfully!'
      redirect_to design_path(@design)
    else
      flash[:alert] = 'Failed to update design'
      render :edit
    end
  end

  def destroy
    @design.destroy
    flash[:notice] = 'Design deleted successfully!'
    redirect_to designs_path
  end

  private

  def set_design
    @design = Design.find(params[:id])
  end

  def design_params
    params.require(:design).permit(:design_name, :style, :price_per_sqft, :square_feet, :category, :floorplan, :time_required, :bio, :brief, :architect_id)
  end
end
