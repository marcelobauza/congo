class CountiesController < ApplicationController
  before_action :set_county, only: [:show, :edit, :update, :destroy]

  def search_county_geojson
    if !params[:county_id].nil?
      county  = JSON.parse(params[:county_id]).flatten
      @county = County.where(
        id: county
      ).select(
        'st_asgeojson(the_geom) as geo'
      ).first
    end

    render json:  @county
  end

  def index
    respond_to do |format|
      format.js
    end
  end

  def find
    @id     = params[:search][:name]
    @county = County.where(id: @id)

    respond_to do |format|
      format.js
    end
  end

  def counties_users
    @counties = CountiesUser.where(user_id: current_user.id).pluck(:county_id)

    render json: @counties
  end

  def counties_enabled_by_users
    @counties = CountiesUser.enabled_by_user(params[:user_id])

    render json: @counties
  end
end
