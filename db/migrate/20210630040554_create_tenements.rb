class CreateTenements < ActiveRecord::Migration[5.2]
  def change
    create_table :tenements do |t|
      t.string :address
      t.references :property_type, foreign_key: true
      t.references :county, foreign_key: true
      t.decimal :building_surface, precision: 8, scale: 2
      t.string :terrain_surface, precision:8, scale: 2
      t.integer :parking
      t.integer :cellar
      t.string :uf
      t.references :flex_report, foreing_key: true

      t.timestamps
    end
  end
end
