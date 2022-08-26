# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @pagy, @plans = pagy(Plan.all, items: 5)
  end
end
