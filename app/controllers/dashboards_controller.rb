class DashboardsController < ApplicationController
  def index
  end

  def graduated_points
  end

  
  def filter_county_for_lon_lat
    @county= County.find_by_lon_lat(params[:lon], params[:lat])
    render json: {county_id: @county.id }
  end

  def filter_period
    
    @period = Period.get_period_current
    render json: {year: @period.year, bimester: @period.bimester}

  end


end
