Rails.application.routes.draw do

  resources :transactions
  resources :layer_types
  get 'dashboards/index'
  get 'counties/find' => 'counties#find'
  resources :counties
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboards#index'
end
