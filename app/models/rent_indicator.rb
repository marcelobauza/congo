class RentIndicator < ApplicationRecord

  def self.reports_pdf filters
    result = {}
    charts = []
    result['charts'] = charts
    result
  end

end
