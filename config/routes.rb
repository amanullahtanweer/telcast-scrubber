Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :results
  resources :datasets
  root "dashboard#index"
  get "manual" => "dashboard#manual"
end
