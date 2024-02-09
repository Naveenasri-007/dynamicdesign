# frozen_string_literal: true

# ArchitectsController handles actions related to architects, their profiles, and booking status updates.
# This controller includes authentication checks for both architects and users and defines methods for
# index, show, and updating booking status.
class ArchitectsController < ApplicationController
  before_action :authenticate_architect!, only: [:update_status], if: -> { current_architect.present? }
  before_action :authenticate_user!, only: %i[index show], if: -> { current_user.present? }
  # before_action :validate_params, only: [update_status]
  def index
    @architects = Architect.all
  end

  def show
    @architect = Architect.find_by(id: params[:id])
    if @architect.nil?
      flash[:error] = 'Architect not found'
      redirect_to architects_path
    else
      @designs = @architect.designs.includes(:likes, :ratings)
    end
  end

  def update_status
    @booking = current_architect.bookings.find(params[:id])
    handle_booking_status_update
  end

  private

  def handle_booking_status_update
    case params[:status]
    when 'accept'
      accept_booking
    when 'reject'
      reject_booking
    else
      invalid_status
    end
  end

  def accept_booking
    @booking.update(status: 'accepted')
    redirect_to bookings_path, notice: 'Booking accepted successfully.'
  end

  def reject_booking
    @booking.update(status: 'rejected')
    redirect_to bookings_path, notice: 'Booking rejected successfully.'
  end

  def invalid_status
    redirect_to bookings_path, alert: 'Invalid status.'
  end

  def validate_params
    params.require(:architect).permit(:status)
  end
end
