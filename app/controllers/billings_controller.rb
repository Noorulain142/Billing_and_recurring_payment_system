# frozen_string_literal: true

class BillingsController < ApplicationController
  before_action :authenticate_user!
  def create
    Rails.logger.debug current_user.customer_id
    session = Stripe::BillingPortal::Session.create({
                                                      customer: current_user.stripe_id,
                                                      return_url: root_url
                                                    })
    redirect_to session.url, allow_other_host: true
  end
end
