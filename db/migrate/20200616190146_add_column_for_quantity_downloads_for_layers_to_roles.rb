class AddColumnForQuantityDownloadsForLayersToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :square_meters_download_projects, :integer, default: 0
    add_column :roles, :square_meters_download_future_projects, :integer, default: 0
    add_column :roles, :square_meters_download_transactions, :integer, default: 0
    add_column :roles, :meters_download_radius_projects, :integer, default: 0
    add_column :roles, :meters_download_radius_future_projects, :integer, default: 0
    add_column :roles, :meters_download_radius_transactions, :integer, default: 0
    add_column :roles, :total_download_projects, :integer, default: 0
    add_column :roles, :total_download_future_projects, :integer, default: 0
    add_column :roles, :total_download_transactions, :integer, default: 0
  end
end
