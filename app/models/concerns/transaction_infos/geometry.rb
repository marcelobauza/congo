module TransactionInfos::Geometry
  extend ActiveSupport::Concern

  module ClassMethods
    def method_selection filters
      case filters[:geometryType]
      when 'polygon'
        polygon = filters[:polygon]

        condition = where("ST_Contains(ST_SetSRID(ST_GeomFromGeoJSON('{
                          \"type\":\"Polygon\",
                          \"coordinates\": #{polygon}}'
                         ), 4326), transaction_infos.the_geom)"
                         )
                        #  .where("ST_Intersects(ST_SetSRID(ST_GeomFromGeoJSON('{
                        #          \"type\":\"Polygon\",
                        #          \"coordinates\": #{polygon}}'
                        #         ), 4326), building_regulations.the_geom)"
                        # )
      when 'circle'
        condition = where(
          "ST_DWithin(the_geom, ST_GeomFromText('POINT(#{filters[:point]})',
          #{Util::WGS84_SRID}), #{filters[:radius]}, false)"
          )
      end

    condition
    end
  end
end
