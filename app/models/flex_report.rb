class FlexReport < ApplicationRecord
  include FlexReports::Validations

  belongs_to :user
  has_many :tenements
  accepts_nested_attributes_for :tenements
end
