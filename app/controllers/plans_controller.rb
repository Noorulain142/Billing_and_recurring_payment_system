# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]
  before_action :set_stripe_key

  def index
    if Plan.exists?
      @plans = Plan.all
    else
      redirect_to request.referer, notice: 'No Plan Created Yet'
    end
  end

  def show; end

  def new
    @plan = Plan.new
  end

  def edit; end

  def create
    @plan = Plan.new(plan_params)
    authorize @plan
    product = Stripe::Product.create({ name: @plan.name })
    @plan.product_id = product.id
    price = StripePlan::PriceCreator.call(@plan)
    @plan.price_id = price.id
    if @plan.save
      redirect_to plan_url(@plan), allow_other_host: true ,notice: 'Plan was successfully created.'
    else
      redirect_to request.referer, notice: 'Plan not created'

    end
  end

  def update
    if @plan.update(plan_params)
      redirect_to plan_url(@plan), notice: 'Plan was successfully updated.'
    else
      render :edit
      flash.now[:notice] = 'Plan was not successfully updated.'
    end
  end

  def destroy
    if @plan.destroy
      redirect_to plans_url, notice: 'Plan was successfully destroyed.'
    else
      render :new
      flash.now[:notice] = 'Plan was not successfully deleted.'

    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
    authorize @plan
  end

  def plan_params
    params.require(:plan).permit(:monthly_fee, :name)
  end

  def set_stripe_key
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
  end
end
