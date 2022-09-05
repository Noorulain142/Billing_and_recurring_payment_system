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
    admin?
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def show?
    !@user.eql? nil
  end

  def edit?
    admin?
  end

  def destroy?
    admin?
  end

  def subscribe_plan?
    buyer?
  end

  def unsubscribe_plan?
    buyer?
  end
end
