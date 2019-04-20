Rails.application.routes.draw do



  get 'dashboards/index'
  get 'counties/find' => 'counties#find'
  get 'transactions/transactions_summary' => 'transactions#transactions_summary'
  get 'transactions/dashboards' => 'transactions#dashboards'
  get 'future_projects/future_projects_summary' => 'future_projects#future_projects_summary'
  get 'future_projects/dashboards' => 'future_projects#dashboards'
  
  namespace :admin do
      resources :periods
  end
  resources :counties
  resources :property_types
  resources :transactions
  resources :layer_types
  resources :future_projects
  resources :future_project_types
  resources :project_types
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'transactions#dashboards'
end
