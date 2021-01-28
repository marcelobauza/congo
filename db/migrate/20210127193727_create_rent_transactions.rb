class CreateRentTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :rent_transactions do |t|
      t.integer :property_type_id
      t.string :address
      t.integer :sheet
      t.integer :number
      t.date :inscription_date
      t.string :buyer_name
      t.integer :seller_type_id
      t.string :department
      t.string :blueprint
      t.numeric :uf_value, precision: 12, scale: 2
      t.numeric :real_value, precision: 12, scale: 2
      t.numeric :calculated_value, precision: 12, scale: 2
      t.integer :quarter
      t.date :quarter_date
      t.integer :year
      t.numeric :sample_factor, precision: 12, scale: 2
      t.integer :county_id
      t.integer :cellar
      t.integer :parking
      t.string :role
      t.string :seller_name
      t.string :buyer_rut
      t.numeric :uf_m2, precision: 12, scale: 2
      t.integer :tome
      t.string :lot
      t.string :block
      t.string :village
      t.numeric :surface, precision: 12, scale: 2
      t.string :requiring_entity
      t.string :comments
      t.integer :surveyor_id
      t.boolean :active
      t.integer :bimester
      t.integer :code_sii
      t.numeric :total_surface_building, precision: 12, scale: 2
      t.numeric :total_surface_terrain, precision: 12, scale: 2
      t.numeric :uf_m2_u, precision: 12, scale: 2
      t.numeric :uf_m2_t, precision: 12, scale: 2
      t.string :role_1
      t.string :role_2
      t.string :role_3
      t.string :code_destination
      t.string :code_material
      t.string :year_sii
      t.string :role_associated
      t.string :additional_roles
      t.st_point :the_geom

      t.timestamps
    end
  end
end
