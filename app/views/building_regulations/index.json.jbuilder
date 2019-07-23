json.extract! @data[0], :building_zone, :construct, :osinciti, :aminciti, :hectarea_inhabitants, :grouping, :area

json.density_types do 
  json.name @data[0].density_type.name
end

json.land_use_types @data[1] do |lt|
  json.name lt.name
end
