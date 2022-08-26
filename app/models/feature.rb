# frozen_string_literal: true

class Feature < ApplicationRecord
  belongs_to :plan
  validates :name, :code, :unit_price, :max_unit_limit, :usage_value, presence: true
  validates :unit_price, length: { maximum: 10 }
  validates :max_unit_limit, length: { maximum: 20 }
end
