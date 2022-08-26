# frozen_string_literal: true

class FeaturesController < ApplicationController
  before_action :set_plan
  before_action :find_feature, only: %i[show destroy edit update increase_count over_use]

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
      redirect_to @plan, locals: { error: @feature.errors.full_messages.to_sentence }
    end
  end

  def increase_count
    @feature.update!(usage_value: @feature.usage_value += 1)
    if @feature.usage_value > @feature.max_unit_limit
      over_use
      redirect_to request.referer, notice: 'Feature Over Used'

    else
      redirect_to request.referer
    end
  end

  def over_use
    @use = Feature.find(params[:id])
    value = @feature.usage_value
    limit = @feature.max_unit_limit
    price = @feature.unit_price
    @over_use = (value - limit) * price
    @use.update(over_use: @over_use)
  end

  def update
    authorize @feature
    if @feature.update(feature_params)
      redirect_to @plan, notice: 'Feature was successfully updated.'
    else
      render :edit, locals: { error: @feature.errors.full_messages.to_sentence }

    end
  end

  def destroy
    authorize @feature
    if @feature.destroy
      redirect_to @plan, notice: 'Feature was successfully destroyed.'
    else
      render :show, locals: { error: @feature.errors.full_messages.to_sentence }
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
    params.require(:feature).permit(:name, :code, :unit_price, :max_unit_limit, :usage_value, :over_use)
  end
end
