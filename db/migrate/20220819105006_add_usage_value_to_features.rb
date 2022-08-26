# frozen_string_literal: true

class AddUsageValueToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :usage_value, :decimal
  end
end
