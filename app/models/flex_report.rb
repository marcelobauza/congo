class FlexReport < ApplicationRecord
  include FlexReports::Validations

  belongs_to :user
end
