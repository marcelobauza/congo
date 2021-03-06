company = Company.where(
  {
    name: 'Inciti',
    projects_downloads: 100,
    transactions_downloads: 100,
    future_projects_downloads: 100
  }
).first_or_create!

role = Role.where(
  {
    name: 'Administrador_r',
    read_only: false,
    square_meters_download_area: 1000,
    meters_download_radius: 100,
    square_meters_download_projects: 1000,
    square_meters_download_future_projects: 100,
    square_meters_download_transactions: 100,
    meters_download_radius_projects: 100,
    meters_download_radius_future_projects: 100,
    meters_download_radius_transactions: 100,
    total_download_projects: 10,
    total_download_future_projects: 10,
    total_download_transactions: 10
  }
).first_or_create!

User.where(
  {
    name: 'admin_r',
    email: 'admin_r@inciti.com'
  }
).first_or_create(
  {
    name: 'admin_r',
    complete_name: 'Admin',
    rut: '7240035-6',
    role: role,
    company: company,
    email: 'admin_r@inciti.com',
    layer_types: [1],
    encrypted_password: User.new.send(:password_digest, '12345678')
  }
)


layer_types = [
  { name: 'future_projects_info', title: 'EM'},
  { name: 'projects_feature_info', title: 'PRV'},
  { name: 'demography_info', title: 'Demografia'},
  { name: 'building_regulations_info', title: 'Normativa'},
  { name: 'transactions_info', title: 'CBR'},
  { name: 'rent_indenticatos', title: 'ICA'}
]

layer_types.map do |layer|
  LayerType.where(layer).first_or_create!
end

