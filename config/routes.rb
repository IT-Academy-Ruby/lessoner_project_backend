Rails.application.routes.draw do
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :categories
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'

end
