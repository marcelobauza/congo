class ProjectHomeReport < ApplicationRecord
  def self.filters_project_types filters
    if filters[:project_type_ids].present?
      where(project_type_id: filters[:project_type_ids])
    else
      all
    end
  end
end
