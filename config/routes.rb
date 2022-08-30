Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :categories
    root 'static_pages#home'
    get '/about', to: 'static_pages#about'
  end
end
