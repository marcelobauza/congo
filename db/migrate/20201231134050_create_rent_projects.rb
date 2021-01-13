class CreateRentProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :rent_projects do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.references :county, foreign_key: true
      t.references :project_type, foreign_key: true
      t.integer :floors, null:false
      t.date :sale_date
      t.date :catastral_date
      t.integer :offer
      t.float :surface_util
      t.float :terrace
      t.numeric :price
      t.st_point :the_geom
      t.integer :bedroom, null: false
      t.integer :bathroom, null: false
      t.integer :half_bedroom
      t.integer :total_beds
      t.integer :population_per_building
      t.numeric :square_meters_terrain
      t.numeric :uf_terrain
      t.integer :bimester, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
