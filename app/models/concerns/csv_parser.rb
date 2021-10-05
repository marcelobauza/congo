module CsvParser
  extend ActiveSupport::Concern
  CBR_HEADER = ["N°","FECHA","TOMO","FOJA","NUMERO","RUT_COMP","COMPRADOR","VENDEDOR","VENDE","CALLE","NUMERO","COMUNA","LOTE","MANZANA",
                "VILLA","CASA","DPTO","ESTAC","CANT_EST","BODEGA","CANT_BOD","OFICINA","LOCAL","USO","SUPERFICIE","PLANO","PESOS","UF","ROL","ROL2", "ROL3","ROLES ADICIONALES" ,"REQUIRIENTE",
                "OBSERVACIONES","LEVANTADO","DIGITADO", "LON", "LAT"]

  CBR_HEADER_SII = ["N°","FECHA","TOMO","FOJA","NUMERO","RUT_COMP","COMPRADOR","VENDEDOR","VENDE","CALLE","NUMERO","COMUNA","LOTE","MANZANA",
                    "VILLA","CASA","DPTO","ESTAC","CANT_EST","BODEGA","CANT_BOD","OFICINA","LOCAL","USO","SUPERFICIE","PLANO","PESOS","UF","ROL","ROL2", "ROL3","ROLES ADICIONALES" ,"REQUIRIENTE",  "OBSERVACIONES","LEVANTADO","DIGITADO", "LON", "LAT", "TOTAL_SUP_CONSTRUIDO", "TOTAL_SUP_TERRENO", "UF_M2_U", "UF_M2_T","CODIGO_DEST", "CODIGO_MAT.", "ANO_SII", "AVALUO"]

  FUTURE_PROJECT = ["CODE", "ADDRESS","NAME", "ROLE_NUMBER", "FILE_NUMBER", "FILE_DATE", "OWNER", "LEGAL_AGENT", "ARCHITECH", "FLOORS", "UNDERGROUNDS", "TOTAL_UNITS", "TOTAL_PARKING", "TOTAL_COMMERCIALS", "M2_APPROVED", "M2_BUILT", "M2_FIELD", "CADASTRAL_DATE", "COMMENTS", "BIMESTER", "YEAR", "CADASTRE", "PROJECT_TYPE_ID", "FUTURE_PROJECT_TYPE_ID", "COUNTY", "X", "Y", "ID", "T_OFI"]
  PROJECT_HEADER = ["CODE","NAME", "ADDRESS", "FLOORS", "COUNTY", "PROJECT_TYPE", "BUILD_DATE", "SALE_DATE", "TRANSFER_DATE", "PILOT_DATE", "PROJECT_STATUS", "QUANTITY_DEPARTMENT", "ELEVATORS", "OBSERVATIONS", "PROJECT_STATUS_ID", "BIMESTER", "YEAR", "CADASTRE",  "STOCK_UNITS", "MIX_USABLE_M2", "MIX_TERRACE_M2", "LIVING", "SERVICE", "OFFICE", "UF_MIN", "UF_MAX", "UF_PARKING", "UF_CELLAR", "COMMON_EXPENSES", "TOTAL_UNITS", "T_MIN", "T_MAX", "HOME_TYPE", "MODEL", "LON", "LAT", "BAÑOS", "DORMITORIOS"]

POLYGON_HEADER = ["ID", "USUARIO", "FECHA", "CAPA", "WKT", "EMPRESA"]

DOWNLOADS_USERS_HEADER = ["USUARIO", "FECHA", "COMPRAVENTAS", "EXPEDIENTES", "PROYECTOS"]

PROJECTS_FOR_AREA = ["Nombre", "Código", "Comuna_id", "Area"]

def self.get_projects_area_data_csv(projects)
  tempFile = Tempfile.new('proyectos_por_area.csv')

  CSV.open(tempFile.path, "w") do |writer|
    writer << PROJECTS_FOR_AREA

    projects.each do |project|
      values = [
        project.name,
        project.code,
        project.county_id,
        project.area_name
      ]

      writer << values
    end
  end

  tempFile.path
end


def self.get_downloads_users_csv_data du
  tempFile = Tempfile.new('transactions.csv')

  CSV.open(tempFile.path, "w") do |writer|
    writer << DOWNLOADS_USERS_HEADER

    du.each do |d|
      values = [
        d.user.name,
        d.created_at,
        d.transactions,
        d.future_projects,
        d.projects
      ]

      writer << values
    end
  end

  return tempFile.path
