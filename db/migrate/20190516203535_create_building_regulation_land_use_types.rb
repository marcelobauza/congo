class CreateBuildingRegulationLandUseTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :building_regulation_land_use_types do |t|
      t.references :building_regulation, foreign_key: true, index: {:name => "index_building_regulation_id"}
      t.references :land_use_type, foreign_key: true

      t.timestamps
    end
  end
end
