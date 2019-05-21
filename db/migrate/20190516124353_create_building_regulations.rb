class CreateBuildingRegulations < ActiveRecord::Migration[5.2]
  def change
    create_table :building_regulations do |t|
      t.string :building_zone
      t.numeric :construct
      t.numeric :land_ocupation
      t.string :site
      t.multi_polygon :the_geom, srid: 4326
      t.string :identifier
      t.references :density_type, foreign_key: true
      t.references :county, foreign_key: true
      t.string :comments
      t.string :hectarea_inhabitants
      t.string :grouping
      t.string :parkings
      t.integer :am_cc
      t.string :aminciti
      t.string :icinciti
      t.string :osinciti

      t.timestamps
    end
  end
end
