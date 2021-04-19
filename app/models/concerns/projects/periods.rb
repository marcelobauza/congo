module Projects::Periods
  extend ActiveSupport::Concern

  module ClassMethods
    def get_last_period filters
      periods_active = Period.where(active: true).order(year: :desc, bimester: :desc)
      period = periods_active.last

      periods_active.each do |p|
        period = Project.joins(:project_instances).
          method_selections(filters).
          where(project_instances: {bimester: p.bimester, year: p.year}).
          select('project_instances.year', 'project_instances.bimester')

        break unless period.empty?
      end

      period
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
  end
end
