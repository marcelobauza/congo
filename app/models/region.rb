class Region < ApplicationRecord
  include Regions::Scopes

  has_many :regions_users
  has_many :users, through: :regions_users
  has_many :counties
end
