# frozen_string_literal: true

module StripeCheckout
  class CheckoutCreator < ApplicationService
    attr_reader :user, :plan_obj, :root_url, :pricing_url

    def initialize(user, plan_obj, root_url, pricing_url)
      super()
      @user = user
      @plan_obj = plan_obj
      @root_url = root_url
      @pricing_url = pricing_url
    end

    def call
      Stripe::Checkout::Session.create(
        customer: user.stripe_id,
        client_reference_id: user.id,
        success_url: @root_url,
        cancel_url: pricing_url,
        payment_method_types: ['card'],
        mode: 'subscription',
        customer_email: user.email,
        line_items: [{
          quantity: 1,
          price: @plan_obj.price_id
        }]
      )
    end
  end
end
