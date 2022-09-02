# frozen_string_literal: true

class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(customer)
    SubscriptionMailer.billing_mail(customer).deliver
  end
end
