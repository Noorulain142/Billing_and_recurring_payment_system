# frozen_string_literal: true

class AddColumnsToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :status, :string
    add_column :subscriptions, :current_period_start, :datetime
    add_column :subscriptions, :current_period_end, :datetime
  end
end
