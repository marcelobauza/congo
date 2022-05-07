class Agency < ApplicationRecord
  include Agencies::Validations

  has_many :agency_rols, dependent: :restrict_with_error

   ROL = {
     agency:     'INMOBILIARIA',
     contructor: 'CONSTRUYE',
     seller:     'VENDE'
   }

  def to_s
    name.to_s
  end
end
