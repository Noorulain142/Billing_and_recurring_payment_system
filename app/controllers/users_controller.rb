# # frozen_string_literal: true

class UsersController < ApplicationController
  def index
    # @users = User.all(where(ype == buyer))
    @current_buyer = User.where(usertype: 'Buyer')
  end

  def show
  end
  # # def destroy
  # #   redirect_to destroy_user_session_path
  # # end # private
  # def destroy
  #   redirect_to destroy_user_session_path
  # end
  # def user_params
  #   params.require(:user).permit(:name, :email, :avatar)
  # end
end
