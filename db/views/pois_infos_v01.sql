Select 
  p.name, ps.name as subcategories, p.the_geom, counties.id as county_id 
from 
  pois p  
    inner join poi_subcategories ps on p.poi_subcategory_id = ps.id
    inner join counties on st_contains(counties.the_geom, p.the_geom)
