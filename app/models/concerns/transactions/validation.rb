module Transactions::Validation
  extend ActiveSupport::Concern

  included do
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
end
