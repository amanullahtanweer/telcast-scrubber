require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  resources :results
  resources :datasets
  root "dashboard#index"
  get "manual" => "dashboard#manual"

  authenticate :user, ->(u) { u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
