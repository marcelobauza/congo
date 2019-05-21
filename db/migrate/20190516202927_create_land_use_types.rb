class CreateLandUseTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :land_use_types do |t|
      t.string :name
      t.string :abbreviation
      t.integer :identifier

      t.timestamps
    end
  end
end
