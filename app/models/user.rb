# frozen_string_literal: true

class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :plans, through: :subscriptions
  has_one_attached :avatar

  validate :correct_image_type
  # validates :avatar,blob: {content_type: ['image/png','image/jpg']}

  def avatar_thumbnail
    avatar.variant(resize: '150x150!').processed
  end

  private

  def correct_image_type
    return unless avatar.attached?

    errors[:base] << 'you tried uploading wrong file' unless avatar.content_type.in?(%w[image/png image/jpeg])
  end
end
