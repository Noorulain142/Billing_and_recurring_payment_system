# frozen_string_literal: true

module Purchase
  class CheckoutsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan, only: %i[create]

    def create
      @@plan_obj_id = @plan_obj.id
      @user = current_user
      # @stripe_user = current_user.stripe_id
      # StripeCheckout::CheckoutCreator.call(@user,@plan_obj)
      session = Stripe::Checkout::Session.create(
        customer: current_user.stripe_id,
        client_reference_id: current_user.id,
        success_url: "#{root_url}success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: pricing_url,
        payment_method_types: ['card'],
        mode: 'subscription',
        customer_email: current_user.email,
        line_items: [{
          quantity: 1,
          price: @plan_obj.price_id
        }]
      )
      redirect_to session.url, allow_other_host: true
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
      @plan_obj = Plan.find(params[:plan_id])
    end
  end
end
