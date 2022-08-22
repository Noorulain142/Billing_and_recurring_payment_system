# frozen_string_literal: true

class CreateFeatureSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :feature_subscriptions, &:timestamps
  end
end
