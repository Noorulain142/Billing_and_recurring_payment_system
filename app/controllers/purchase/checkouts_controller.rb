# frozen_string_literal: true
require 'ostruct'
module Purchase
  class CheckoutsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan, only: %i[create]
    before_action :set_subscription, only: %i[create success]
    before_action :set_stripe_key
    @@plan_obj_id=0
    def create
      @@plan_obj_id = @plan_obj.id
      @user = current_user
      @root_url = "#{root_url}purchase/checkouts/success?session_id={CHECKOUT_SESSION_ID}"
      @pricing_url = pricing_url
        session = StripeCheckout::CheckoutCreator.call(@user, @plan_obj, @root_url, @pricing_url)
      if session.present?
        session = session.to_h
        os = OpenStruct.new(session)
        redirect_to os.url, allow_other_host: true
      else
        redirect_to root_path ,notice: 'session parameters missing'
      end
    end

    def success
      session = Stripe::Checkout::Session.retrieve(params[:session_id])
      sub = Stripe::Subscription.retrieve(
        session.subscription
      )
      @user = current_user.id
      @plan_obj = @@plan_obj_id
      StripeCheckout::SubscriptionCreator.call(@plan_obj, sub, @user)
        @customer = Stripe::Customer.retrieve(session.customer)
        SubscriptionMailer.new_subscription_email(@customer).deliver
        SubscriptionJob.set(wait: 30.days).perform_later(@customer.name)
    end

    private

    def set_plan
      @plan_obj = Plan.find_by(id: params[:plan_id])
    end

    def set_subscription
      @subscription = current_user.subscriptions
      authorize @subscription
    end

    def set_stripe_key
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    end
  end
end
