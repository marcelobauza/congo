class BuildingRegulationLandUseType < ApplicationRecord
  belongs_to :building_regulation
  belongs_to :land_use_type
end
