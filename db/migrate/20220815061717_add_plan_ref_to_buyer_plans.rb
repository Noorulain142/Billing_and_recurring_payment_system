# frozen_string_literal: true

class AddPlanRefToBuyerPlans < ActiveRecord::Migration[5.2]
  def change
    add_reference :buyer_plans, :plan, foreign_key: true
  end
end
