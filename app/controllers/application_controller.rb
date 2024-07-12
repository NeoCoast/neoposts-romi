# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :redirect_to_correct_path, unless: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[email password nickname first_name last_name birthday profile_picture])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[email first_name last_name nickname birthday profile_picture])
  end

  private

  def record_not_found
    redirect_to root_path, alert: 'Record not found'
  end

  def redirect_to_correct_path
    return if current_user

    flash[:alert] = 'You must be logged in to access this page.' unless request.path == root_path
    redirect_to new_user_session_path
  end
end
