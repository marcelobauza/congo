Rails.application.routes.draw do


  resources :seller_types
  get 'dashboards/index'
  get 'counties/find' => 'counties#find'
  namespace :admin do
      resources :periods
  end
  resources :counties
  resources :property_types
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
