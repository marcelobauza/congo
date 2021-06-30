class Flex::DashboardsController < ApplicationController

  layout 'flex'

  def index
  end

  def new
    @tenement = Tenement.new
  end

  def create
    @tenement = Tenement.new(tenement_params)

    respond_to do |format|
      @tenement.save
      format.js

    end
  end

  def tenement_params
    params.require(:tenement).permit(:property_type_id, :address, :uf, :county_id, :cellar, :parking, :building_surface, :terrain_surface)
  end
end
