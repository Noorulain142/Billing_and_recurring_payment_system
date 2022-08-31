# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions, dependent: :destroy
  has_many :features, dependent: :destroy

  validates :name, :monthly_fee, presence: true

  def find_user
    @subscribed_users = users.all
  end
end
