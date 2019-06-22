class CreateProjectHomeReports < ActiveRecord::Migration[5.2]
  def change
    create_view :project_home_reports
  end
end
