class CreateDensityTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :density_types do |t|
      t.string :name
      t.string :color
      t.integer :position
      t.integer :identifier

      t.timestamps
    end
  end
end
