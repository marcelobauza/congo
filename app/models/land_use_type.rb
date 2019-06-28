class LandUseType < ApplicationRecord
  has_many :building_regulation_land_use_types
  has_many :building_regulations, :through => :building_regulation_land_use_types

  def self.get_allowed_use_list(county_id, wkt, centerpt, radius)

    if (county_id.nil? && wkt.nil? && centerpt.nil?)
      return LandUseType.all
    else
      select = "DISTINCT land_use_types.id, land_use_types.name, abbreviation"
      
      conditions = ""
      if !county_id.nil?
        conditions = "county_id = #{county_id}"
      elsif centerpt.nil?
        polygon = JSON.parse(wkt)
        coonditions = "ST_Intersects(the_geom, ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"polygon\", \"coordinates\":#{polygon[0]}}'),4326)', #{Util::WGS84_SRID})"
      else
        conditions = WhereBuilder.build_within_condition_radius(centerpt, radius )
      end
      return LandUseType.select(select).joins(:building_regulations).where(conditions).order('abbreviation')
    end
  end


end
