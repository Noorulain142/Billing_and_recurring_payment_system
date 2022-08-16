# frozen_string_literal: true

class PlanPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def initialize(user, plan)
    super
    @user = user
    @plan = plan
  end

  def new?
    @user.usertype == 'Admin'
  end

  def create?
    @user.usertype == 'Admin'
  end

  def update?
    @user.usertype == 'Admin'
  end

  def edit?
    @user.usertype == 'Admin'
  end

  def destroy?
    @user.usertype == 'Admin'
  end

  def subscribe_plan?
    @user.usertype == 'Buyer'
  end

  def unsubscribe_plan?
    @user.usertype == 'Buyer'
  end
end
