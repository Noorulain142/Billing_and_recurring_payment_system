# frozen_string_literal: true

class FeaturesController < ApplicationController
  before_action :set_plan
  before_action :find_feature, only: %i[show destroy edit update increase_count]

  def index
    @features = @plan.features.all
  end

  def show; end

  def new
    @feature = @plan.features.new
  end

  def edit; end

  def create
    @feature = @plan.features.build(feature_params)
    authorize @feature
    if @feature.save
      redirect_to @plan, notice: 'Feature was successfully created.'
    else
      # render :new, status: :unprocessable_entity
      redirect_to @plan, notice: 'Feature was not successfully created.'
    end
  end

  def increase_count
    @feature.update!(usage_value: @feature.usage_value += 1)
    if @feature.usage_value > @feature.max_unit_limit
      redirect_to request.referer, notice: 'Feature Over Used'
      @over_use = (@feature.usage_value - @feature.max_unit_limit) * @feature.unit_price
    else
      redirect_to request.referer
    end
  end

  def update
    authorize @feature
    if @feature.update(feature_params)
      redirect_to @plan, notice: 'Feature was successfully updated.'
    else
      render :edit, status: :unprocessable_entity

    end
  end

  def destroy
    authorize @feature
    if @feature.destroy
      redirect_to @plan, notice: 'Feature was successfully destroyed.'
    else
      render :show
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def find_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:name, :code, :unit_price, :max_unit_limit, :usage_value)
  end
end
