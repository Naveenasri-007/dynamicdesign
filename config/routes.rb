Rails.application.routes.draw do

  resources :designs, only: [:index, :show, :new, :create, :edit, :update]

  get 'products/filter_by_category', to: 'products#filter_by_category'

  resources :designs do
    resources :likes, only: [:create, :destroy]
    resources :ratings, only: [:create, :edit, :update, :destroy]
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  devise_for :architects
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"


end
