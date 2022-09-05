# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    current_buyer?
  end

  def admin?
    @user.usertype == 'Admin'
  end

  def buyer?
    @user.usertype == 'Buyer'
  end

  def setting_subscribed_user
    @user.id == @record.id
    #   @user
    # else
    #   redirect_to root_path, notice: 'user not authorized '
  end
end
