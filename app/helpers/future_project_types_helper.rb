module FutureProjectTypesHelper
  def future_project_types_for_select
    projects = FutureProjectType.select(:id, :name).order(:name)
    projects.map {|c| [c.name, c.id]}
  end
end
