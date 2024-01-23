require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :architects
  devise_for :users

  match '/architects',   to: 'custom#index',   via: 'get'
  get '/architect/:id', to: 'custom#show', as: :architect

  get 'products/filter_by_category', to: 'products#filter_by_category'

  resources :designs do
    resources :designs, only: [:index, :show, :new, :create,  :edit, :update, :destroy]
    resources :likes, only: [:create, :destroy]
    resources :ratings, only: [:create, :edit, :update, :destroy]
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  resources :bookings, only: [:index, :show, :new, :create]
  patch 'bookings/:id/:status', to: 'custom#update_status', as: :update_status
  resources :bookings do
    member do
      patch 'accept'
      patch 'reject'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
