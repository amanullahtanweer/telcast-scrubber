require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :api do
    get 'sessions/create'
  end
  devise_for :users, controllers: { registrations: 'registrations' }

  namespace :api do
    get '/login', to: 'sessions#create'
  end

  resources :users, only: [:index] do
    get :impersonate, on: :member
    get :stop_impersonating, on: :collection
  end
  namespace :admin do
    resources :users do
    end
  end

  resources :results
  resources :datasets do
    collection do
      get :modify
      post :modify_dataset
    end
  end
  root "dashboard#index"
  get "manual" => "dashboard#manual"
  post "download" => "dashboard#manual_result"

  authenticate :user, ->(u) { u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
