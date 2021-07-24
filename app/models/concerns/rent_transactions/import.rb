module RentTransactions::Import
  extend ActiveSupport::Concern

  included do
    before_save :update_calculated_value
  end

  def save_transaction_data(geom, data, county_id, user_id)
    ic = Iconv.new('UTF-8', 'ISO-8859-1')

    property_type, calc_uf = PropertyType.get_property_type_transaction(data["USO"])
    seller                 = SellerType.get_seller_type(data["VENDE"])

    self.property_type_id       = property_type.id
    self.address                = ic.iconv(data["DIRECCION"].gsub("'","''"))
    self.sheet                  = data["FOJA"].to_i
    self.number                 = data["NUMBER"].to_i
    self.inscription_date       = ic.iconv(data["INSCRIPTIO"].to_s).to_date
    self.buyer_name             = ic.iconv(data["COMPRADOR"].to_s)
    self.seller_type_id         = seller.id
    self.department             = ic.iconv(data["DEPARTMENT"].to_s)
    self.blueprint              = ic.iconv(data["PLANO"].to_s)
    self.calculated_value       = data["UF"].to_f
    self.year                   = data["YEAR"]
    self.county_id              = county_id
    self.the_geom               = geom
    self.cellar                 = data["CANT_BOD"].to_i
    self.parking               = data["CANT_EST"].to_i
    self.role                   = ic.iconv(data["ROL"].to_s)
    self.seller_name            = ic.iconv(data["VENDEDOR"].to_s)
    self.buyer_rut              = ic.iconv(data["RUT_COMP"].to_s)
    self.uf_m2                  = (self.calculated_value / self.surface) unless self.surface == 0 or self.surface.nil?
    self.tome                   = data["TOMO"].to_i unless data["TOMO"] == -1
    self.lot                    = data["LOTE"]
    self.block                  = ic.iconv(data["MANZANA"].to_s)
    self.village                = ic.iconv(data["VILLA"].to_s)
    self.bimester               = data["BIMESTER"]
    self.role_1                 = data["ROL2"]
    self.role_2                 = data["ROL3"]
    self.additional_roles       = data["ROLES_ADIC"]
    self.total_surface_terrain  = data["TOTAL_TER"]
    self.total_surface_building = data["TOTAL_CONS"]
    self.uf_m2_u                = data["UF_M2_U"]
    self.uf_m2_t                = data["UF_M2_T"]
    self.code_destination       = data["CODIGO_DES"]
    self.code_material          = data["CODIGO_MAT"]
    self.year_sii               = data["ANO_SII"]
 #   surface               = data["SUPERFICIE"] unless data["SUPERFICIE"]                                                     =  = -1
 #   requiring_entity      = data["REQUIRING"]
 #   comments              = ic.iconv(data["COMMENTS"].to_s)
#    real_value            = data["REAL_VALUE"].to_f
 #   sample_factor         = data["SAMPLE_FAC"]
 #   surveyor_id           = Surveyor.find_by(name: data["ENCUESTADO"].to_s.downcase.titleize).id if !data["ENCUESTADO"].nil?
 #   code_sii              = data["CODE_SII"]
  if self.save
      return true
    end
    return false
  end

  def pm2
    conditions = "rol_number = '#{role}'  #{Util.and} "
    conditions += "county_sii_id = #{code_sii}"
    total_surface_terrain = TaxLand.where(conditions).sum('land_m2')
    total_surface_building = TaxUsefulSurface.where(conditions).sum('m2_built')
    uf_m2_u = calculated_value / total_surface_building unless total_surface_building == 0 or total_surface_building.nil?
    uf_m2_t = calculated_value / total_surface_terrain unless total_surface_terrain == 0 or total_surface_terrain.nil?
  end

  def update_calculated_value
    value = CountyUf.find_by_county_id_and_property_type_id(self.county_id, self.property_type_id)

    if value.nil?
      errors.add(:calculated_value, :uf_county_not_exists)
      return false
    end

    unless (self.calculated_value >= value.uf_min and self.calculated_value <= value.uf_max)
      errors.add(:calculated_value, :not_valid_uf_value)
      return false
    end
  end
  def titleize_at_ributes
    buyer_name       = self.buyer_name.tmeitleize
    seller_name      = self.seller_name.titleize
    address          = self.address.titleize
    village          = self.village.to_s.titleize
    requiring_entity = self.requiring_entity.to_s.titleize
    comments         = self.comments.to_s.titleize
    block            = self.block.to_s.upcase
    department       = self.department.to_s.upcase
    blueprint        = self.blueprint.to_s.upcase
  end
end
