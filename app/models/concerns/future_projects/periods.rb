module FutureProjects::Periods
  extend ActiveSupport::Concern

  module ClassMethods
    def get_last_period filters
      last_period_active = Period.where(active: true).order(year: :desc, bimester: :desc).first
      period             = FutureProject.select(:year, :bimester).
                             where(active: 'true').
                             method_selections(filters).
                             where('year <= ? ', last_period_active.year).
                             order(year: :desc, bimester: :desc).first
    end

    def method_selections filters
      if !filters[:county_id].nil?
        where(WhereBuilder.build_in_condition("county_id",filters[:county_id]))
      elsif (wkt = JSON.parse(filters[:wkt]).present?)
        where(WhereBuilder.build_within_condition(wkt))
      elsif !filters[:centerpt].empty? && !filters[:radius].empty?
        where(WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius]))
      else
        all
      end
    end

    def get_first_bimester_with_future_projects
      period = FutureProject.select("future_projects.year, future_projects.bimester").
        joins(build_joins.join(" ")).
        where("active = true").
        group("year, bimester").
        order("year, bimester").first

      return nil if period.nil?
      return {:period => period.bimester, :year => period.year}
    end
  end
end
