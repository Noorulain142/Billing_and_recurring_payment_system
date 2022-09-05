# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def routing_error(_error = 'Routing error', _status = :not_found, _exception = nil)
    render file: 'public/404.html', status: :not_found, layout: false
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email encrypted_password usertype avatar])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[name email usertype])

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :password, :current_password, :email, :usertype, :avatar,
               :password_confirmation)
    end
  end

  private

  def user_not_authorized
    redirect_to(request.referer || user_root_path, notice: 'You are not authorized to perform this action.')
  end

  def record_not_found
    redirect_to(request.referer || plans_path, notice: 'Record Not Found')
  end
end
