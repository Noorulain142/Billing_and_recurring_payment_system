# frozen_string_literal: true

class AddUsageValueToFeatureSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :feature_subscriptions, :usage_value, :decimal
  end
end
