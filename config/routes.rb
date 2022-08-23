# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get 'members/dashboard'

  resources :plans do
    resources :features
    patch 'plans/:plan_id/features/:id' => 'features#increase_count', as: 'inc_count'
    get 'users/:user_id/subscriptions/:id' => 'users#send_invoice', as: 'send_inov'
    member do
      get :subscribe
      get :unsubscribe
    end
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

  # resources :users, only: %i[index]
  # devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  patch 'features/increase_count' => 'features#increase_count'
  resources :features do
    resources :subscriptions
  end

  scope controller: :static do
    get :pricing
  end

  resources :billings, only: :create
  namespace :purchase do
    resources :checkouts
  end
  get 'success', to: 'purchase/checkouts#success'
  resources :subscriptions
  resources :webhooks, only: :create
end
