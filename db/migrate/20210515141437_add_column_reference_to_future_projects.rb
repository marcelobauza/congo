class AddColumnReferenceToFutureProjects < ActiveRecord::Migration[5.2]
  def change
    change_table :future_projects do |t|
      t.string :reference
    end
  end
end
