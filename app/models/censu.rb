class Censu < ApplicationRecord
  belongs_to :census_source
  belongs_to :county
end
