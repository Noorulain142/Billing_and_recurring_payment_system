# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  def bill(plan)
    sum = 0
    plan.features.each do |feature|
      usage = feature.usage_value
      max_limit = feature.max_unit_limit
      next unless usage > max_limit

      price = feature.unit_price
      total_bill = (usage - max_limit) * price
      sum += total_bill
    end
    sum + plan.monthly_fee
  end
end
