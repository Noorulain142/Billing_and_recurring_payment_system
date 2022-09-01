# frozen_string_literal: true

module Purchase
  class CheckoutsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan, only: %i[create]

    def create
      @@plan_obj_id = @plan_obj.id
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
      Subscription.create!(plan_id: @@plan_obj_id, user_id: current_user.id, status: sub.status,
                           current_period_start: sub.current_period_start,
                           current_period_end: sub.current_period_end,
                           interval: sub.items.data[0].plan.interval,
                           customer_id: sub.customer, subscription_id: sub.id)

      @customer = Stripe::Customer.retrieve(session.customer)
      SubscriptionMailer.new_subscription_email(@customer).deliver
      @name = @customer.name
      SubscriptionJob.set(wait: 30.days).perform_later(@name)
    end

    private

    def set_plan
      @plan_obj = Plan.find(params[:plan_id])
    end
  end
end
