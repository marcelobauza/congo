module Projects::Parcels
  extend ActiveSupport::Concern

  module ClassMethods
    def projects_by_parcel year, bimester, area_name
      projects = ProjectInstance.find_by_sql("select project_instances.* from parcels p, projects r inner join project_instances on r.id = project_instances.project_id where st_contains (p.the_geom, r.the_geom) and p.area_name = '#{area_name}' and year = (#{year - 1}) and bimester = #{bimester}")

      projects.sum {|pi| pi.project_instance_mixes.sum(&:total_units) - pi.project_instance_mixes.sum(&:stock_units)}
    end
  end
end
