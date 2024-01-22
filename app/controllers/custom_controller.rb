class CustomController < ApplicationController
  before_action :authenticate_architect! ,only: [:update_status] , if: -> { current_architect.present? }
  before_action :authenticate_user!, only: [:index, :show], if: -> { current_user.present? }
  
  def index
    @architects = Architect.all
  end

  def show
    @architect = Architect.find(params[:id])
    
    if @architect.nil?
      flash[:error] = 'Architect not found'
      redirect_to architects_path
    end
  end

  def update_status
    @booking = Booking.find(params[:id])
    if params[:status] == 'accept'
      @booking.update(status: 'accepted')
      redirect_to bookings_path, notice: 'Booking accepted successfully.'
    elsif params[:status] == 'reject'
      @booking.update(status: 'rejected')
      redirect_to bookings_path, notice: 'Booking rejected successfully.'
    else
      redirect_to bookings_path, alert: 'Invalid status.'
    end
  end


end
