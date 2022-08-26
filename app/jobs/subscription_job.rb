# frozen_string_literal: true

class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(name)
    SubscriptionMailer.billing_mail(name).deliver
  end
end
