module ProjectTypesHelper

  def project_types_for_select
    projects = ProjectType.select(:id, :name).order(:name)
    projects.map {|c| [c.name, c.id]}
  end

end
