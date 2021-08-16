class AddColumnCentroidToRegions < ActiveRecord::Migration[5.2]
  def change
    add_column :regions, :centroid, :st_point
  end
end
