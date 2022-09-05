# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    @user.usertype == 'Buyer'
  end

  def admin?
    @user.usertype == 'Admin'
  end

  def buyer?
    @user.usertype == 'Buyer'
  end

  def setting_subscribed_user
    @user.id == @record.id
  end
end
