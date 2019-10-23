json.array! @data do |transaction|
  json.id transaction.id
  json.bimester transaction.bimester
  json.year transaction.year 
  json.address transaction.address 
  json.seller_name transaction.seller_name
  json.buyer_name transaction.buyer_name
  json.sheet transaction.sheet
  json.number transaction.number
  json.inscription_date transaction.inscription_date 
  json.department transaction.department
  json.calculated_value transaction.calculated_value
  json.blueprint transaction.blueprint
  json.cellar transaction.cellar
  json.parkingi transaction.parkingi
  json.role transaction.role
  json.uf_m2_u transaction.uf_m2_u
  json.uf_m2_t transaction.uf_m2_t
  json.total_surface_building transaction.total_surface_building
  json.total_surface_terrain transaction.total_surface_terrain

json.property_types do
  json.name transaction.property_type.name
end

json.seller_types do
  json.name transaction.seller_type.name
end
end

