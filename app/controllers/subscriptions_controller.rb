# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show]
  before_action :set_user, only: %i[show]
  before_action :set_billing, only: %i[show index]
  before_action :set_subscribed_user, only: %i[show]
  before_action :set_stripe_key

  def index
    if Subscription.present?
      @subs = Subscription.all
    else
      redirect_to request.referer, notice: 'Subscription not found'
    end
  end

  def show
    @user_buyer = User.where(usertype: 'Buyer')
    if current_user.subscriptions.pluck(:plan_id).include? params[:plan_id].to_i
      @plan = Plan.find(params[:plan_id])

    else
      redirect_to root_path, notice: 'Record not found'
    end
  end

  private

  def set_subscription
    @subs = Subscription.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
    if @user.id == current_user.id
      @user
    else
      redirect_to root_path, notice: 'user not authorized '
    end
  end

  def set_billing
    return if @subs.blank?

    @bill = @subs.created_at.to_date + 30.days
    @subs.update(billing_day: @bill)
  end

  def params_subscription
    params.require(:subscription).permit(:subscription_id, :user_id, :current_period_end, :current_period_start,
                                         :plan_id, :billing_day, :interval, :plan_id)
  end

  def set_subscribed_user
    @sub = Subscription.find_by(user_id: params[:user_id])
  end

  def set_stripe_key
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
  end
end
