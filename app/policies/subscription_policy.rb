# frozen_string_literal: true

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
    return true if @user.id == @record.user.id
  end

  def index?
    buyer?
  end

  def create?
    buyer?
  end

  def success?
    buyer?
  end
end
