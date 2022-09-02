# frozen_string_literal: true

module StripeCheckout
  class SubscriptionCreator < ApplicationService
    attr_reader :sub, :user, :plan_obj

    def initialize(plan_obj, sub, user)
      super()
      @user = user
      @sub = sub
      @plan_obj = plan_obj
    end

    def call
      Subscription.create!(plan_id: plan_obj, user_id: user, status: @sub.status,
                           current_period_start: @sub.current_period_start,
                           current_period_end: @sub.current_period_end,
                           interval: @sub.items.data[0].plan.interval,
                           customer_id: @sub.customer, subscription_id: @sub.id)
    end
  end
end
