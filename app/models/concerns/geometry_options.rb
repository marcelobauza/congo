module GeometryOptions
  extend ActiveSupport::Concern
  module ClassMethods
    def selection_by filters
      case filters[:type_geometry]
      when 'circle'
      when 'marker'
        @select = '*'
      when 'polygon'
        @select = polygon_select filters
      when 'list'
      end
      @select
    end

    def conditions_by filters
      case filters[:type_geometry]
      when 'circle'
        @conditions = circle_condition filters
      when 'marker'
        @conditions = marker_condition filters
      when 'polygon'
        @conditions = polygon_condition filters
      when 'list'
      end
      @conditions
    end

    private
      def polygon_select filters
        polygon = JSON.parse(filters[:wkt])
        select  = <<-SQL
          ST_AsEwkt(
            ST_Difference(
              ST_SetSRID(
                ST_GeomFromGeoJSON(
                  '{"type": "polygon", "coordinates": #{polygon[0]}}, 4326'
                ), #{Util::WGS84_SRID}
              ), the_geom
            )
          ) as the_geom
        SQL
      end

      def marker_condition filters
        c = filters[:county_id]['0'].join
        conditions = <<-SQL
          ST_Intersects(the_geom,
            (select the_geom from counties
              where id = '#{c}'
            )
            )
        SQL
      end

      def polygon_condition filters
        polygon   = JSON.parse(filters[:wkt])
        condition = <<-SQL
          ST_intersects(
            the_geom,
            ST_SetSRID(
              ST_GeomFromGeoJSON(
                '{"type":"polygon", "coordinates": #{polygon[0]}}, 4326'
              ), #{Util::WGS84_SRID}
            )
          )
        SQL
      end

      def circle_condition filters
        condition = <<-SQL
          ST_DWithin(
            the_geom,
            ST_GeomFromText(
              'POINT(#{filters[:centerpt]})', #{Util::WGS84_SRID}
            ), #{filters[:radius]}, false
          )
        SQL
      end
  end
end
