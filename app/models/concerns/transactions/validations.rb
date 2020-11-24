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
      :sample_factor,
      :calculated_value,
      :year,
      :bimester,
      :role,
      :user_id,
      :surveyor_id,
      presence: true

    validate :is_rut_valid
    validates :sample_factor,
      numericality: {
        greater_than: 0,
        less_than_or_equal_to: 1
      }

    validate :point_is_located_within_the_specified_county,
      :unless => Proc.new { |t|
        t.county.blank? or t.longitude.blank? or t.latitude.blank?
      }

    validates :parkingi,
      numericality: {
        greater_than_or_equal_to: 0,
        only_integer: true
      }, unless: -> { :parkingi.blank? }

    validates :cellar,
      numericality: {
        greater_than_or_equal_to: 0,
        only_integer: true
      }, unless: -> { :cellar.blank? }

    validates :number,
      numericality: {
        only_integer: true
      }, unless: -> { :number.blank? }

    validates :sheet,
      numericality: {
        only_integer: true
      }, unless: -> { :sheet.blank? }

    validates :bimester,
      numericality: {
        greater_than_or_equal_to: 1,
        less_than_or_equal_to: 6,
        only_integer: true
      }, unless: -> { :bimester.blank? }

      validates :real_value,
        numericality: {
          greater_than_or_equal_to: 0
        }, unless: -> { :real_value.blank? }
  end

  private

  def is_rut_valid
    Util.is_rut_valid?(self, :buyer_rut, true)
  end

  def build_geom
    self.the_geom = "POINT(#{self.longitude.to_f} #{self.latitude.to_f})" if self.latitude and self.longitude
  end

  def point_is_located_within_the_specified_county
    point_county = County.find_by_lon_lat(self.longitude, self.latitude)

    if point_county.nil?
      errors.add(
        :county_id,
        :not_within_county,
        :point_county => I18n.t(:none),
        :selected_county => self.county.name)
    else
      errors.add(
        :county_id,
        :not_within_county,
        :point_county => point_county.name,
        :selected_county => self.county.name) unless point_county.id == self.county_id
    end
  end

  def valid_date?
    errors.add(:inscription_date, :inscription_date_less_than_today) if self.inscription_date > Date.today
  end
end
