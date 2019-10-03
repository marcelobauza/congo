json.extract! @data, :bimester, :year, :address, :seller_name, :buyer_name, :sheet, :number, :inscription_date, :department, :calculated_value, :blueprint, :cellar, :parkingi, :role, :uf_m2_u, :uf_m2_t, :total_surface_building, :total_surface_terrain

json.property_types do
  json.name @data.property_type.name
end

json.seller_types do
  json.name @data.seller_type.name
end

