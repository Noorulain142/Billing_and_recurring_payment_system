# frozen_string_literal: true

# # frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @current_buyer = User.where(usertype: 'Buyer')
  end

  def show
    render file: 'public/404.html', status: :not_found, layout: false
  end
end
