# frozen_string_literal: true

class BuyerPlan < ApplicationRecord
  belongs_to :plan
  belongs_to :user
end
