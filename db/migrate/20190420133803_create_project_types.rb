class CreateProjectTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :project_types do |t|
      t.string :name
      t.string :color
      t.boolean :is_active

      t.timestamps
    end
  end
end
