# frozen_string_literal: true

# # frozen_string_literal: true

class UsersController < ApplicationController
  def index
    if current_user.subscriptions.present? || current_user.usertype == 'Admin'
      @current_buyer = User.where(usertype: 'Buyer')
    else
      redirect_to root_path, notice: 'No subscriptions yet.'
    end
  end
end
