# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email encrypted_password usertype avatar])
  end

  private

  def user_not_authorized
    redirect_to(request.referer || user_root_path, notice: 'You are not authorized to perform this action.')
  end
end
