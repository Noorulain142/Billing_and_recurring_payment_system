# frozen_string_literal: true

class SubscriptionMailerPreview < ActionMailer::Preview
  def payment_failed
    SubscriptionMailer.with(user: User.first).payment_failed
  end
end
