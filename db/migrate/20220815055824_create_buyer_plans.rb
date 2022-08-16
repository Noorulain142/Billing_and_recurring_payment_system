# frozen_string_literal: true

class CreateBuyerPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :buyer_plans, &:timestamps
  end
end
