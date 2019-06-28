module ApplicationHelper
  def safe_action_name action
    return "action_#{action}"
  end

  def counties_for_select
    counties = County.find(:all, :select => "id, name", :order => "name")
    counties.map { |county| [county.name, county.id] }
  end

end
