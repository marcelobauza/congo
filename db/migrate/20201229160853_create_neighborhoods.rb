class CreateNeighborhoods < ActiveRecord::Migration[5.2]
  def change
    create_table :neighborhoods do |t|
      t.string :name
      t.integer :total_houses
      t.integer :total_departments
      t.flaot :tenure
      t.st_polygon :the_geom, srid: 4326

      t.timestamps
    end
  end
end
