class CreateUserPolygons < ActiveRecord::Migration[5.2]
  def change
    create_table :user_polygons do |t|
      t.references :user, foreign_key: true
      t.text :wkt
      t.string :layertype
      t.string :text

      t.timestamps
    end
  end
end
