Rails.application.routes.draw do

  resources :designs
  get 'designs/index'
  get 'designs/show'
  get 'designs/new'
  get 'designs/create'
  get 'designs/edit'
  get 'designs/update'
  get 'designs/destroy'

  #devise for architects
  devise_for :architects

  # if you check this how to navingate the user to give this comment
  # rake routes | greb User
  # #devise for user
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"


end
