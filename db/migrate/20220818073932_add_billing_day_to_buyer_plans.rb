# frozen_string_literal: true

class AddBillingDayToBuyerPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :buyer_plans, :billing_day, :date
  end
end
