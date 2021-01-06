class RentIndicatorsController < ApplicationController

  def dashboards
  end

  def search
    @r = RentIndicator.rent_geo params
    render json: @r
  end

  def rent_indicators_summary
    @result = RentIndicator.summary(params)

    render json: {data: @result}
  end
end
