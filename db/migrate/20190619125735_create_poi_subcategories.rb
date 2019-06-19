class CreatePoiSubcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :poi_subcategories do |t|
      t.string :name

      t.timestamps
    end
  end
end
