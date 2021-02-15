class CreateBots < ActiveRecord::Migration[5.2]
  def change
    create_table :bots do |t|
      t.date :publish
      t.string :code
      t.string :type
      t.string :modality
      t.string :properties
      t.string :region
      t.references :county
      t.string :comune
      t.string :street
      t.string :number
      t.string :furnished
      t.string :apt
      t.integer :floor
      t.integer :bedroom
      t.integer :bathroom
      t.string :parking_lo
      t.string :cellar
      t.numeric :surface, precision: 12, scale: 2
      t.numeric :surface_t, precision: 12, scale: 2
      t.numeric :price, precision: 12, scale: 2
      t.numeric :price_uf, precision: 12, scale: 2
      t.numeric :price_usd, precision: 12, scale: 2
      t.string :real_state
      t.string :phone
      t.string :email
      t.integer :bimester
      t.integer :year
      t.st_point :the_geom

      t.timestamps
    end
  end
end
