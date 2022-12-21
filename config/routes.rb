require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

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
