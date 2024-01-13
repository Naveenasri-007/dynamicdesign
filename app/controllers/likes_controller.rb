class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :find_design, only: [:create, :destroy]
    before_action :find_like, only: [:destroy]

    def create
      if already_liked?
        flash[:notice] = "You can't like more than once"
      else
        @design.likes.create(user_id: current_user.id)
      end 
      redirect_to design_path(@design)
    end

    def destroy
        @like.destroy
        flash[:notice] = "like deleted successfully"
        redirect_to design_path(@design)
      end
  
    private
  
    def find_design
      @design = Design.find(params[:design_id])
    end
  
    def find_like
      @like = @design.likes.find(params[:id])
    end

    def already_liked?
      Like.where(user_id: current_user.id, design_id: @design.id).exists?
    end
  end
 