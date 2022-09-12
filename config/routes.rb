# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, only: [:registrations, :sessions, :omniauth_callbacks], controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
    }
  root to: redirect("/#{I18n.default_locale}"), as: :redirected_root
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, skip: [:registrations, :sessions, :omniauth_callbacks]
    resources :categories
    root 'static_pages#home'
    get '/about', to: 'static_pages#about'

    resources :lessons do
      resources :comments
    end

    resources :users do
      resources :comments
    end
  end
end
