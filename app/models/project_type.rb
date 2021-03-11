class ProjectType < ApplicationRecord
 has_many :projects
 has_many :future_projects

  DEPARTMENTS = "Departamentos"
  HOUSES      = "Casas"

  def self.get_project_type_by_first_letter(projtype)
    ProjectType.find_or_create_by(abbreviation: projtype)
  end
end
