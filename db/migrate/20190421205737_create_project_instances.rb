class CreateProjectInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :project_instances do |t|
      t.references :project, foreign_key: true
      t.references :project_status, foreign_key: true
      t.integer :bimester
      t.integer :year
      t.boolean :active, default: true
      t.string :comments
      t.string :cadastre
      t.boolean :validated, default: false

      t.timestamps
    end
  end
end
