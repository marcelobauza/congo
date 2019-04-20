Rails.application.routes.draw do


  resources :seller_types
  get 'dashboards/index'
  get 'counties/find' => 'counties#find'
  get 'transactions/transactions_summary' => 'transactions#transactions_summary'
  get 'transactions/dashboards' => 'transactions#dashboards'
  
  namespace :admin do
      resources :periods
  end
  resources :counties
  resources :property_types
  resources :transactions
  resources :layer_types
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'transactions#dashboards'
end
