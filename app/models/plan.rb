# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions, dependent: :destroy
  has_many :features, dependent: :destroy

  validates :name, :monthly_fee, presence: true
  validates :monthly_fee, numericality: { only_integer: true, greater_than: 0 }

  def find_user
    @subscribed_users = users.all
  end
end
