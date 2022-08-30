# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :plans do
    resources :features
    patch 'plans/:plan_id/features/:id' => 'features#increase_count', as: 'inc_count'
  end

  unauthenticated do
    root to: 'plans#index'
  end
  authenticated do
    root to: 'plans#index'
  end

  resources :users do
    resources :subscriptions
  end

  resources :features do
    resources :subscriptions
  end

  scope controller: :static do
    get :pricing
  end

  namespace :purchase do
    resources :checkouts
  end
  get 'success', to: 'purchase/checkouts#success'
  get '*path', to: 'application#routing_error'
end
