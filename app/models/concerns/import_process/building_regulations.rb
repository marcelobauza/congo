module ImportProcess::BuildingRegulations
  extend ActiveSupport::Concern

  module ClassMethods
    def parse_building_regulations(geojson_file, import_logger)
      file_parsed = JSON.parse(File.read(geojson_file))
      json_data   = RGeo::GeoJSON.decode(file_parsed, json_parser: :json)
      rows        = []
      counties    = []

      json_data.each_with_index do |a, index|
        import_logger.current_row_index = index
        import_logger.processed        += 1

        if a.geometry.nil?
          import_logger.details << {
            :row_index => import_logger.current_row_index,
            :message => I18n.translate(:ERROR_GEOMETRY_BLANK)
          }
          next
        end
        unless a.geometry.geometry_type.to_s == 'MultiPolygon' || a.geometry.geometry_type.to_s == 'Polygon'
          import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
          next
        end

        unless a.geometry.valid?
          import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_INVALID) }
          next
        end

        geometry_text = a.geometry.as_text
        properties    = a.properties
        data          = {}

        properties.each do |idx, value|
          data[idx.downcase] = value
        end

        data['geom'] = geometry_text

        building = BuildingRegulation.where(
          identifier: data['id']
        ).first_or_create

        building.save_building_regulation_data(data)

        if building.errors.any?
          building.errors.full_messages.each do |error_message|
            import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
          end
        else
          import_logger.inserted +=1
        end
      end
    end
  end
end
