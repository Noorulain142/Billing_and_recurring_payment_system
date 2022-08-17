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
      redirect_to plan_url(@plan), notice: 'Plan was not updated.'
    end
  end

  def destroy
    authorize @plan
    redirect_to plans_url, notice: 'Plan was successfully destroyed.' if @plan.destroy
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
end
