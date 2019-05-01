class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :code
      t.string :name
      t.string :address
      t.integer :floors, default: 0
      t.references :county
      t.references :agency
      t.references :project_type
      t.st_point :the_geom
      t.string :build_date
      t.string :sale_date
      t.string :transfer_date
      t.string :pilot_opening_date
      t.integer :quantity_department_for_floor
      t.integer :elevators
      t.text :general_observation

      t.timestamps
    end
  end
end
