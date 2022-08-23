class SubscriptionPolicy < ApplicationPolicy
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

  def show?
    return true if user.id.in?(@record.user_ids)
  end

  def subscribed?
    if user.id == @record.user.id
    return true
    end
  end
end
