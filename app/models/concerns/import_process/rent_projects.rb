module ImportProcess::RentProjects
  extend ActiveSupport::Concern

  module ClassMethods
    def parse_rent_projects(geojson_file, import_logger, dir_path)

      st1 = JSON.parse(File.read(geojson_file))
      json_data = RGeo::GeoJSON.decode(st1, :json_parser => :json)
      json_data.each_with_index do |a, index|
        import_logger.current_row_index =index

        if a.geometry.nil?
          import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_BLANK) }
          next
        end

        unless a.geometry.geometry_type.to_s == 'Point'
          import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_POINT) }
          next
        end

        unless a.geometry.valid?
          import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_INVALID) }
          next
        end

        rent_project  = RentProject.new
        factory       = RGeo::Geos.factory(srid: 4326)
        properties    = a.properties
        county        = County.find_by(code: properties['county_code'])
        project_type = ProjectType.find_by(name: properties['project_type_id'].capitalize)

        rent_project.the_geom                = factory.parse_wkt(a.geometry.as_text)
        rent_project.code                    = properties['code']
        rent_project.name                    = properties['name']
        rent_project.county_id               = county.id if county
        rent_project.project_type_id         = project_type.id if project_type
        rent_project.floors                  = properties['floors']
        rent_project.sale_date               = properties['sale_date']
        rent_project.catastral_date          = properties['catastral_date']
        rent_project.offer                   = properties['offer']
        rent_project.surface_util            = properties['surface_util']
        rent_project.terrace                 = properties['terrace']
        rent_project.price                   = properties['price']
        rent_project.bedroom                 = properties['bedroom']
        rent_project.bathroom                = properties['bathroom']
        rent_project.half_bedroom            = properties['half_bedroom']
        rent_project.total_beds              = properties['total_beds']
        rent_project.population_per_building = properties['population_per_building']
        rent_project.square_meters_terrain   = properties['square_meters_terrain']
        rent_project.uf_terrain              = properties['uf_terrain']
        rent_project.bimester                = properties['bimester']
        rent_project.year                    = properties['year']



        if !rent_project.save
          rent_project.errors.full_messages.each do |error_message|
            import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
          end
        else
          rent_project.new_record? ? import_logger.inserted += 1 : import_logger.updated += 1
        end
      end

    end
  end
end
