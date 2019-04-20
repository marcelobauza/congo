class CreateFutureProjectTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :future_project_types do |t|
      t.string :name
      t.string :abbrev
      t.string :color

      t.timestamps
    end
  end
end
