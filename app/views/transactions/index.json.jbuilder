json.extract! @data, :bimester, :year, :address, :seller_name, :buyer_name, :sheet, :number, :inscription_date, :department, :uf_value, :blueprint, :cellar, :parkingi, :role

json.property_types do
  json.name @data.property_type.name
end

json.seller_types do
  json.name @data.seller_type.name
end

