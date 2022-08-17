# frozen_string_literal: true

class FeaturesController < ApplicationController
  before_action :set_plan
  before_action :find_feature, only: %i[show destroy edit update]

  def index
    @features = @plan.features.all
  end

  def show; end

  def new
    @feature = @plan.features.new
  end

  def edit; end

  def create
    @feature = @plan.features.new(feature_params)
    authorize @feature
    if @feature.save
      redirect_to @plan, notice: 'Feature was successfully created.'
    else
      render :new, status: :unprocessable_entity
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
    redirect_to @plan, notice: 'Feature was successfully destroyed.' if @feature.destroy
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def find_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:name, :code, :unit_price, :max_unit_limit)
  end
end
