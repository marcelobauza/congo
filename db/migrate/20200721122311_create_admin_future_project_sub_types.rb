class CreateAdminFutureProjectSubTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :future_project_sub_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
