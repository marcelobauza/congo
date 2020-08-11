module FutureProjects::Exports
  extend ActiveSupport::Concern

  module ClassMethods
    def get_csv_data(filters)
      future_projects = FutureProject.
        includes(:county, :project_type, :future_project_type).
        filter_file_date(filters).
        future_project_counties_or_polygon(filters).
        project_type(filters).
        future_project_types(filters).
        order(:file_date)

      return CsvParser.get_future_projects_csv_data(future_projects)
    end

    def filter_file_date filters
      filters['date_from'].present? && filters['date_to'].present? ? where(file_date: filters['date_from']..filters['date_to']) : all
    end

    def project_type filters
      pt = filters['project_type_id'].reject(&:blank?)
      filters['project_type_id'].present? ? where(project_type_id: pt) : all
    end

    def future_project_counties_or_polygon filters
      if !filters['polygon_id'].empty?
        session_saved = ApplicationStatus.find(filters[:polygon_id])
        if !session_saved[:filters]['wkt'].nil?
          where(WhereBuilder.build_within_condition(session_saved[:filters]['wkt'], 'projects.the_geom'))
        elsif !session_saved[:filters]['centerpt'].nil?
          where(WhereBuilder.build_within_condition_radius(session_saved[:filters]['centerpt'], session_saved[:filters]['radius'], false, 'projects.the_geom'))
        else
          future_project_counties filters
        end
      else
        future_project_counties filters
      end
    end

    def future_project_counties filters
      counties = filters[:county_id].reject(&:blank?)

      counties.any? ? where(county_id: counties) : all
    end

    def future_project_types filters
      filters[:future_project_type_id].present? ? where(future_project_type_id: filters[:future_project_type_id]) : all
    end
  end
end
