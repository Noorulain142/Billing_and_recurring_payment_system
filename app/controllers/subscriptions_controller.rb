# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show update]
  before_action :set_user, only: %i[show]
  before_action :set_billing, only: %i[show index]
  def index
    @subs = Subscription.all
  end

  def update
    @sub = Subscription.find_by(user_id: params[:user_id])
  end

  def show
    @user_buyer = User.where(usertype: 'Buyer')
    @sub = Subscription.find_by(user_id: params[:user_id])
  end

  private

  def set_subscription
    @subs = Subscription.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_billing
    return if @subs.blank?

    @bill = @subs.created_at.to_date + 30.days
    @subs.update(billing_day: @bill)
    # user_charged = User.find(@subs.user_id)
    # SubscriptionJob.set(wait: 1.minute).perform_later(user_charged)
  end

  def params_subscription
    params.require(:subscription).permit(:subscription_id, :user_id, :current_period_end, :current_period_start,
                                         :plan_id, :billing_day, :interval, :plan_id)
  end
end
