# frozen_string_literal: true

module StripePlan
  class PriceCreator < ApplicationService
    attr_reader :plan

    def initialize(plan)
      super()
      @plan = plan
    end

    def call
      Stripe::Price.create({
                             unit_amount: plan.monthly_fee,
                             currency: 'usd',
                             recurring: { interval: 'month' },
                             product: plan.product_id
                           })
    end
  end
end
