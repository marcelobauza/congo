module CsvParser
  extend ActiveSupport::Concern
  CBR_HEADER = ["N°","FECHA","TOMO","FOJA","NUMERO","RUT_COMP","COMPRADOR","VENDEDOR","VENDE","CALLE","NUMERO","COMUNA","LOTE","MANZANA",
                "VILLA","CASA","DPTO","ESTAC","CANT_EST","BODEGA","CANT_BOD","OFICINA","LOCAL","USO","SUPERFICIE","PLANO","PESOS","UF","ROL","ROL2", "ROL3","REQUIRIENTE",
                "OBSERVACIONES","LEVANTADO","DIGITADO", "LON", "LAT"]

  CBR_HEADER_SII = ["N°","FECHA","TOMO","FOJA","NUMERO","RUT_COMP","COMPRADOR","VENDEDOR","VENDE","CALLE","NUMERO","COMUNA","LOTE","MANZANA",
                    "VILLA","CASA","DPTO","ESTAC","CANT_EST","BODEGA","CANT_BOD","OFICINA","LOCAL","USO","SUPERFICIE","PLANO","PESOS","UF","ROL","ROL2", "ROL3","REQUIRIENTE",  "OBSERVACIONES","LEVANTADO","DIGITADO", "LON", "LAT", "TOTAL_SUP_CONSTRUIDO", "TOTAL_SUP_TERRENO", "UF_M2_U", "UF_M2_T","CODIGO_DEST", "CODIGO_MAT.", "ANO_SII"]

  FUTURE_PROJECT = ["CODE", "ADDRESS","NAME", "ROLE_NUMBER", "FILE_NUMBER", "FILE_DATE", "OWNER", "LEGAL_AGENT", "ARCHITECH", "FLOORS", "UNDERGROUNDS", "TOTAL_UNITS", "TOTAL_PARKING", "TOTAL_COMMERCIALS", "M2_APPROVED", "M2_BUILT", "M2_FIELD", "CADASTRAL_DATE", "COMMENTS", "BIMESTER", "YEAR", "CADASTRE", "PROJECT_TYPE_ID", "FUTURE_PROJECT_TYPE_ID", "COUNTY"]
  
  def self.get_transactions_csv_data(transactions)
    tempFile = Tempfile.new('transactions.csv')

    CSV.open(tempFile.path, "w") do |writer|
      writer << CBR_HEADER

      transactions.each do |t|
        values = [t.id, t.inscription_date.to_date.strftime("%d/%m/%Y"), t.tome, t.sheet, t.number, t.buyer_rut, t.buyer_name, t.seller_name, 
                  t.seller_type.get_my_initials, t.address.gsub(t.address.scan(/\d+ /).first.to_s, ""), t.address.scan(/\d+ /).first.to_s, t.county.name, 
                  t.lot, t.block, t.village,t.department.scan(/\bC\d+/).join("-"), t.department.scan(/D\d+/).join("-"), 
                  t.department.scan(/E\d+/).join("-"), t.parkingi,t.department.scan(/B\d+/).join("-"), t.cellar, t.department.scan(/O\d+/).join("-"),
                  t.department.scan(/LC\d+/).join("-"),t.property_type.get_my_initials, t.surface, t.blueprint, t.real_value, t.calculated_value, t.role, t.role_1, t.role_2,
                  t.requiring_entity,t.comments, t.surveyor_id.nil? ? "" : t.surveyor.nil? ? "": t.surveyor.name, t.user.nil? ? "" : t.user.complete_name, t.the_geom.x,
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
                  t.department.scan(/LC\d+/).join("-"),t.property_type.get_my_initials, t.surface, t.blueprint, t.real_value, t.calculated_value, t.role, t.role_1, t.role_2,
                  t.requiring_entity,t.comments, t.surveyor_id.nil? ? "" : t.surveyor.nil? ? "": t.surveyor.name, t.user.nil? ? "" : t.user.complete_name, t.the_geom.x,
                  t.the_geom.y, t.total_surface_building, t.total_surface_terrain, t.uf_m2_u, t.uf_m2_t,t.code_destination, t.code_material, t.year_sii]

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
        values = [t.code, t.address, t.name, t.role_number, t.file_number, t.file_date, t.owner, t.legal_agent, t.architect, t.floors, t.undergrounds, t.total_units, t.total_parking, t.total_commercials, t.m2_approved, t.m2_built, t.m2_field, t.cadastral_date, t.comments, t.bimester, t.year, t.cadastre, t.project_type.name, t.future_project_type.name, t.county_name]

        writer << values
      end
    end

    return tempFile.path
  end
  
end
