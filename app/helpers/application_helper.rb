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
end
