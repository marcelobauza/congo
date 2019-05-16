class CreateCountyUfs < ActiveRecord::Migration[5.2]
  def change
    create_table :county_ufs do |t|
      t.references :county, foreign_key: true
      t.references :property_type, foreign_key: true
      t.numeric :uf_min
      t.numeric :uf_max

      t.timestamps
    end
  end
end
