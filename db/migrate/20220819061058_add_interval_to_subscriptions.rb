# frozen_string_literal: true

class AddIntervalToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :interval, :string
    add_column :subscriptions, :subscription_id, :string
  end
end
