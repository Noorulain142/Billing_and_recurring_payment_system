# frozen_string_literal: true

class CheckoutController < ApplicationController
  before_action :authenticate_user!
  def create
    @plan = Plan.find(params[:id])
    if @plan.nil?
      redirect_to root_path
      return
    end
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          unit_amount: @plan.monthly_fee,
          currency: 'usd',
          product_data: {
            name: @plan.name
          }
        }, quantity: 1
      }], mode: 'payment',
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url
    )
    respond_to do |format|
      format.js
    end
  end

  def success; end

  def cancel; end
end
