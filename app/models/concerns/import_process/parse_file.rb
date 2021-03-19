module ImportProcess::ParseFile
  extend ActiveSupport::Concern

  module ClassMethods
    def load_from_zip import
      load_type = import.data_source
      import_process = ImportProcess.find import.id
      import_logger = Ibiza::ImportLogger.new(import_process)
      import_process.update_attributes status: 'working'
      @user_id = import_process.user_id

      ActiveRecord::Base.transaction do
        if load_type == 'Building Regulation' || load_type == 'Lot' || load_type == 'Neighborhood' || load_type == 'Bot'
          shps, dir_path = Util::get_geojson_files_from_zip(import.file_path)
        else
          shps, dir_path = Util::get_shape_files_from_zip(import.file_path)
        end
        dir = []
        shps.each do |shp|
          begin
            parse_shp(shp, load_type, import_logger)

            if import_logger.details.any?
              import_logger.inserted = 0
              import_logger.updated = 0
              raise ActiveRecord::Rollback, "Algo horrible sucedio, vamos para atras con todo"
            else
              import_logger.status = 'success'
            end
          rescue Exception => e

            import_logger.details << {:message => "#{e.to_s}\n#{e.backtrace.join("\n")}"} unless e.instance_of?(ActiveRecord::Rollback)
            import_logger.inserted = 0
            import_logger.updated = 0
            raise ActiveRecord::Rollback, "Algo horrible sucedio, vamos para atras con todo"
          end
        end
        FileUtils.rm_rf(dir_path)
        FileUtils.rm_rf(import.file_path)
      end

      import_logger.save
    end

    private

      def parse_shp(shp_file, load_type, import_logger)
        case load_type
        when "Building Regulation"
          parse_building_regulations(shp_file, import_logger)
        when "Transactions"
          parse_transactions(shp_file, import_logger)
        when "Departments"
          parse_projects(shp_file, "Departamentos", import_logger)
        when "Homes"
          parse_projects(shp_file, "Casas", import_logger)
        when "Future Projects"
          parse_future_projects(shp_file, import_logger)
        when "Lot"
          parse_lots(shp_file, import_logger)
        when "POI"
          parse_pois(shp_file, import_logger)
        when "Counties"
          parse_counties(shp_file, import_logger)
        when "Neighborhood"
          parse_neighborhoods(shp_file, import_logger)
        when "Bot"
          parse_bot(shp_file, import_logger)
        end
      end

      def parse_bot(shp_file, import_logger)
        st1 = JSON.parse(File.read(shp_file))
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

          bot = Bot.new
          factory = RGeo::Geos.factory(srid: 4326)
          properties = a.properties
   #       county = County.find_by(name: properties[:comune])

          bot.the_geom        = factory.parse_wkt(a.geometry.as_text)
          bot.publish         = properties['date']
          bot.code            = properties['code']
          bot.property_status = properties['type']
          bot.modality        = properties['modality']
          bot.properties      = properties['properties']
          bot.region          = properties['region']
    #      bot.county_id       = county.id
          bot.comune          = properties['comune']
          bot.street          = properties['street']
          bot.number          = properties['number']
          bot.furnished       = properties['furnished']
          bot.apt             = properties['apt']
          bot.floor           = properties['floor']
          bot.bedroom         = properties['bedroom']
          bot.bathroom        = properties['bathroom']
          bot.parking_lo      = properties['parking_lo']
          bot.cellar          = properties['bodega']
          bot.surface         = properties['surface_us']
          bot.surface_t       = properties['surface_to']
          bot.price           = properties['price_clp']
          bot.price_uf        = properties['price_uf']
          bot.price_usd       = properties['price_usd']
          bot.real_state      = properties['real_estat']
          bot.phone           = properties['phone']
          bot.email           = properties['email']
          bot.bimester        = properties['bimestre']
          bot.year            = properties['year']

          bot.save!

          if bot.errors.any?
            bot.errors.full_messages.each do |error_message|
              import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
            end
          else
            bot.new_record? ? import_logger.inserted += 1 : import_logger.updated += 1
          end
        end
      end

      def parse_neighborhoods(shp_file, import_logger)
        st1 = JSON.parse(File.read(shp_file))
        json_data = RGeo::GeoJSON.decode(st1, :json_parser => :json)
        json_data.each_with_index do |a, index|
          import_logger.current_row_index =index

          if a.geometry.nil?
            import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
            next
          end
          unless a.geometry.geometry_type.to_s == 'MultiPolygon' || a.geometry.geometry_type.to_s == 'Polygon'
            import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
            next
          end

          unless a.geometry.valid?
            import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
            next
          end
          neighborhood = Neighborhood.new

          factory = RGeo::Geos.factory(srid: 4326)
          neighborhood.the_geom = factory.parse_wkt(a.geometry.as_text)
          neighborhood.name = a.properties['name']
          neighborhood.geocode = a.properties['concat_geo']
          neighborhood.total_houses = a.properties['sum_casas']
          neighborhood.total_departments = a.properties['sum_dptos']
          neighborhood.tenure = a.properties['tenencia']

          neighborhood.save!

          if neighborhood.errors.any?
            neighborhood.errors.full_messages.each do |error_message|
              import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
            end
          else
            neighborhood.new_record? ? import_logger.inserted += 1 : import_logger.updated += 1
          end
        end
      end

      def parse_building_regulations(shp_file, import_logger)

        st1 = JSON.parse(File.read(shp_file))
        json_data = RGeo::GeoJSON.decode(st1, :json_parser => :json)
        json_data.each_with_index do |a, index|
          import_logger.current_row_index =index
          import_logger.processed += 1

          if a.geometry.nil?
            import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
            next
          end
          unless a.geometry.geometry_type.to_s == 'MultiPolygon' || a.geometry.geometry_type.to_s == 'Polygon'
            import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
            next
          end

          unless a.geometry.valid?
            import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
            next
          end
          geom = a.geometry.as_text
          da = a.properties
          data = {}
          da.each do |a| data[a[0].downcase] = a[1] end
          building = BuildingRegulation.find_or_initialize_by(identifier: data["id"])
          building.new_record? ? import_logger.inserted +=1 : import_logger.updated += 1
          building.save_building_regulation_data(geom, data)

          if building.errors.any?
            building.errors.full_messages.each do |error_message|
              import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
            end
          end
        end
      end

      def parse_transactions(shp_file, import_logger)
        RGeo::Shapefile::Reader.open(shp_file) do |shp|
          field = []
          shp.each do |shape|
            if shape.index == 0
              shape.keys.each do |f|
                field.push(f)
              end
            end

            verify_attributes(field, "Transactions")

            import_logger.current_row_index = shape.index
            import_logger.processed += 1

            if shape.geometry.nil?
              import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
              next
            end

            geom     = shape.geometry
            data     = shape.attributes
            bimester = data["BIMESTER"]
            year     = data["INSCRIPTIO"].to_date.year
            number   = data["NUMBER"].to_i

            county   = County.find_by_code(data["CODCOM"].to_i.to_s)
            if county.nil?
              import_logger.details << { :row_index => import_logger.current_row_index, :message => "No se pudo encontrar el county con codigo #{data["CODCOM"]}" }
              next
            end
            tran    = Transaction.where(number: number, bimester: bimester, year: year, county_id: county.id).first_or_initialize
            was_new = tran.new_record?

            if tran.save_transaction_data(geom, data, county.id, @user_id)
              if was_new
                import_logger.inserted +=1
              else
                import_logger.updated +=1
              end
            else
              import_logger.failed += 1
              tran.errors.full_messages.each do |error_message|
                import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
              end
            end
          end
        end
      end

      def parse_projects(shape_file, project_type, import_logger)
        mixes          = []
        instance_mixes = []
        project_code   = nil

        RGeo::Shapefile::Reader.open(shape_file) do |shp|
          field = []

          shp.each do |shape|
            if shape.index == 0
              shape.keys.each do |f|
                field.push(f)
              end
            end

            verify_attributes(field, project_type)

            import_logger.current_row_index = shape.index
            import_logger.processed        += 1

            if shape.geometry.nil?
              import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_POINT) }
              next
            end

            geom = shape.geometry
            data = shape.attributes

            unless data["DORMS_T"].to_i == 0 or data["BANOS_T"].to_i == 0
              mix = ProjectMix.find_or_create_by(bedroom: data["DORMS_T"].to_f,  bathroom: data["BANOS_T"].to_i, mix_type:"#{data["DORMS_T"].to_f}d#{data["BANOS_T"].to_i}b")

              if mix.nil?
                import_logger.failed += 1
                mix.errors.full_messages.each do |error_message|
                  import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
                end
                next
              end

              mix_instance                   = ProjectInstanceMix.new
              mix_instance.mix_id            = mix.id
              mix_instance.stock_units       = data["STOCK"].to_i
              mix_instance.mix_uf_m2         = data["T_UF_M2"].to_f
              mix_instance.mix_selling_speed = data["T_VEL_VTA"].to_f
              mix_instance.mix_uf_value      = data["T_PRECIO_U"].to_f
              mix_instance.total_units       = data["OFERTA_T"].to_i
              mix_instance.uf_min            = data["UF_MIN"].to_i
              mix_instance.uf_max            = data["UF_MAX"].to_i
              mix_instance.discount          = data["DESC"].to_f
              mix_instance.uf_parking        = data['UF_ESTACIO']
              mix_instance.uf_cellar         = data['UF_BODEGA']
              mix_instance.h_office          = data['HOFFICE']
              mix_instance.service_room      = data['TIPO_SERVI']
              mix_instance.living_room       = data['ESTAR']

              if project_type == 'Departamentos'
                mix_instance.mix_usable_square_meters  = data["UTIL_M2"].to_f
                mix_instance.mix_terrace_square_meters = data["TERRAZA_M2"].to_f
              else
                mix_instance.model = data["MODEL"]
                mix_instance.t_min = data["T_MIN"]
                mix_instance.t_max = data["T_MAX"]
                case data["TIPO_C"].to_s
                when "A"
                  mix_instance.home_type               = "Aislada"
                when "P"
                  mix_instance.home_type               = "Pareada"
                when "T"
                  mix_instance.home_type               = "Tren"
                when "A-P"
                  mix_instance.home_type               = "Aislada-Pareada"
                end
                mix_instance.mix_usable_square_meters  = data["UTIL_M2"].to_f
                mix_instance.mix_m2_field              = data["TERRENO_M2"].to_f
              end

              instance_mixes << mix_instance
            end
            store_project(geom, data, instance_mixes, import_logger, project_type)
            mixes.clear
            instance_mixes.clear
            total_units = 0
            stock_units = 0
            sold_units = 0
          end
        end
      end

      def store_project(geom, data, mixes, import_logger, project_type)
        project = Project.find_or_initialize_by(code: data["COD_PROY"])

        is_new_record = project.new_record?
        project.save_project_data(data, project_type, geom)
        if project.errors.any?
          import_logger.failed += 1
          project.errors.full_messages.each do |error_message|
            import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
          end
          return false
        end

        instance = ProjectInstance.find_or_initialize_by(project_id: project.id, year: data['YEAR'], bimester: data['BIMESTRE'])
        instance.save_instance_data(data, mixes, project_type)

        if instance.errors.any?
          import_logger.failed += 1
          instance.errors.full_messages.each do |error_message|
            import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
          end
          return false
        end
        is_new_record ? import_logger.inserted += 1 : import_logger.updated += 1
        #processed_rows = instance.project_instance_mixes.count

        #is_new_record ? import_logger.inserted += processed_rows : import_logger.updated += processed_rows
      end

      def parse_future_projects(shp_file, import_logger)
        RGeo::Shapefile::Reader.open(shp_file) do |shp|
          field = []
          shp.each do |shape|
            if shape.index == 0
              shape.keys.each do |f|
                field.push(f)
              end
            end

            verify_attributes(field, "Future Projects")

            import_logger.current_row_index = shape.index
            import_logger.processed += 1

            if shape.geometry.nil?
              import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_POINT) }
              next
            end

            geom = shape.geometry
            data = shape.attributes

            bimester = data["BIM"]
            year = data["YEAR"]

            future_type = FutureProjectType.find_by(abbrev: data["FUENTE"])

            fut_proj = FutureProject.find_or_initialize_by(
              address: data["DIRECCION"],
              future_project_type_id: future_type.id,
              year: year,
              bimester: bimester,
              file_number: data["N_PE"].to_i.to_s,
              file_date: data["F_PE"]
            )

            fut_proj.new_record? ? was_new = true : was_new = false

            if fut_proj.save_future_project_data(geom, data, year, bimester, future_type)
              if was_new
                import_logger.inserted += 1
              else
                import_logger.updated += 1
                import_logger.details << { row_index: import_logger.current_row_index, message: 'Registro duplicado' }
              end
            else
              import_logger.failed += 1
              fut_proj.errors.full_messages.each do |error_message|
                import_logger.details << { row_index: import_logger.current_row_index, message: error_message }
              end
            end

          end
        end
      end

      def parse_lots(shp_file, import_logger)
        st1 = JSON.parse(File.read(shp_file))
        json_data = RGeo::GeoJSON.decode(st1, :json_parser => :json)
        json_data.each_with_index do |a, index|
          import_logger.current_row_index =index

          if a.geometry.nil?
            import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
            next
          end
          unless a.geometry.geometry_type.to_s == 'MultiPolygon' || a.geometry.geometry_type.to_s == 'Polygon'
            import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
            next
          end

          unless a.geometry.valid?
            import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
            next
          end
          geom = a.geometry.as_text
          da = a.properties
          data = {}
          da.each do |a| data[a[0].downcase] = a[1] end
          puts data['lot_id']
          county = County.find_by_code(data['county_id'].to_s)
          if county.nil?
            import_logger.details << { :row_index => import_logger.current_row_index, :message => "No encuentro la comuna con codigo #{data['county_id'].to_s}" }
            next
          end

          lot = Lot.find_or_initialize_by(county_id: county.id, identifier: data['lot_id'].to_s)
          lot.surface = data["surface"]
          lot.the_geom = geom

          if lot.save
            import_logger.inserted += 1
          else
            import_logger.failed += 1
            lot.errors.full_messages.each do |error_message|
              import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
            end
          end
        end
      end

      def parse_pois(shp_file, import_logger)
        RGeo::Shapefile::Reader.open(shp_file) do |shp|
          shp.each do |shape|
            if shape.geometry.nil?
              import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_POINT) }
              next
            end

            geom    = shape.geometry
            data    = shape.attributes
            sub_cat = PoiSubcategory.find_or_create_by(name: data["TIPO_POIS"])

            if Poi.create(name: data["NOMBRE"], poi_subcategory_id: sub_cat.id, the_geom: geom)
              import_logger.inserted += 1
            else
              import_logger.failed += 1
            end
          end
        end
      end

      def parse_counties(shp_file, import_logger)
        ShpFile.open(shp_file) do |shp|
          shp.each_with_index do |shape, i|

            import_logger.current_row_index = i + 1
            import_logger.processed += 1

            if shape.geometry.nil?
              import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
              next
            end

            unless shape.geometry.is_a? MultiPolygon
              import_logger.details << { :row_index => import_logger.current_row_index, :message => I18n.translate(:ERROR_GEOMETRY_MULTIPOLYGON) }
              next
            end

            geom = shape.geometry
            data = shape.data

            county = County.find_or_initialize_by_code(data["cod_com"].to_s)
            county.new_record? ? import_logger.inserted +=1 : import_logger.updated += 1
            county.the_geom = geom
            county.save

            if county.errors.any?
              county.errors.full_messages.each do |error_message|
                import_logger.details << { :row_index => import_logger.current_row_index, :message => error_message }
              end
            end
          end
        end
      end


      def verify_attributes(field, load_type)
        attributes = Array.new

        case load_type
        when "Building Regulation"
          attributes << [ "URL", "C" ]
          attributes << [ "Zona", "C" ]
          attributes << [ "Usos", "C" ]
          attributes << [ "Nota", "C" ]
          attributes << [ "IC", "C" ]
          attributes << [ "OS", "C" ]
          attributes << [ "Habha", "N" ]
          attributes << [ "AltMax", "N" ]
          attributes << [ "Agrupamien", "C" ]
          attributes << [ "Estacionam", "C" ]
          attributes << [ "AM_CC", "C" ]
          attributes << [ "FuenteFech", "N" ]
          attributes << [ "COD_COM", "C" ]
          attributes << [ "id", "C" ]
        when "Transactions"
          attributes << [ "PROPERTY_T", "C" ]
          attributes << [ "SELLER_TYP", "C" ]
          attributes << [ "INSCRIPTIO", "D" ]
          attributes << [ "ADDRESS", "C" ]
          attributes << [ "SHEET", "N" ]
          attributes << [ "NUMBER", "N" ]
          attributes << [ "BUYER_NAME", "C" ]
          attributes << [ "DEPARTMENT", "C" ]
          attributes << [ "BLUEPRINT", "C" ]
          attributes << [ "REAL_VALUE", "N" ]
          attributes << [ "CALCULATED", "N" ]
          attributes << [ "SAMPLE_FAC", "N" ]
          attributes << [ "CODCOM", "N" ]
          attributes << [ "BOD", "N" ]
          attributes << [ "EST", "N" ]
          attributes << [ "ROL", "C" ]
          attributes << [ "SELLER_NAM", "C" ]
          attributes << [ "BUYER_RUT", "C" ]
        when "Departamentos"
          attributes << [ "COMUNA", "N" ]
          attributes << [ "INMOBILIAR", "C" ]
          attributes << [ "ESTADO", "C" ]
          attributes << [ "COD_PROY", "C" ]
          attributes << [ "DIRECCION", "C" ]
          attributes << [ "NOMBRE", "C" ]
          attributes << [ "N_PISOS", "N" ]
          attributes << [ "OFERTA_T", "N" ]
          attributes << [ "STOCK", "N" ]
          attributes << [ "INI_CONST", "C" ]
          attributes << [ "INI_VTAS", "C" ]
          attributes << [ "ENTREGA", "C" ]
          attributes << [ "ESTRENO_P", "C" ]
          attributes << [ "YEAR", "N" ]
          attributes << [ "BIMESTRE", "N" ]
          attributes << [ "DORMS_T", "N"]
          attributes << [ "BANOS_T", "N"]
        when "Casas"
          attributes << [ "COMUNA", "N" ]
          attributes << [ "INMOBILIAR", "C" ]
          attributes << [ "ESTADO", "C" ]
          attributes << [ "COD_PROY", "C" ]
          attributes << [ "DIRECCION", "C" ]
          attributes << [ "NOMBRE", "C" ]
          attributes << [ "TIPO_C", "C" ]
          attributes << [ "N_PISOS", "N" ]
          attributes << [ "OFERTA_T", "N" ]
          attributes << [ "STOCK", "N" ]
          attributes << [ "INI_CONST", "C" ]
          attributes << [ "INI_VTAS", "C" ]
          attributes << [ "ENTREGA", "C" ]
          attributes << [ "ESTRENO_P", "C" ]
          attributes << [ "YEAR", "N" ]
          attributes << [ "BIMESTRE", "C" ]
          attributes << [ "DORMS_T", "N"]
          attributes << [ "BANOS_T", "N"]
        when "Future Projects"
          attributes << [ "DIRECCION", "C" ]
          attributes << [ "COD_COM", "N" ]
          attributes << [ "N_ROL", "C" ]
          attributes << [ "N_PE", "N" ]
          attributes << [ "F_PE", "D" ]
          attributes << [ "NOMBRE", "C" ]
          attributes << [ "TIPO", "C" ]
          attributes << [ "PROP", "C" ]
          attributes << [ "REP_LEGAL", "C" ]
          attributes << [ "ARQUITECTO", "C" ]
          attributes << [ "N_PISOS", "N" ]
          attributes << [ "SUBT", "N" ]
          attributes << [ "T_UNID", "N" ]
          attributes << [ "T_EST", "N" ]
          attributes << [ "T_LOC", "N" ]
          attributes << [ "M2_APROB", "N" ]
          attributes << [ "M2_EDIF", "N" ]
          attributes << [ "M2_TERR", "N" ]
          attributes << [ "F_CATASTRO", "D" ]
          attributes << [ "BIM", "C" ]
          attributes << [ "YEAR", "N" ]
          attributes << [ "OBSERVACIO", "C" ]
        when "LOTS"
          attributes << [ "ID_COMUNA", "N" ]
          attributes << [ "SUP_M", "N" ]
        end

        attributes.each do |attr|
          finded = false
          value = field.include? attr[0]
          if value
            finded = true
          end
          raise I18n.translate(:ERROR_STRUCTURE_FILE) + " " + attr[0] unless finded
        end
      end

    end
end
