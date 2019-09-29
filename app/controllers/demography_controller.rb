class DemographyController < ApplicationController
  def dashboards
    respond_to do |f|
      f.js
    end
  end

  def general
    @result = Censu.summary(params)
    render json: @result
  end
end
