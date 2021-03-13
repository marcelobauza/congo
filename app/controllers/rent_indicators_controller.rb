class RentIndicatorsController < ApplicationController

  def dashboards
  end

  def search
    @r = RentIndicator.rent_geo params
    render json: @r
  end

  def rent_indicators_summary
    session[:data] = params
    params[:user_id] = current_user.id
    @result = RentIndicator.summary(params)
  end
end
