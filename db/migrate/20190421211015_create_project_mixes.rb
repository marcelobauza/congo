class CreateProjectMixes < ActiveRecord::Migration[5.2]
  def change
    create_table :project_mixes do |t|
      t.decimal :bedroom
      t.integer :bathroom
      t.string :mix_type

      t.timestamps
    end
  end
end
