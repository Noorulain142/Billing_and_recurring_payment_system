# frozen_string_literal: true

Rails.application.routes.draw do
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
  root to: 'home#index'
end
