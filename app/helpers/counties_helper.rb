module CountiesHelper

  def counties_for_select
    County.sorted_by_name.all { |county| [county.name, county.id] }
  end   
end
