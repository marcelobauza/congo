Rails.application.routes.draw do

  resources :rent_future_projects
  resources :rent_transactions
  resources :bots
  resources :rent_projects
  resources :expenses
  resources :expense_types
  resources :feedbacks
  resources :lots
  resources :categories

  get 'dashboards/index'

  get 'regions/search_regions' => 'regions#search_regions'
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
  get 'density_types/legend_points'
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
  get 'dashboard/enabled_transaction_data'
  get 'counties/counties_enabled_by_users' => 'counties#counties_enabled_by_users'

  get 'transactions/dashboards' => 'transactions#dashboards'
  get 'transactions/graduated_points' => 'transactions#graduated_points'
  get 'future_projects/dashboards' => 'future_projects#dashboards'
  get 'future_projects/graduated_points' => 'future_projects#graduated_points'
  get 'projects/dashboards' => 'projects#dashboards'
  get 'rent_indicators/dashboards' => 'rent_indicators#dashboards'
  get 'rent_indicators/search' => 'rent_indicators#search'
  get 'rent_indicators/rent_indicators_summary' => 'rent_indicators#rent_indicators_summary'
  get 'census/dashboards' => 'census#dashboards'
  get 'demography/calculated_gse' => 'demography#calculated_gse'
  get 'projects/graduated_points' => 'projects#graduated_points'
  get 'building_regulations/dashboards' => 'building_regulations#dashboards'
  get 'demography/dashboards' => 'demography#dashboards'
  get 'demography/general' => 'demography#general'
  get 'reports/index' => 'reports#index'
  get 'reports/rent_indicators_pdf' => 'reports#rent_indicators_pdf'
  get 'reports/future_projects_data' => 'reports#future_projects_data'
  get 'reports/future_projects_data_kml' => 'reports#future_projects_data_kml'
  get 'reports/future_projects_summary' => 'reports#future_projects_summary'
  get 'reports/transactions_data' => 'reports#transactions_data'
  get 'reports/transactions_data_kml' => 'reports#transactions_data_kml'
  get 'reports/transactions_summary' => 'reports#transactions_summary'
  get 'reports/transactions_pdf' => 'reports#transactions_pdf'
  get 'reports/projects_data' => 'reports#projects_data'
  get 'reports/projects_data_kml' => 'reports#projects_data_kml'
  get 'reports/projects_summary' => 'reports#projects_summary'
  get 'reports/projects_pdf' => 'reports#projects_pdf'
  get 'reports/building_regulations_pdf' => 'reports#building_regulations_pdf'
  get 'reports/building_regulations_kml' => 'reports#building_regulations_kml'
  get 'reports/rent_indicators_summary' => 'reports#rent_indicators_summary'
  get 'downloads/index' => 'downloads#index'
  get 'downloads/transactions_csv' => 'downloads#transactions_csv'
  get 'downloads/projects_csv' => 'downloads#projects_csv'
  get 'pois/get_around_pois' => 'pois#get_around_pois'
  get 'building_regulations/building_regulation_download' => 'building_regulations#building_regulation_download'
  get 'users/export_csv_downloads_by_company' => 'users#export_csv_downloads_by_company'
  get 'counties/search_county_geojson' => 'counties#search_county_geojson'
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/  do
  namespace :admin do
    get 'user_polygons/export_data' => 'user_polygons#export_data'
    get 'user_polygons/generate_csv' => 'user_polygons#generate_csv'
    get 'projects/export_data' => 'projects#export_data'
    get 'users/export_data' => 'users#export_data'
    get 'projects/generate_csv' => 'projects#generate_csv'
    get 'projects/kpi' => 'projects#kpi'
    get 'future_projects/export_data' => 'future_projects#export_data'
    get 'future_projects/generate_csv' => 'future_projects#generate_csv'
    get 'transactions/export_data' => 'transactions#export_data'
    get 'transactions/generate_csv' => 'transactions#generate_csv'
    get 'transactions/export_data_sii' => 'transactions#export_data_sii'
    get 'transactions/generate_csv_sii' => 'transactions#generate_csv_sii'
    get 'periods/active_periods'
    get 'uf_conversions/calculate_uf' => 'uf_conversions#calculate_uf'
    get 'counties/search_geojson' => 'counties#search_geojson'
    resources :agencies
    resources :periods
    resources :import_processes
    resources :companies
    resources :county_ufs
    resources :future_projects
    resources :transactions
    resources :feedbacks
    resources :building_regulations
    resources :future_project_sub_types

    resources :regions

    resources :projects do
    resources :project_instances do

    resources :project_instance_mixes
    end
    end
    resources :project_mixes
    resources :roles
    resources :users
    resources :counties
    resources :surveyors
    resources :uf_conversions
    resources :layer_types
    get 'dashboards/index'
  root 'dashboards#index'
  end

  namespace :flex do
    get 'flex_reports/search_data_for_filters'
    get 'flex_reports/search_data_for_table'
    get 'flex_reports/building_regulation_download' => 'flex_reports#building_regulation_download'
    post 'flex_reports/search_data_for_charts'
    resources :dashboards, only: [:index, :new, :create]
    resources :tenements
    resources :flex_reports, only: [:index, :new, :create, :show]

    root 'flex_reports#index'
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

  resources :future_project_types
  resources :project_types
  resources :seller_types
  devise_for :users, :controllers => { registrations: 'flex/registrations' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboards#index'
end
 match '*path', to: redirect("/#{I18n.default_locale}/%{path}"), via: :all
   match '', to: redirect("/#{I18n.default_locale}"), via: :all
end
