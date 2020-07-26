module Projects::Exports
  extend ActiveSupport::Concern

  module ClassMethods
    def get_csv_data(filters)
      joins = [
        :county,
        :project_type,
        project_instances: [:project_status, { project_instance_mixes: :project_mix }]
      ]

      select =  "projects.code, projects.name, projects.address, projects.floors, projects.project_type_id, projects.build_date, projects.sale_date, projects.transfer_date, projects.pilot_opening_date, projects.quantity_department_for_floor , projects.elevators, projects.general_observation, project_status_id, "
      select += " bimester, year, cadastre, "
      select += " stock_units, mix_usable_square_meters, mix_terrace_square_meters, living_room, service_room, h_office, uf_min, uf_max, uf_parking, uf_cellar, common_expenses, total_units, t_min, t_max, home_type, model, projects.the_geom, "
      select += " counties.name as countyname, "
      select += " project_types.name as project_type_name, "
      select += " project_statuses.name as project_status_name,"
      select += " project_mixes.bedroom as bedroom, "
      select += " project_mixes.bathroom as bathroom "

      projects = Project.select(select).
        joins(joins).
        project_counties_or_polygon(filters).
        project_instances_bimester(filters).
        project_instances_year(filters).
        project_project_type(filters).
        order("projects.created_at")

      return CsvParser.get_projects_csv_data(projects)
    end

    def project_counties_or_polygon filters
      if !filters['polygon_id'].empty?
        session_saved = ApplicationStatus.find(filters[:polygon_id])
        if !session_saved[:filters]['wkt'].nil?
          where(WhereBuilder.build_within_condition(session_saved[:filters]['wkt'], 'projects.the_geom'))
        elsif !session_saved[:filters]['centerpt'].nil?
          where(WhereBuilder.build_within_condition_radius(session_saved[:filters]['centerpt'], session_saved[:filters]['radius'], false, 'projects.the_geom'))
        else
          project_counties filters
        end
      else
        project_counties filters
      end
    end

    def project_counties filters
      counties = filters[:county_id].reject!(&:blank?)

      counties.any? ? where(county_id: counties) : all
    end

    def project_instances_bimester filters
      filters['bimester'].present? ? where(project_instances: { bimester: filters['bimester'].to_i }) : all
    end

    def project_instances_year filters
      filters['year'].present? ? where(project_instances: { year: filters['year'].to_i }) : all
    end

    def project_project_type filters
      filters['project_type_id'].present? ? where(project_type_id: filters['project_type_id'].to_i) : all
    end
  end
end
