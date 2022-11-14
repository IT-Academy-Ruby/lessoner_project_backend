# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  post '/sign_up', to: 'sign_up#create'
  get 'sign_up/confirm_email', to: 'sign_up#confirm_email'
  post '/login', to: 'sign_up#login', defaults: { format: :json }
  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'

  resources :categories, defaults: { format: :json }
  resources :users, defaults: { format: :json }
  resources :lessons, defaults: { format: :json }
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/check_username', to: 'users#check_username', defaults: { format: :json }
  get '/check_email', to: 'users#check_email', defaults: { format: :json }
  resources :lessons do
    resources :comments
  end

  resources :users do
    resources :comments
  end

  namespace :admin do
    resources :users
  end
end
