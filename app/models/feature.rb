# frozen_string_literal: true

class Feature < ApplicationRecord
  belongs_to :plan

  validates :name, :code, :unit_price, :max_unit_limit, :usage_value, presence: true
  validates :code, :unit_price, :max_unit_limit, :usage_value, numericality: { only_integer: true, greater_than: 0 }

  def over_use
    @use = Feature.find(id)
    return @over_use = (usage_value - max_unit_limit) * unit_price if usage_value > max_unit_limit
  end
end
