class Company < ApplicationRecord
  has_many :users

  include Companies::Validations

  def to_s
    name.to_s
  end
end
