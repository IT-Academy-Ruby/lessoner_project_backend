Rails.application.routes.draw do
  root "categories#index"
  get 'categories/index'
end
