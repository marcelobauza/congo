class RentProject < ApplicationRecord
  belongs_to :county
  belongs_to :project_type
end
