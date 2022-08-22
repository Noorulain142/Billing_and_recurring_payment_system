# frozen_string_literal: true

class AddSubscriptionRefToFeatureSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_reference :feature_subscriptions, :subscription, foreign_key: true
  end
end
