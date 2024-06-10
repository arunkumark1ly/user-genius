# frozen_string_literal: true

Rails.application.routes.draw do
  get 'daily_records/index'
  resources :users, only: %i[index destroy]
  resources :daily_records, only: [:index]

  post 'trigger_fetch_users', to: 'users#fetch_users'
  post 'trigger_daily_record_update', to: 'daily_records#update_records'

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'users#index'

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
