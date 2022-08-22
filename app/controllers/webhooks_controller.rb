class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_signing_secret)
    event = nil
  end

  def begin
    event = Stripe::Webhook.construct_event(payload, signature_header, endpoint_secret)
  rescue JSON::ParserError => e
    render json: { message: e }, status: :bad_request
  rescue Stripe::SignatureVerificationError => e
    render json: { message: e }, status: :bad_request
    nil
  end

  case event.type

  when 'checkout.session.completed'
    return if !User.exists?(event.data.object.client_reference_id)

    fulfill_order(event.data.object)
    # byebug

  # when 'checkout.session.async_payment_succeeded'

  when 'invoice.payment_succeeded'
    #return if subscription_id isnt present
    return unless event.data.object.subscription.present?
    #continue to provision subscription when payment is made
    #store the status on local subscription
    stripe_subscription = Stripe::Subscription.retrieve(event.data.object.subscription)

    subscription = Subscription.find_by(subscription_id: stripe_subscription)
    subscription.update(current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
    current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
    plan_id: stripe_subscription.plan.id,
    interval: stripe_subscription.plan.interval,
    status: stripe_subscription.status)

  when 'invoice.payment_failed'
    #the payement failed or is not valid
    #the subscription becomes past_due
    #notify customer and send them to the customer portal
    user = User.find_by(stripe_id: event.data.object.customer)
    if user.exists?
      SubscriptionMailer.with(user: :user).payment_failed.deliver_now
    end

  else
    puts "Unhandled event type #{event.type}"
  end
  render json: { message: 'success' }

  private

  def fulfill_order(checkout_sessions )
    #find user and assign customer id to it
    user = User.find(checkout_session.client_reference_id )
    user.update(stripe_id: checkout_session.customer)
    #retrieve new subscription via Stripe using subscription_id
    stripe_subscription = Stripe::Subscription.retrieve(checkout_session. subscription)
    #create new subscription with Stripe details and user details
    Subscription.create(customer_id: stripe_subscription.customer,
    current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
    current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
    plan_id: stripe_subscription.plan.id,
    interval: stripe_subscription.plan.interval,
    status:stripe_subscription.status,
    subscription_id: stripe_subscription.id,
    user: user)
  end
end
