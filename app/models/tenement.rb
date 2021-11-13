class Tenement < ApplicationRecord
  belongs_to :property_type
  belongs_to :flex_report
end
