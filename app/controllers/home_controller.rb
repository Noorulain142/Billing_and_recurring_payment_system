# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @pagy, @plans = pagy(Plan.all, items: 2)
  end
end
