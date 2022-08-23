# frozen_string_literal: true

class Subscription < ApplicationRecord
  # belongs_to :plan
  belongs_to :user
  def show
    susubscription.interval
    @billing_day = subscription.current_period_end - subscription.current_period_start
    status
  end
end
