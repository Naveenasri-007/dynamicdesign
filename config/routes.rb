require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :architects
  devise_for :users

  patch 'bookings/:id/:status', to: 'architects#update_status', as: :update_status
  get 'products/filter_by_category', to: 'products#filter_by_category'

  resources :architects, only: %i[index show]

  resources :designs, only: %i[index show new create edit update destroy] do
    resources :likes, only: %i[create destroy]
    resources :ratings, only: %i[create edit update destroy]
    resources :comments, only: %i[create edit update destroy]
  end

  resources :bookings, only: %i[index show new create] do
    member do
      patch 'accept'
      patch 'reject'
    end
  end

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'
end
