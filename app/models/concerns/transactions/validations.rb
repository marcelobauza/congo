module Transactions::Validations
  extend ActiveSupport::Concern

  included do

    before_validation :build_geom

    validates :address,
      :county_id,
      :property_type_id,
      :inscription_date,
      :sheet,
      :number,
      :longitude,
      :latitude,
      :seller_type_id,
      :tome,
      :code_sii,
      :the_geom,
      presence: true
    validates :sample_factor,
      numericality: {
        greater_than: 0,
        less_than_or_equal_to: 1
      },
      presence: true
  validate :is_rut_valid
    # validates_format_of :role, :with => /^(|\d{1,5}-(\d{1,5}))$/, :message => I18n.translate("activerecord.errors.models.transaction.invalid_role_format")
    # validate :is_buyer_rut_verification_digit_valid, :unless => 'self.buyer_rut.blank?'
    # validate :valid_date?

  end

  private

  def is_rut_valid
    Util.is_rut_valid?(self, :buyer_rut, true)
  end

  def build_geom
    self.the_geom = "POINT(#{self.longitude.to_f} #{self.latitude.to_f})" if self.latitude and self.longitude
  end
end
