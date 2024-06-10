# frozen_string_literal: true

Rails.application.routes.draw do
  get 'daily_records/index'
  resources :users, only: [:index, :destroy]
  resources :daily_records, only: [:index]

  # Define a route for triggering the FetchUsersJob
  post 'trigger_fetch_users', to: 'users#fetch_users'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root "users#index"

  require 'sidekiq/web'

  # Optional: Basic Authentication for Sidekiq Web UI
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Environment variables for security
    # username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
    username == 'admin' && password == 'admin'
  end

  # Mounting Sidekiq Web UI
  mount Sidekiq::Web => '/sidekiq'
end
