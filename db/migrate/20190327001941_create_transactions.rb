class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :property_type
      t.string :address
      t.integer :sheet
      t.integer :number
      t.date :inscription_date
      t.string :buyer_name
      t.references :seller_type
      t.string :department
      t.string :blueprint
      t.decimal :uf_value
      t.decimal :real_value
      t.decimal :calculated_value
      t.integer :quarter
      t.date :quarter_date
      t.integer :year
      t.decimal :sample_factor
      t.references :county
      t.date :quarter
      t.st_point :the_geom, :srid => 4326, :with_z => false
      t.integer :year
      t.decimal :sample_factor, precision: 8, scale:2 , dafault: 1.0
      t.integer :cellar, default: 0
      t.integer :parkingi, default: 0
      t.string :role
      t.string :seller_name
      t.string :buyer_rut
      t.decimal :uf_m2
      t.integer :tome
      t.string :lot
      t.string :block
      t.string :village
      t.decimal :surface, precision: 8 , scale: 2
      t.string :requiring_entity
      t.string :comments
      t.references  :user
      t.integer :surveyor_id
      t.boolean :active, default: true 
      t.integer :bimester
      t.integer :code_sii
      t.decimal :total_surface_building , precision: 8, scale: 2
      t.decimal :total_surface_terrain, precision: 8, scale: 2 
      t.decimal :uf_m2_u, precision: 8, scale: 2 
      t.decimal :uf_m2_t, precision: 8, scale: 2 
      t.string :building_regulation
      t.string :role_1 
      t.string :role_2
      t.string :code_destination
      t.string :code_material
      t.string :year_sii
      t.string :role_associated
      t.timestamps
    end
  end
end
