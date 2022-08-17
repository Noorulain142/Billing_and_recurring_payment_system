# frozen_string_literal: true

Rails.application.routes.draw do
  resources :plans do
    resources :features
    member do
      get :subscribe
      get :unsubscribe
    end
  end
  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
  end
  devise_for :users
  # devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
