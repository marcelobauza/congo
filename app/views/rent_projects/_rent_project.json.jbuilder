json.extract! rent_project, :id, :code, :name, :county_id, :project_type_id, :floors, :sale_date, :catastral_date, :offer, :surface_util, :terrace, :price, :the_geom, :bedroom, :bathroom, :half_bedroom, :total_beds, :population_per_building, :square_meters_terrain, :uf_terrain, :bimester, :year, :created_at, :updated_at
json.url rent_project_url(rent_project, format: :json)
