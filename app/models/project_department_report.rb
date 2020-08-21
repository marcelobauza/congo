class ProjectDepartmentReport < ApplicationRecord
  def self.filters_project_types filters
    if filters[:project_type_id]
      where(project_type_id: filters[:project_type_id])
    else
      all
    end
  end
end
