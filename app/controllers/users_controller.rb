# frozen_string_literal: true

# # frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @current_buyer = User.where(usertype: 'Buyer')
  end

end
