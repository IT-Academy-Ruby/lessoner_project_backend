Rails.application.routes.draw do

  root to: redirect("/#{I18n.default_locale}"), as: :redirected_root
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    devise_for :users 

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
