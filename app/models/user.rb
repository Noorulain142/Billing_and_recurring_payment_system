# frozen_string_literal: true

class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :plans, through: :subscriptions
  has_one_attached :avatar

  validates :avatar, presence: true
  validate :correct_image_type

  private

  def correct_image_type
    return unless avatar.attached?
    errors[:base] << 'you tried uploading wrong file' unless avatar.content_type.in?(%w[image/png image/jpg])
  end
end
