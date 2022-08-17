# frozen_string_literal: true

class AddUserRefToBuyerPlans < ActiveRecord::Migration[5.2]
  def change
    add_reference :buyer_plans, :user, foreign_key: true
  end
end
