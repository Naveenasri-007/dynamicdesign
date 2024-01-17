class RatingsController < ApplicationController
    before_action :authenticate_user!
  
    def create
        @design = Design.find(params[:design_id])
        existing_rating = @design.ratings.find_by(user: current_user)
    
        if existing_rating
          redirect_to @design, alert: 'You have already rated this design.'
        else
          @rating = @design.ratings.new(rating_params)
          @rating.user = current_user
    
          if @rating.save
            redirect_to @design, notice: 'Rating added successfully.'
          else
            redirect_to @design, alert: 'Failed to add rating.'
          end
        end
    end
  
    def edit
    end
  
    def update
      @design = Design.find(params[:design_id])
      @rating = @design.ratings.find_by(user: current_user)
    
      if @rating.nil?
        redirect_to @design, alert: 'Rating not found.'
      elsif @rating.update(rating_params)
        redirect_to @design, notice: 'Rating updated successfully.'
      else
        redirect_to @design, alert: 'I cant do anything  Rating not found.'
      end
    end
    
    def destroy
      @design = Design.find(params[:design_id])
      @rating = @design.ratings.find_by(user: current_user)
    
      if @rating.nil?
        redirect_to @design, alert: 'Rating not found.'
      else
        @rating.destroy
        redirect_to @design, notice: 'Rating deleted successfully.'
      end
    end
    
    private
  
    def rating_params
      params.require(:rating).permit(:value)
    end
  end
  