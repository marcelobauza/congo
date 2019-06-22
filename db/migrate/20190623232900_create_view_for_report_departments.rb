class CreateViewForReportDepartments < ActiveRecord::Migration[5.2]
  def change
    create_view :project_department_reports
  end
end
