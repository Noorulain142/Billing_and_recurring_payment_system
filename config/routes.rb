# frozen_string_literal: true

Rails.application.routes.draw do
  get 'members/dashboard'
  resources :plans do
    resources :features
    member do
      get :subscribe
      get :unsubscribe
    end
  end
  devise_for :users
  # devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'plans#index'

  # resources :features do
  #   resources :subscriptions
  # end

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
