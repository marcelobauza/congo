module CsvParser
  extend ActiveSupport::Concern
  CBR_HEADER = ["N°","FECHA","TOMO","FOJA","NUMERO","RUT_COMP","COMPRADOR","VENDEDOR","VENDE","CALLE","NUMERO","COMUNA","LOTE","MANZANA",
                "VILLA","CASA","DPTO","ESTAC","CANT_EST","BODEGA","CANT_BOD","OFICINA","LOCAL","USO","SUPERFICIE","PLANO","PESOS","UF","ROL","ROL2", "ROL3","REQUIRIENTE",
                "OBSERVACIONES","LEVANTADO","DIGITADO", "LON", "LAT"]

  CBR_HEADER_SII = ["N°","FECHA","TOMO","FOJA","NUMERO","RUT_COMP","COMPRADOR","VENDEDOR","VENDE","CALLE","NUMERO","COMUNA","LOTE","MANZANA",
                    "VILLA","CASA","DPTO","ESTAC","CANT_EST","BODEGA","CANT_BOD","OFICINA","LOCAL","USO","SUPERFICIE","PLANO","PESOS","UF","ROL","ROL2", "ROL3","REQUIRIENTE",  "OBSERVACIONES","LEVANTADO","DIGITADO", "LON", "LAT", "TOTAL_SUP_CONSTRUIDO", "TOTAL_SUP_TERRENO", "UF_M2_U", "UF_M2_T","CODIGO_DEST", "CODIGO_MAT.", "ANO_SII"]

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
end
