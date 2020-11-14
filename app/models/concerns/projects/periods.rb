module Projects::Periods
  extend ActiveSupport::Concern

  module ClassMethods
    def get_last_period filters

      if !filters[:county_id].nil?
        conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id])
      elsif !filters[:wkt].nil?
        conditions = WhereBuilder.build_within_condition(filters[:wkt])
      else
        conditions = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] )
      end

      last_period_active = Period.where(active: true).order(year: :desc, bimester: :desc).first
      period             = Project.joins(:project_instances).
                             where(conditions).
                             where('project_instances.year <= ? and bimester <= ?', last_period_active.year, last_period_active.bimester ).
                             order('project_instances.year desc', 'project_instances.bimester desc').
                             select('project_instances.year', 'project_instances.bimester').first
    end
  end
end
