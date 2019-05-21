class BuildingRegulation < ApplicationRecord
  belongs_to :density_type
  belongs_to :county
end
