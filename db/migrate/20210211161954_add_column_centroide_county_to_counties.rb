class AddColumnCentroideCountyToCounties < ActiveRecord::Migration[5.2]
  def change
    add_column :counties, :county_centroid, :st_point
  end
end
