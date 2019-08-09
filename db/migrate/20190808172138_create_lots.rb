class CreateLots < ActiveRecord::Migration[5.2]
  def change
    create_table :lots do |t|
      t.numeric :surface
      t.references :county, foreign_key: true
      t.multi_polygon :the_geom
      t.string :identifier

      t.timestamps
    end
  end
end
