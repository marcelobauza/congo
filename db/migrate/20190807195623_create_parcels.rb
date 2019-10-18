class CreateParcels < ActiveRecord::Migration[5.2]
  def change
    create_table :parcels do |t|
      t.string :region
      t.string :province
      t.string :commune
      t.numeric :shape_area
      t.integer :code
      t.string :area_name
      t.multi_polygon :the_geom
      t.timestamps
    end
  end
end
