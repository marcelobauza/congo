class RentIndicator < ApplicationRecord



  def self.rent_geo params
    #polygon = JSON.parse(params[:wkt])


#polygon
    #pp =  "ST_intersects(geom, ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"polygon\", \"coordinates\":#{polygon[0]}},4326'), #{Util::WGS84_SRID}))"
    #pp_s =  "ST_AsEwkt(ST_Difference(ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"polygon\", \"coordinates\":#{polygon[0]}},4326'), #{Util::WGS84_SRID}), geom)) as geom, geocode"
    #
    #county
   # rent = HomogeneousZone.where("st_intersects(geom, (select the_geom from counties where code = '13101'))").

    centerpt = params[:centerpt]
    radius = params[:r].to_f
    radius_b = params[:r].to_f / 100000
    pp = "ST_DWithin(ST_GeomFromText('POINT(#{centerpt})', 4326), geom, #{radius},false)"
    #pp = "ST_intersects(geom, ST_buffer(st_intersection(geom, ST_GeomFromText('POINT(#{centerpt})', 4326), #{radius}, 'quad_segs=8')))"
    #pp_s = "ST_AsEwkt(ST_Difference(ST_buffer(ST_intersection(geom, ST_GeomFromText('POINT(#{centerpt})',4326) ), #{radius_b}, 'quad_segs=8'), geom)) as geom, geocode"
    pp_s = "st_asewkt(ST_buffer(ST_GeomFromText('POINT(#{centerpt})', 4326), #{radius_b})) as geom, geocode"
    rent =  HomogeneousZone.where(pp).select(pp_s).
      order(id: :desc).limit(5000)

    factory = RGeo::GeoJSON::EntityFactory.instance
    feature = []
    rent.each do |c|
      feature << factory.feature(c.geom,nil,{desc: c.geocode})
    end

    output_geojson_collection =  RGeo::GeoJSON.encode factory.feature_collection(feature)
  end
end
