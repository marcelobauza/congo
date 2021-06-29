class Tenement < ApplicationRecord
  belongs_to :property_type
  belongs_to :county
end
