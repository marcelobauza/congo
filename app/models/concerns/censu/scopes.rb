module Censu::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def verification_for_region filters

      if !filters[:county_id].nil?
        name_county = County.where(id: filters[:county_id]).pluck(:name)
        conditions = validation_if_name_exists(name_county)
      elsif !filters[:wkt].nil?
        name_counties = County.where(WhereBuilder.build_intersects_condition(filters[:wkt])).pluck(:name)
        conditions = validation_if_name_exists(name_counties)
      else
        name_counties = County.where(WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] )).pluck(:name)
        conditions = validation_if_name_exists(name_counties)
      end
      conditions
    end

    def validation_if_name_exists name

      region = %w(Santiago Providencia)
      name.each do |n| 
        return  'santiago_only= true' if region.include? n
      end
      return 'santiago_only= false'
    end
  end
end
