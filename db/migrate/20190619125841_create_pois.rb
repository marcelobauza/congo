class CreatePois < ActiveRecord::Migration[5.2]
  def change
    create_table :pois do |t|
      t.string :name
      t.references :poi_subcategory, foreign_key: true
      t.st_point :the_geom

      t.timestamps
    end
  end
end
