# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :plans do
    resources :features, except: [:show]
    patch 'plans/:plan_id/features/:id' => 'features#increase_count', as: 'inc_count'
  end

  resources :users, except: [:show] do
    resources :subscriptions
  end

  scope controller: :static do
    get :pricing
  end

  namespace :purchase do
    # resources :checkouts, only: %i[ success]
    resources :checkouts do
      get 'success', on: :member
    end
    # member do
    # member :success
    #   get 'success'
    # end
  end

  unauthenticated do
    root to: 'plans#index'
  end
  authenticated do
    root to: 'plans#index'
  end

  get 'success', to: 'purchase/checkouts#success'
  get '*path', to: 'application#routing_error'
end
