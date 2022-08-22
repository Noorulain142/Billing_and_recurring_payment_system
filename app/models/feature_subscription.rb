# frozen_string_literal: true

class FeatureSubscription < ApplicationRecord
  belongs_to :subscription
  belongs_to :feature
  validates :usage_value, numericality: true
end
