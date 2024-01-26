class BookingsController < ApplicationController
  before_action :authenticate_architect_or_user

  def index
    if current_user.present?
      @bookings = current_user.bookings
    elsif current_architect.present?
      @bookings = current_architect.bookings
    end 
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def new
    @design = Design.find(params[:design_id])
    @booking = @design.bookings.build
    @booking.architect_id = @design.architect_id 
  end

  def create
    @booking = current_user.bookings.new(booking_params)
  
    if @booking.save
      redirect_to architects_path, notice: 'Booking created successfully.'
    else
      puts @booking.errors.full_messages
      render :new
    end
  end
  
  private

  def booking_params
    params.require(:booking).permit(:design_name, :design_url, :expected_amount, :expected_months, :message, :design_id, :architect_id)
  end

  def authenticate_architect_or_user
    if current_architect
      authenticate_architect!
    elsif current_user
      authenticate_user!
    else
      redirect_to root_path, alert: "You must be either an architect or a user to access this page."
    end
  end
end
