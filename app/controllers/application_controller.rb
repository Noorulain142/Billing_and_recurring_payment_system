# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_stripe_key
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email encrypted_password usertype avatar])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[name email usertype])
  end

  private

  def user_not_authorized
    redirect_to(request.referer || user_root_path, notice: 'You are not authorized to perform this action.')
  end

  def set_stripe_key
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
  end
end
