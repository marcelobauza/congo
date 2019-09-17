class Censu < ApplicationRecord
  belongs_to :census_source
  belongs_to :county


  def self.average_people_by_home(filters)

    if !filters[:county_id].nil?
      conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id]) + Util.and
    elsif !filters[:wkt].nil?
      conditions = WhereBuilder.build_within_condition(filters[:wkt]) + Util.and
      else
        conditions = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] ) + Util.and
      end

    conditions += "census.census_source_id = 1"
    #    conditions += "#{Util.and}census.county_id IN(#{User.current.county_ids.join(",")})" if User.current.county_ids.length > 0

      select = "SUM(home_tot) as homes_total, SUM(age_tot) as people_total,
                                          (SUM(age_tot) / cast(SUM(home_tot) as float)) as people_avg"

      @data = Censu.where(conditions).select(select).take

  end


end
