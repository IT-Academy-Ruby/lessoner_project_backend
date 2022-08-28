Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'

  resources :categories

  resources :lessons do
    resources :comments
  end

  resources :users do
    resources :comments
  end

end
