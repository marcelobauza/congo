module PropertyTypesHelper

  def property_type_for_select
    PropertyType.select(:id,:name).order(:name).map {|t| [t.name, t.id]}
end
end
