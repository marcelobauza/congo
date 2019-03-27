class AddExtensionPostgis < ActiveRecord::Migration[5.2]
  def change
      enable_extension "postgis"
      enable_extension "fuzzystrmatch"
      enable_extension "postgis_topology"
  end
end
