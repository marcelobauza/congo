module Projects::Scopes
  extend ActiveSupport::Concern

  module ClassMethods

    def find_index(filters)
      Project.includes(:project_type, :project_instances).
        bimesters_filters(filters[:bimester_id]).
        year_filters(filters[:date_id]).
        code_filters(filters[:search]).
        counties_filters(filters[:county_id]).
        project_types_filters(filters[:project_type_id]).
        order('project_instances.year ASC, project_instances.bimester ASC')
    end

    def bimesters_filters bimester
      bimester.present? ? where(project_instances: {bimester: bimester}) : all
    end

    def counties_filters county_id
      county_id.present? ? where(county_id: county_id) : all
    end

    def year_filters year
      year.present? ? where(project_instances: {year: year}) : all
    end

    def code_filters code
      code.present? ? where(code: code) : all
    end

    def project_types_filters project_type_id
      project_type_id.present? ? where(project_type_id: project_type_id) : all
    end
  end
end
