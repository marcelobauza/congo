module ApplicationHelper
  def safe_action_name action
    return "action_#{action}"
  end

  def counties_for_select
    counties = County.find(:all, :select => "id, name", :order => "name")
    counties.map { |county| [county.name, county.id] }
  end

  def link_to_add_fields(name, f, association, locals={})
    new_object = f.object.send(association).klass.new
    id         = new_object.object_id

    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to(name, '#', class: "add_fields btn btn-secondary btn-sm #{locals[:class]}", data: {id: id, fields: fields.gsub("\n", ""), "#{locals[:data]}": true})
  end

  def user_has_permissions_to_tools?
    allowed_roles = ['IPRO', 'IPRO+', 'Admin', 'MYPE', 'IPRO+ Plus', 'PRO_FLEX']

    allowed_roles.include? current_user.role.name
  end

  def user_has_permissions_to_downloads?
    allowed_roles = ['IPRO+', 'Admin', 'MYPE', 'IPRO+ Plus', 'PRO_FLEX']

    allowed_roles.include? current_user.role.name
  end

  def user_has_permissions_to_flex?
    allowed_roles = ['Admin', 'PRO_FLEX', 'FLEX']

    allowed_roles.include? current_user.role.name
  end
end
