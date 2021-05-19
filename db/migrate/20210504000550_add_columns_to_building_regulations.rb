class AddColumnsToBuildingRegulations < ActiveRecord::Migration[5.2]
  def change
    change_table :building_regulations do |t|
      t.boolean :freezed, default: false
      t.string :freezed_observations
    end
  end
end
