SELECT building_regulations.id,
building_regulations.building_zone,
( SELECT array_to_string(array_agg(land_use_types.abbreviation), ','::text) AS array_to_string
  FROM building_regulation_land_use_types
  JOIN land_use_types ON building_regulation_land_use_types.land_use_type_id = land_use_types.id
  WHERE building_regulation_land_use_types.building_regulation_id = building_regulations.id) AS land_use,
building_regulations.the_geom,
round(building_regulations.construct, 1) AS construct,
round(building_regulations.land_ocupation, 1) AS land_ocupation,
building_regulations.hectarea_inhabitants AS max_density,
building_regulations."grouping",
building_regulations.site,
building_regulations.comments,
building_regulations.aminciti AS am_cc,
building_regulations.parkings,
building_regulations.updated_at,
building_regulations.county_id,
density_types.color
FROM building_regulations
JOIN density_types ON building_regulations.density_type_id = density_types.id
ORDER BY building_regulations.updated_at DESC;
