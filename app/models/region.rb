class Region < ApplicationRecord
  has_many :regions_users
  has_many :users, through: :regions_users
end
