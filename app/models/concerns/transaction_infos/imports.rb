module Transactions::Imports
  extend ActiveSupport::Concern

  included do
    before_save :update_calculated_value, :titleize_attributes
    before_save :pm2
  end

  def save_transaction_data(geom, data, county_id, user_id)
    ic = Iconv.new('UTF-8', 'ISO-8859-1')

    property_type, calc_uf      = PropertyType.get_property_type_transaction(data["PROPERTY_T"])
    seller                      = SellerType.get_seller_type(data["SELLER_TYP"])
    self.property_type_id       = property_type.id
    self.address                = ic.iconv(data["ADDRESS"].gsub("'","''"))
    self.sheet                  = data["SHEET"].to_i
    self.number                 = data["NUMBER"].to_i
    self.inscription_date       = ic.iconv(data["INSCRIPTIO"].to_s).to_date
    self.buyer_name             = ic.iconv(data["BUYER_NAME"].to_s)
    self.seller_type_id         = seller.id
    self.department             = ic.iconv(data["DEPARTMENT"].to_s)
    self.blueprint              = ic.iconv(data["BLUEPRINT"].to_s)
    self.real_value             = data["REAL_VALUE"].to_f
    self.calculated_value       = data["CALCULATED"].to_f
    self.year                   = data["YEAR"]
    self.sample_factor          = data["SAMPLE_FAC"]
    self.county_id              = county_id
    self.the_geom               = geom
    self.cellar                 = data["BOD"].to_i
    self.parkingi               = data["EST"].to_i
    self.role                   = ic.iconv(data["ROL"].to_s)
    self.seller_name            = ic.iconv(data["SELLER_NAM"].to_s)
    self.buyer_rut              = ic.iconv(data["BUYER_RUT"].to_s)
    self.uf_m2                  = (self.calculated_value / self.surface) unless self.surface == 0 or self.surface.nil?
    self.tome                   = data["TOMO"].to_i unless data["TOMO"] == -1
    self.lot                    = data["LOT"]
    self.block                  = ic.iconv(data["MANZANA"].to_s)
    self.village                = ic.iconv(data["VILLA"].to_s)
    self.surface                = data["SUPERFICIE"] unless data["SUPERFICIE"] == -1
    self.requiring_entity       = data["REQUIRING"]
    self.comments               = ic.iconv(data["COMMENTS"].to_s)
    self.user_id                = user_id
    self.surveyor_id            = Surveyor.find_by(name: data["ENCUESTADO"].to_s.downcase.titleize).id if !data["ENCUESTADO"].nil?
    self.bimester               = data["BIMESTER"]
    self.code_sii               = data["CODE_SII"]
    self.role_1                 = data["ROL2"]
    self.role_2                 = data["ROL3"]
    self.additional_roles       = data["ROLES_ADIC"]
    self.type_registration      = data["TIPOREG"]

    conditions = "rol_number = '#{self.role}'  #{Util.and} "
    conditions += "county_sii_id = #{data['CODE_SII']}"
    self.total_surface_terrain = TaxLand.where(conditions).sum('land_m2')
    self.total_surface_building = TaxUsefulSurface.where(conditions).sum('m2_built')
    self.uf_m2_u = self.calculated_value / self.total_surface_building unless self.total_surface_building == 0 or self.total_surface_building.nil?
    self.uf_m2_t = self.calculated_value / self.total_surface_terrain unless self.total_surface_terrain == 0 or self.total_surface_terrain.nil?

    if self.save
      return true
    end
    return false
  end

  def pm2
    conditions = "rol_number = '#{self.role}'  #{Util.and} "
    conditions += "county_sii_id = #{self.code_sii}"
    self.total_surface_terrain = TaxLand.where(conditions).sum('land_m2')
    self.total_surface_building = TaxUsefulSurface.where(conditions).sum('m2_built')
    self.uf_m2_u = self.calculated_value / self.total_surface_building unless self.total_surface_building == 0 or self.total_surface_building.nil?
    self.uf_m2_t = self.calculated_value / self.total_surface_terrain unless self.total_surface_terrain == 0 or self.total_surface_terrain.nil?
  end
end
