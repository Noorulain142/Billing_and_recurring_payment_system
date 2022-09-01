# frozen_string_literal: true
# # frozen_string_literal: true

# module StripeCheckout
#   class CheckoutCreator < ApplicationService
#     attr_reader :user, :plan_obj, :root_url, :pricing_url

#     def initialize(plan_obj, user, root_url, _pricing_url)
#       super()
#       @plan_obj = plan_obj
#       @user = user
#       @root_url = "#{root_url}success?session_id={CHECKOUT_SESSION_ID}"
#     end

#     def call
#       session = Stripe::Checkout::Session.create(
#         customer: user.stripe_id,
#         client_reference_id: user.id,
#         # success_url: "#{root_url}success?session_id={CHECKOUT_SESSION_ID}",
#         success_url: @root_url,
#         cancel_url: root_url.to_s,
#         payment_method_types: ['card'],
#         mode: 'subscription',
#         customer_email: user.email,
#         line_items: [{
#           quantity: 1,
#           price: @plan_obj.price_id
#         }]
#       )
#     end
#   end
# end
