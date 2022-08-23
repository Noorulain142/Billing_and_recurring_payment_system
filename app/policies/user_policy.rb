class UserPolicy < ApplicationPolicy
  def admin?
    @user.usertype == 'Admin'
  end

  def buyer?
    @user.usertype == 'Buyer'
  end

  

end
