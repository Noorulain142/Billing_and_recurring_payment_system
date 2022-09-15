# frozen_string_literal: true

class Feature < ApplicationRecord
  belongs_to :plan

  validates :name, :code, :unit_price, :max_unit_limit, :usage_value, presence: true
  validates :max_unit_limit, :usage_value,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unit_price, :code,
            numericality: { only_integer: true, greater_than: 0 }

  def over_use
    Feature.find(id)
    return (usage_value - max_unit_limit) * unit_price if usage_value > max_unit_limit
  end
end
