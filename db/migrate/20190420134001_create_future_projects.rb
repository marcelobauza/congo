class CreateFutureProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :future_projects do |t|
      t.string :code
      t.string :address
      t.string :name
      t.string :role_number
      t.string :file_number
      t.date :file_date
      t.string :owner
      t.string :legal_agent
      t.string :architect
      t.integer :floors
      t.integer :undergrounds
      t.integer :total_units
      t.integer :total_parking
      t.integer :total_commercials
      t.numeric :m2_approved
      t.numeric :m2_built
      t.numeric :m2_field
      t.date :cadastral_date
      t.string :comments
      t.integer :bimester
      t.integer :year
      t.string :cadastre
      t.boolean :active
      t.references :project_type, foreign_key: true
      t.references :future_project_type, foreign_key: true
      t.references :county, foreign_key: true
      t.st_point :the_geom
      t.integer :t_ofi

      t.timestamps
    end
  end
end
