json.array! @data do |p|
  json.id p.id
  json.building_zone p.building_zone
  json.construct p.construct
  json.land_ocupation p.land_ocupation
  json.density_type p.density_type.name
  json.am_cc p.am_cc
  json.icinciti p.icinciti
  json.osinciti p.osinciti
  json.aminciti p.aminciti
  json.hectarea_inhabitants p.hectarea_inhabitants
  json.site p.site
  json.use_allow do 
    json.name p.land_use_types.map &:name
  end
end

