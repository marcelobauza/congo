class CreateRentFutureProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :rent_future_projects do |t|
      t.string :code
      t.string :address
      t.string :name
      t.string :role_number
      t.numeric :file_number
      t.date :file_date
      t.string :owner
      t.string :legal_agent
      t.string :architech
      t.integer :floors
      t.integer :undergrounds
      t.integer :total_units
      t.integer :total_parking
      t.integer :total_commercials
      t.numeric :m2_approved, precision: 12, scale: 2
      t.numeric :m2_built, precision: 12, scale: 2
      t.numeric :m2_field, precision: 12, scale: 2
      t.string :t_ofi
      t.date :cadastral_date
      t.text :comments
      t.integer :bimester
      t.integer :year
      t.integer :project_type_id
      t.string :future_project_type_id
      t.integer :county_id
      t.st_point :the_geom

      t.timestamps
    end
  end
end
