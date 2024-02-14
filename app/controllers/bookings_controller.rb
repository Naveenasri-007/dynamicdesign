# frozen_string_literal: true

# Controller responsible for handling bookings, including index, creation, and authentication checks.
# The bookings are associated with designs and involve interaction between architects and users.
class BookingsController < ApplicationController
  before_action :authenticate_architect_or_user

  def index
    @bookings = if current_user.present?
                  current_user.bookings.includes(design: :architect)
                else
                  current_architect.bookings.includes(:user)
                end
  end

  def new
    @design = Design.find_by(id: params[:design_id])

    if @design
      @booking = @design.bookings.build
      @booking.architect_id = @design.architect_id
    else
      flash[:error] = 'Design not found.'
      redirect_to designs_path
    end
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
    params.require(:booking).permit(:design_name, :design_url, :expected_amount, :expected_months, :message,
                                    :design_id, :architect_id)
  end

  def authenticate_architect_or_user
    if current_architect
      authenticate_architect!
    elsif current_user
      authenticate_user!
    else
      redirect_to root_path, alert: 'You must be either an architect or a user to access this page.'
    end
  end
end
