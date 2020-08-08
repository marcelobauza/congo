class DashboardsController < ApplicationController
  def index
    allowed_layers = current_user.layer_types.reject(&:blank?)
    @initial_layer  = LayerType.where(id: allowed_layers).first
  end

  def graduated_points
  end

  def heatmap
  end

  def filter_county_for_lon_lat
    @county= County.find_by_lon_lat(params[:lon], params[:lat])
    render json: {county_id: @county.id, county_name: @county.name }
  end

  def filter_period
    @period = Period.get_period_current
    render json: {year: @period.year, bimester: @period.bimester}
  end
end
