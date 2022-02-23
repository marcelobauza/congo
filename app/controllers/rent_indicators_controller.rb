class RentIndicatorsController < ApplicationController

  def dashboards
  end

  def search
    session[:data] = params
    @r = RentIndicator.rent_geo params
    render json: @r
  end

  def rent_indicators_summary
    params[:user_id] = current_user.id
    @result = RentIndicator.summary(params)
  end
end
