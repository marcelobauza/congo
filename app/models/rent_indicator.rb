class RentIndicator < ApplicationRecord

  include GeometryOptions

  def self.rent_geo filters
    #county
   # rent = HomogeneousZone.where("st_intersects(geom, (select the_geom from counties where code = '13101'))").

    centerpt = filters[:centerpt]
    radius = filters[:r].to_f
    radius_b = filters[:r].to_f / 100000
    #pp = "ST_DWithin(ST_GeomFromText('POINT(#{centerpt})', 4326), geom, #{radius},false)"
    ##pp = "ST_intersects(geom, ST_buffer(st_intersection(geom, ST_GeomFromText('POINT(#{centerpt})', 4326), #{radius}, 'quad_segs=8')))"
    ##pp_s = "ST_AsEwkt(ST_Difference(ST_buffer(ST_intersection(geom, ST_GeomFromText('POINT(#{centerpt})',4326) ), #{radius_b}, 'quad_segs=8'), geom)) as geom, geocode"
    #pp_s = "st_asewkt(ST_buffer(ST_GeomFromText('POINT(#{centerpt})', 4326), #{radius_b})) as geom, geocode"
    rent =  HomogeneousZone.where(conditions_by(filters)).select(selection_by(filters), 'geocode').
      order(id: :desc).limit(5000)

    factory = RGeo::GeoJSON::EntityFactory.instance
    feature = []
    rent.each do |c|
      feature << factory.feature(c.geom,nil,{desc: c.geocode})
    end

    output_geojson_collection =  RGeo::GeoJSON.encode factory.feature_collection(feature)
  end

  def select_neighboorhood
    b = Neighboorhood.first
  end
end
