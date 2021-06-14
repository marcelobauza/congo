module RentFutureProjects::Import
  extend ActiveSupport::Concern

  def save_future_project_data(geom, data, year, bimester, future_type)
    ic                          = Iconv.new('UTF-8', 'ISO-8859-1')
    p_type                      = ProjectType.get_project_type_by_first_letter(data["TIPO"])
    county                      = County.find_by_code(data["COD_COM"].to_i.to_s)
    number_next_project         = county.number_last_project_future + 1
    self.code                   = county.code.to_s + "-EM-"+ number_next_project.to_s
    self.address                = ic.iconv(data["DIRECCION"].gsub("'","''")).to_s
    self.name                   = ic.iconv(data["NOMBRE"]).to_s
    self.role_number            = ic.iconv(data["N_ROL"]).to_s
    self.file_number            = data["N_PE"].to_i.to_s
    self.file_date              = data["F_PE"]
    self.owner                  = ic.iconv(data["PROP"]).to_s
    self.legal_agent            = ic.iconv(data["REP_LEGAL"]).to_s
    self.architech              = ic.iconv(data["ARQUITECTO"]).to_s
    self.floors                 = data["N_PISOS"].to_i if data["N_PISOS"]
    self.undergrounds           = data["SUBT"].to_i if data["SUBT"]
    self.total_units            = data["T_UNID"].to_i if data["T_UNID"]
    self.total_parking          = data["T_EST"].to_i if data["T_EST"]
    self.total_commercials      = data["T_LOC"].to_i if data["T_LOC"]
    self.m2_approved            = data["M2_APROB"] if data["M2_APROB"]
    self.m2_built               = data["M2_EDIF"]
    self.m2_field               = data["M2_TERR"] if data["M2_TERR"]
    self.t_ofi                  = data["T_OFI"] if data["T_OFI"]
    self.cadastral_date         = data["F_CATASTRO"].to_date unless data["F_CATASTRO"].nil?
    self.comments               = ic.iconv(data["OBSERVACIO"]).to_s
    self.year                   = year
    self.bimester               = bimester
    self.future_project_type_id = future_type.id
    self.project_type_id        = p_type.id
    self.county_id              = county.id unless county.nil?
    self.the_geom               = geom

    if self.save
      County.update(county.id, :future_project_data => true, :number_last_project_future => number_next_project) unless county.nil?
      return true
    end
    false
  end
end
