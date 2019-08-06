Rails.application.routes.draw do



  resources :categories
  resources :regions
  get 'dashboards/index'

  get 'counties/index'
  get 'future_projects/index'
  get 'projects/index'
  get 'transactions/index'
  get 'building_regulations/index'
  get 'dashboards/graduated_points'
  get 'dashboards/heatmap'
  get 'dashboards/filter_county_for_lon_lat'
  get 'dashboards/filter_period'
  get 'future_project_types/legend_points'
  get 'counties/find' => 'counties#find'
  get 'counties/counties_users' => 'counties#counties_users'
  get 'users/account' => 'users#account'
  put 'users/update' => 'users#update'
  get 'building_regulations/allowed_use_list' => 'building_regulations#allowed_use_list'
  get 'building_regulations/building_regulations_filters' => 'building_regulations#building_regulations_filters'
  get 'transactions/transactions_summary' => 'transactions#transactions_summary'
  get 'transactions/period' => 'transactions#period'
  get 'projects/projects_summary' => 'projects#projects_summary'
  get 'future_projects/future_projects_summary' => 'future_projects#future_projects_summary'
  get 'future_projects/period' => 'future_projects#period'
  get 'application_statuses/load' => 'application_statuses#load'
  get 'application_statuses/colleagues' => 'application_statuses#colleagues'
  get 'application_statuses/share_users' => 'application_statuses#share_users'

  get 'transactions/dashboards' => 'transactions#dashboards'
  get 'transactions/graduated_points' => 'transactions#graduated_points'
  get 'future_projects/dashboards' => 'future_projects#dashboards'
  get 'future_projects/graduated_points' => 'future_projects#graduated_points'
  get 'projects/dashboards' => 'projects#dashboards'
  get 'census/dashboards' => 'census#dashboards'
  get 'projects/graduated_points' => 'projects#graduated_points'
  get 'building_regulations/dashboards' => 'building_regulations#dashboards'
  get 'reports/index' => 'reports#index'
  get 'reports/future_projects_data' => 'reports#future_projects_data'
  get 'reports/future_projects_summary' => 'reports#future_projects_summary'
  get 'reports/transactions_data' => 'reports#transactions_data'
  get 'reports/transactions_summary' => 'reports#transactions_summary'
  get 'reports/transactions_pdf' => 'reports#transactions_pdf'
  get 'reports/building_regulations_pdf' => 'reports#building_regulations_pdf'
  get 'reports/projects_data' => 'reports#projects_data'
  get 'reports/projects_summary' => 'reports#projects_summary'
  get 'reports/projects_pdf' => 'reports#projects_pdf'
  get 'downloads/index' => 'downloads#index'
  get 'downloads/transactions_csv' => 'downloads#transactions_csv'
  get 'downloads/projects_csv' => 'downloads#projects_csv'
  get 'pois/get_around_pois' => 'pois#get_around_pois'
  get 'building_regulations/building_regulation_download' => 'building_regulations#building_regulation_download'

  
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/  do
  namespace :admin do
    get 'periods/active_periods'
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
    resources :roles
    resources :users 
    resources :counties
    resources :surveyors
    resources :uf_conversions
    get 'dashboards/index'
  root 'dashboards#index'
  end
  resources :application_statuses
  resources :pois
  resources :poi_subcategories
  resources :census
  resources :census_sources
  resources :land_use_types
  resources :density_types
  resources :building_regulations
  resources :project_statuses
  
  resources :property_types
  resources :layer_types
  resources :future_project_types
  resources :project_types
  resources :seller_types
  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboards#index'
end
 match '*path', to: redirect("/#{I18n.default_locale}/%{path}"), via: :all
   match '', to: redirect("/#{I18n.default_locale}"), via: :all
end
