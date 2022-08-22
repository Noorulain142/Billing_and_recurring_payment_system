# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # has_one_attached :avatar, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :plans, through: :subscriptions
  has_one_attached :avatar

  def subscribed?
    subscription.where(status: 'active').any?
  end

  def avatar_thumbnail
    avatar.variant(resize:"150x150!").processed
  end
end
