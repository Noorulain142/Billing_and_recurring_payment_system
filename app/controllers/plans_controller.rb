# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy subscribe unsubscribe]

  def index
    @plans = Plan.all
  end

  def show; end

  def new
    @plan = Plan.new
  end

  def edit; end

  def create
    @plan = Plan.new(plan_params)
    authorize @plan
    if @plan.save
      redirect_to plan_url(@plan), notice: 'Plan was successfully created.'
    else
      render :new, notice: 'Plan was not created.'
    end
  end

  def update
    authorize @plan
    if @plan.update(plan_params)
      redirect_to plan_url(@plan), notice: 'Plan was successfully updated.'
    else
      render :edit, notice: 'Plan was not updated'
    end
  end

  def destroy
    authorize @plan
    if @plan.destroy
      redirect_to plans_url, notice: 'Plan was successfully destroyed.'
    else
      redirect_to @plan, notice: 'plan was not successfully destroyed.'
    end
  end

  def subscribe
    redirect_to plan_url, notice: 'Plan was successfully subscribed' if current_user.plans.push(@plan)
  end

  def unsubscribe
    redirect_to plan_url, notice: 'Plan was successfully unsubscribed' if current_user.plans.destroy(@plan)
  end

  def users
    @subscribed_users = @plan.find_user
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:monthly_fee, :name)
  end

  private def delete_plan
    @stripe_prod_id = @plan.stripe_plan_id
    @stripe_price_id = @plan.price_id
    yield
    #Strip::Price.delete(@stripe_price_id)
    Stripe::Product.update(@stripe_prod_id,active: 'false')
  end
end
