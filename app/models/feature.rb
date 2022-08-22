# frozen_string_literal: true

class Feature < ApplicationRecord
  belongs_to :plan
  validates :name, :code, :unit_price, :max_unit_limit, :usage_value, presence: true
  validates :unit_price, presence: true, length: { maximum: 10 }
  validates :max_unit_limit, presence: true, length: { maximum: 20 }
  # validates :usage_value, presence: true
end
