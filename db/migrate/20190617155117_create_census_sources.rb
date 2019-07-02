class CreateCensusSources < ActiveRecord::Migration[5.2]
  def change
    create_table :census_sources do |t|
      t.string :name

      t.timestamps
    end
  end
end
