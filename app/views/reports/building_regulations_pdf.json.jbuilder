json.array! @data do |p|
  json.id p.id
  json.aminciti p.aminciti
  json.building_zone p.building_zone
  json.use_allow do 
    json.name p.land_use_types.map &:name
  end
  json.construct p.construct
  json.osinciti p.osinciti
  json.site p.site
  json.density_types do 
    json.name @data[0].density_type.name
  end
  json.hectarea_inhabitants p.hectarea_inhabitants
  json.grouping p.grouping
  json.icinciti p.icinciti
  json.site p.site

end

