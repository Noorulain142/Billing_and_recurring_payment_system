# frozen_string_literal: true

class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :plans, through: :subscriptions
  has_one_attached :avatar

  def avatar_thumbnail
    avatar.variant(resize: '150x150!').processed
  end
end
