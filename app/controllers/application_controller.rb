# frozen_string_literal: true

# ApplicationController serves as the base controller for the entire application.
# It includes common functionalities such as protection from
# configuration of permitted parameters for Devise controllers
# :nocov:
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Configures permitted parameters based on the resource type (User or Architect).
  def configure_permitted_parameters
    if resource_name == :user
      user_permitted_parameters
    elsif resource_name == :architect
      architect_permitted_parameters
    end
  end

  # Configures permitted parameters for User resource.
  def user_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:name, :email, :phone_number, :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :email, :phone_number, :password, :current_password)
    end
  end

  # Configures permitted parameters for Architect resource.
  def architect_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:profile_photo, :name, :email, :number, :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:profile_photo, :name, :email, :number, :password, :current_password)
    end
  end
end
# :nocov:
