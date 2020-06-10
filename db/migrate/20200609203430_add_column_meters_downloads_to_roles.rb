class AddColumnMetersDownloadsToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :square_meters_download_area, :integer, default: 0
    add_column :roles, :meters_download_radius, :integer, default: 0
  end
end
