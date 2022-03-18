class ProjectHomeReport < ApplicationRecord
  def self.filters_project_types filters
    if filters[:project_type_ids].present?
      where(project_type_id: filters[:project_type_ids])
    else
      all
    end
  end

  def self.filters_status_projects filters
    if filters[:project_status_ids].present?
      where(project_status_id: filters[:project_status_ids])
    else
      all
    end
  end

  def self.filters_project_mixes filters
    if filters[:mix_ids].present?
      where(mix_id: filters[:mix_ids])
    else
      all
    end
  end
end
