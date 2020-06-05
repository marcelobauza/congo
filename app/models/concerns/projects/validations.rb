module Projects::Validations
  extend ActiveSupport::Concern

  included do
    validates :code, :name, :address, :floors, :county_id,
      :project_type_id, :the_geom, :latitude, :longitude,
      :build_date, :sale_date, :transfer_date, presence: true
    validate :point_is_located_within_the_specified_county, :unless => Proc.new { |t| t.county.blank? or t.longitude.blank? or t.latitude.blank? }
    validates_each :build_date, :sale_date, :transfer_date do |record, attr, value|
      if value.split('/').count != 3
        record.errors.add(attr, "La fecha no tiene el formato esperado. El formato debe ser 'dd/mm/aaaa'")
      else
        d, m, y = value.split('/')
        if !(1..31).include? d.to_i
          record.errors.add(attr, "El dia debe ser un valor entre 1 y 31 (dd/mm/aaaa)")
        end

        if !(1..12).include? m.to_i
          record.errors.add(attr, "El mes debe ser un valor entre 1 y 12 (dd/mm/aaaa)")
        end
      end
    end
  end

  private

    def point_is_located_within_the_specified_county
      point_county = County.find_by_lon_lat(self.longitude, self.latitude)
      if point_county.nil?
        errors.add(
          :county_id,
          :not_within_county,
          point_countyi: I18n.t(:none),
          selected_countyi: self.county.name
        )
      else
        errors.add(
          :county_id,
          :not_within_county,
          point_county: point_county.name,
          selected_county: self.county.name) unless point_county.id == self.county_id
      end
    end
end
