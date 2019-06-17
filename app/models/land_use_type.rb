class LandUseType < ApplicationRecord
  has_many :building_regulation_land_use_types
  has_many :building_regulations, :through => :building_regulation_land_use_types

  def self.get_allowed_use_list(county_id, wkt)
    if (county_id.nil? && wkt.nil?)
      return LandUseType.all
    else
      select = "DISTINCT land_use_types.id, land_use_types.name, abbreviation"

      conditions = ""
      if county_id.nil?
        conditions = "ST_Intersects(the_geom, ST_GeomFromText('#{wkt}', #{Util::WGS84_SRID}))" if wkt != ""
      else
        conditions = "county_id = #{county_id}"
      end
      return LandUseType.select(select).joins(:building_regulations).where(conditions).order('abbreviation')
    end
  end


end
