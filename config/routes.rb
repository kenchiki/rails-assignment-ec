# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :products do
      member do
        put :sort_up, :sort_down, :sort_top, :sort_bottom
      end
    end
    resources :home, only: %i[index]
    resources :taxes, only: %i[index new edit create update destroy]
    resources :delivery_fees, only: %i[index new edit create update destroy]
    resources :cash_on_deliveries, only: %i[index new edit create update destroy]
    resources :users, only: %i[index show edit update destroy]
    resources :orders, only: %i[index show]
  end

  resources :users, only: [] do
    resources :shipping_addresses, only: %i[new create]
  end

  resources :orders, only: %i[index new create show]
  resources :products, only: %i[index] do
    resources :cart_products, only: %i[new create edit update]
  end

  resources :cart_products, only: %i[index destroy]

  root 'products#index'
end
