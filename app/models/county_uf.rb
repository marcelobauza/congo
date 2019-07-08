class CountyUf < ApplicationRecord
  belongs_to :county
  belongs_to :property_type

  validates :uf_min, :uf_max, :county_id, :property_type_id, presence: true

  before_save :validate_uf_range
  scope :by_county, lambda { |pcounty| where(county_id: pcounty ) unless pcounty.nil? or pcounty == "" }
  scope :by_property_type, lambda { |pptype| where(property_type_id: pptype ) unless pptype.nil? or pptype == "" }
      



  def validate_uf_range
    if self.uf_min >= self.uf_max
      errors.add(:uf_min, :uf_min_less_than_max)
      return false
    end
  end


end
