class AddColumnSubTypesToFutureProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :future_projects, :future_project_sub_type, foreign_key: true
  end
end