end

  def self.get_transactions_csv_data(transactions)
    tempFile = Tempfile.new('transactions.csv')

    CSV.open(tempFile.path, "w") do |writer|
      writer << CBR_HEADER

      transactions.each do |t|
        values = [t.id, t.inscription_date.to_date.strftime("%d/%m/%Y"), t.tome, t.sheet, t.number, t.buyer_rut, t.buyer_name, t.seller_name,
                  t.seller_type.get_my_initials, t.address.gsub(t.address.scan(/\d+ /).first.to_s, ""), t.address.scan(/\d+ /).first.to_s, t.county.name,
                  t.lot, t.block, t.village,t.department.scan(/\bC\d+/).join("-"), t.department.scan(/D\d+/).join("-"),
                  t.department.scan(/E\d+/).join("-"), t.parkingi,t.department.scan(/B\d+/).join("-"), t.cellar, t.department.scan(/O\d+/).join("-"),
                  t.department.scan(/LC\d+/).join("-"),t.property_type.get_my_initials, t.surface, t.blueprint, t.real_value, t.calculated_value, t.role, t.role_1, t.role_2,t.additional_roles,
                  t.requiring_entity,t.comments, t.surveyor_id.nil? ? "" : t.surveyor.name, t.surveyor.nil? ? "": t.surveyor.name, t.the_geom.x,
                  t.the_geom.y]

        writer << values
      end
    end

    return tempFile.path
  end

  def self.get_transactions_csv_data_sii(transactions)
    tempFile = Tempfile.new('transactions.csv')

    CSV.open(tempFile.path, "w") do |writer|
      writer << CBR_HEADER_SII

      transactions.each do |t|
        values = [t.id, t.inscription_date.to_date.strftime("%d/%m/%Y"), t.tome, t.sheet, t.number, t.buyer_rut, t.buyer_name, t.seller_name,
                  t.seller_type.get_my_initials, t.address.gsub(t.address.scan(/\d+ /).first.to_s, ""), t.address.scan(/\d+ /).first.to_s, t.county.name,
                  t.lot, t.block, t.village,t.department.scan(/\bC\d+/).join("-"), t.department.scan(/D\d+/).join("-"),
                  t.department.scan(/E\d+/).join("-"), t.parkingi,t.department.scan(/B\d+/).join("-"), t.cellar, t.department.scan(/O\d+/).join("-"),
                  t.department.scan(/LC\d+/).join("-"),t.property_type.get_my_initials, t.surface, t.blueprint, t.real_value, t.calculated_value, t.role, t.role_1, t.role_2, t.additional_roles,
                  t.requiring_entity,t.comments, t.surveyor_id.nil? ? "" : t.surveyor.name, t.surveyor.nil? ? "": t.surveyor.name, t.the_geom.x,
                  t.the_geom.y, t.total_surface_building, t.total_surface_terrain, t.uf_m2_u, t.uf_m2_t,t.code_destination, t.code_material, t.year_sii, t.tax_appraisal]

        writer << values
      end
    end

    return tempFile.path
  end

  def self.get_future_projects_csv_data(future_projects)
    tempFile = Tempfile.new('future_projects.csv')

    CSV.open(tempFile.path, "w") do |writer|
      writer << FUTURE_PROJECT

      future_projects.each do |t|
        values = [t.code, t.address, t.name, t.role_number, t.file_number, t.file_date, t.owner, t.legal_agent, t.architect, t.floors, t.undergrounds, t.total_units, t.total_parking, t.total_commercials, t.m2_approved, t.m2_built, t.m2_field, t.cadastral_date, t.comments, t.bimester, t.year, t.cadastre, t.project_type.name, t.future_project_type.name, t.county_name, t.the_geom.x, t.the_geom.y, t.id, t.t_ofi]

        writer << values
      end
    end

    return tempFile.path
  end

  def self.get_projects_csv_data(projects)

    tempFile = Tempfile.new('projects.csv')
    CSV.open(tempFile.path, "w") do |writer|
      writer << PROJECT_HEADER
      projects.each do |t|
        values = [t.code, t.name, t.address, t.floors, t.countyname, t.project_type_name, t.build_date, t.sale_date, t.transfer_date, t.pilot_opening_date, t.project_status_name, t.quantity_department_for_floor , t.elevators, t.general_observation, t.project_status_id, t.bimester, t.year, t.cadastre, t.stock_units, t.mix_usable_square_meters, t.mix_terrace_square_meters, t.living_room, t.service_room, t.h_office, t.uf_min, t.uf_max, t.uf_parking, t.uf_cellar, t.common_expenses, t.total_units, t.t_min, t.t_max, t.home_type, t.model, t.the_geom.x, t.the_geom.y, t.bathroom, t.bedroom]
        writer << values
      end
    end
    return tempFile.path
  end


  def self.get_user_polygons_csv_data(polygon)
    tempFile = Tempfile.new('user_polygon.csv')

    CSV.open(tempFile.path, "w") do |writer|
      writer << POLYGON_HEADER

      polygon.each do |t|
        username = User.find_by_id(t.user_id)
        values = [t.id, username.name, t.created_at.to_date.strftime("%d/%m/%Y"), t.layertype, t.wkt, username.company]
        writer << values
      end
    end

    return tempFile.path
  end


end
