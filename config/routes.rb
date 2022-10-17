# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  post '/sign_up', to: 'sign_up#create'
  devise_for :users, only: [:omniauth_callbacks], controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: redirect("/#{I18n.default_locale}"), as: :redirected_root
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, skip: [:omniauth_callbacks]
    resources :categories, defaults: { format: :json }
    resources :users, defaults: { format: :json }
    resources :lessons, defaults: { format: :json }
    root 'static_pages#home'
    get '/about', to: 'static_pages#about'
    get '/check_username', to: 'users#check_username', defaults: { format: :json }
    get '/check_email', to: 'users#check_email', defaults: { format: :json }
    post '/login', to: 'users#login', defaults: { format: :json }
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
end
