SELECT
  c.name,
  u.id as user_id,
  st_centroid(c.the_geom) as geom
FROM counties_users cu
inner join users u on cu.user_id = u.id
inner join counties c on cu.county_id = c.id
