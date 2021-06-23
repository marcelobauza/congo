module RentFutureProjects::Import
  extend ActiveSupport::Concern

  def save_future_project_data(geom, data, year, bimester, future_type)
    ic                          = Iconv.new('UTF-8', 'ISO-8859-1')
    p_type                      = ProjectType.get_project_type_by_first_letter(data["PROJECT_TY"])
    county                      = County.find_by_code(data["COUNTY_COD"].to_i.to_s)
    number_next_project         = county.number_last_project_future + 1
    self.code                   = county.code.to_s + "-EM-"+ number_next_project.to_s
    self.address                = ic.iconv(data["ADDRESS"].gsub("'","''")).to_s
    self.name                   = ic.iconv(data["NAME"]).to_s
    self.role_number            = ic.iconv(data["ROLE_NUMBE"]).to_s
    self.file_number            = data["FILE_NUMBE"].to_i.to_s
    self.file_date              = data["FILE_DATE"]
    self.owner                  = ic.iconv(data["OWNER"]).to_s
    self.legal_agent            = ic.iconv(data["LEGAL_AGEN"]).to_s
    self.architech              = ic.iconv(data["ARCHITECH"]).to_s
    self.floors                 = data["FLOORS"].to_i if data["FLOORS"]
    self.undergrounds           = data["UNDERGROUN"].to_i if data["UNDERGROUN"]
    self.total_units            = data["TOTAL_UNIT"].to_i if data["TOTAL_UNIT"]
    self.total_parking          = data["TOTAL_PARK"].to_i if data["TOTAL_PARK"]
    self.total_commercials      = data["TOTAL_COMM"].to_i if data["TOTAL_COMM"]
    self.m2_approved            = data["M2_APPROVE"] if data["M2_APPROVE"]
    self.m2_built               = data["M2_BUILT"]
    self.m2_field               = data["M2_FIELD"] if data["M2_FIELD"]
    self.t_ofi                  = data["T_OFI"] if data["T_OFI"]
    self.cadastral_date         = data["CADASTRAL"].to_date unless data["CADASTRAL"].nil?
    self.comments               = ic.iconv(data["COMMENTS"]).to_s
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
