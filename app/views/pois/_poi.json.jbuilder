json.extract! poi, :id, :name, :poi_subcategory_id, :the_geom, :created_at, :updated_at
json.url poi_url(poi, format: :json)
