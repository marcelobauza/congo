class CreateTaxUsefulSurfaces < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_useful_surfaces do |t|
      t.string :rol_number
      t.integer :building_sequence_number
      t.string :year
      t.numeric :m2_built
      t.string :destination_code
      t.integer :county_sii_id
      t.string :code_material

      t.timestamps
    end
  end
end
