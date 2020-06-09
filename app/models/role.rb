class Role < ApplicationRecord
  include Roles::Scopes

  has_many :users
end
