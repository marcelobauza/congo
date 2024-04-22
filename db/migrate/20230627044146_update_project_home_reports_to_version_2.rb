class UpdateProjectHomeReportsToVersion2 < ActiveRecord::Migration[5.2]
  def change
    update_view :project_home_reports, version: 2, revert_to_version: 1
  end
end
