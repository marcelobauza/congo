class RegionsUser < ApplicationRecord
  belongs_to :user
  belongs_to :region
end
