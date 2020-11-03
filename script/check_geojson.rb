st1 = JSON.parse(File.read('script/ejemplo_error.geojson'))
  json_data = RGeo::GeoJSON.decode(st1, :json_parser => :json)
  json_data.each_with_index do |a, index|
   byebug
        geom = a.geometry.as_text
        da = a.properties
        # data = {}
        # da.each do |a| data[a[0].downcase] = a[1] end
        # building = BuildingRegulation.find_or_initialize_by(identifier: data["id"])
        # building.save_building_regulation_data(geom, data)
  end
