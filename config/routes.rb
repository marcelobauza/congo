Rails.application.routes.draw do


  get 'dashboards/index'
  get 'dashboards/graduated_points'
  get 'counties/find' => 'counties#find'
  get 'transactions/transactions_summary' => 'transactions#transactions_summary'
  get 'projects/projects_summary' => 'projects#projects_summary'
  get 'future_projects/future_projects_summary' => 'future_projects#future_projects_summary'
  
  get 'transactions/dashboards' => 'transactions#dashboards'
  get 'transactions/graduated_points' => 'transactions#graduated_points'
  get 'future_projects/dashboards' => 'future_projects#dashboards'
  get 'future_projects/graduated_points' => 'future_projects#graduated_points'
  get 'projects/dashboards' => 'projects#dashboards'
  get 'building_regulations/dashboards' => 'building_regulations#dashboards'
  
  namespace :admin do
    resources :agencies
    resources :periods
    resources :import_processes
    resources :county_ufs
    resources :future_projects
    resources :transactions
    resources :project_instance_mixes
    resources :project_instances
    resources :projects
    resources :project_mixes
    get 'dashboards/index'
  root 'dashboards#index'
  end
  resources :land_use_types
  resources :density_types
  resources :building_regulations

  resources :project_statuses

  resources :counties
  resources :property_types
  resources :layer_types
  resources :future_project_types
  resources :project_types
  resources :seller_types
  devise_for :users
  resources :users 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboards#index'
end
