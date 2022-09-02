# frozen_string_literal: true

class SubscriptionMailer < ApplicationMailer
  default from: 'Admin'
  def new_subscription_email(customer)
    @customer = customer
    mail(to: customer.email, subject: 'You got a new subscription!')
  end

  def billing_mail(customer)
    @customer = customer
    mail(to: customer.email, subject: 'Your Monthly Bill!')
  end
end
