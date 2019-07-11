class CreateTaxLands < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_lands do |t|
      t.string :rol_number
      t.string :address
      t.string :destination_code
      t.string :land_m2
      t.integer :county_sii_id

      t.timestamps
    end
  end
end
