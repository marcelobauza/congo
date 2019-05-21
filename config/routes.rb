Rails.application.routes.draw do

  get 'dashboards/index'
  get 'counties/find' => 'counties#find'
  get 'transactions/transactions_summary' => 'transactions#transactions_summary'
  get 'projects/projects_summary' => 'projects#projects_summary'
  get 'future_projects/future_projects_summary' => 'future_projects#future_projects_summary'
  
  get 'transactions/dashboards' => 'transactions#dashboards'
  get 'future_projects/dashboards' => 'future_projects#dashboards'
  get 'projects/dashboards' => 'projects#dashboards'
  
  namespace :admin do
    resources :periods
    resources :county_ufs
    get 'dashboards/index'
  root 'dashboards#index'
  end
  resources :land_use_types
  resources :project_mixes
  resources :project_statuses
  resources :project_instance_mixes
  resources :project_instances
  resources :projects
  resources :counties
  resources :property_types
  resources :transactions
  resources :layer_types
  resources :future_projects
  resources :future_project_types
  resources :project_types
  resources :seller_types
  devise_for :users
  resources :users 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboards#index'
end
