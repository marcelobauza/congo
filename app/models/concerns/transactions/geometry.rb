module Transactions::Geometry
  extend ActiveSupport::Concern

  module ClassMethods
    def method_selection filters
      case filters[:geometryType]
      when 'polygon'
        polygon = filters[:polygon]

        condition = where("ST_Contains(ST_SetSRID(ST_GeomFromGeoJSON('{
                          \"type\":\"Polygon\",
                          \"coordinates\": #{polygon}}'
                         ), 4326), transactions.the_geom)"
                         ).where("ST_Intersects(ST_SetSRID(ST_GeomFromGeoJSON('{
                                 \"type\":\"Polygon\",
                                 \"coordinates\": #{polygon}}'
                                ), 4326), building_regulations.the_geom)"
                        )
      when 'circle'
        condition = where(
          "ST_DWithin(transactions.the_geom, ST_GeomFromText('POINT(#{filters[:point]})',
          #{Util::WGS84_SRID}), #{filters[:radius]})"
          ).where("ST_Intersects(ST_buffer(ST_GeomFromText('POINT(#{filters[:point]})',
                  #{Util::WGS84_SRID}), #{filters[:radius]}), building_regulations.the_geom)"
          )
      end

    condition
    end
  end
end
