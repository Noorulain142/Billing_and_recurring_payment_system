# Stripe.api_key = 'sk_test_51LXewYEO5pnA29EVsh937xIUepx54SoPN7fdQ8IOs29xKiLZ0BK76EBXWDXZsoqUI9NI9I7lhkQySnLWRg9UyiGf00iY2E2cKj'

Rails.configuration.stripe = {
  publishable_key: ENV['PUBLISHABLE_KEY'],
  secret_key: ENV['SECRET_KEY']
}
Stripe.api_key=Rails.configuration.stripe[:secret_key]
