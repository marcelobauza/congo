class Tenement < ApplicationRecord
  belongs_to :property_type
  belongs_to :county
  belongs_to :flex_report
end
