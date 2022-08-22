# frozen_string_literal: true

class AddFeatureRefToFeatureSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_reference :feature_subscriptions, :features, foreign_key: true
  end
end
