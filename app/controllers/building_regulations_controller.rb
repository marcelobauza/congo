class BuildingRegulationsController < ApplicationController
  before_action :set_building_regulation, only: [:show, :edit, :update, :destroy]

  def building_regulation_download
    county_file = params[:county_id]
    zip_file = "#{Rails.root}/db/data/pdf/#{county_file}.zip"
    if Dir.entries("#{Rails.root}/db/data/pdf/").detect {|f| f.match county_file}.nil? or county_file == ''
      send_file("#{Rails.root}/db/data/pdf/normativa_inexistente.zip", :type => 'application/zip',
                :disposition => 'inline', :filename => "normativa_inexistente.zip", :layout => false)
    else
      send_file(zip_file, :type => 'application/zip', :disposition => 'inline', :filename => "#{county_file}.zip", :layout => false)
    end
  end

  def index
    @data = BuildingRegulation.info_popup(params[:id])

    respond_to do |f|
      f.json
    end
  end

  def building_regulations_filters
    result = []

    session[:data] = params

    params[:user_id] = current_user.id
    BuildingRegulation.save_filter_polygon params

    a = allowed_use_list
    result.push({"label": "Uso", "data": a})
    c = constructivity
    result.push({"label": "Constructibilidad", "min": c[:min], "max": c[:max]})
    l = land_ocupation
    result.push({"label": "Ocupación de Suelo", "min": l[:min], "max": l[:max] })
    mh = maximum_height
    result.push({"label": "Altura Máxima", "min": mh[:min], "max": mh[:max]})

    hh = hectarea_inhabitants
    result.push({"label": "Habitantes por Hectárea", "min": hh[:min], "max": hh[:max]})
    render json: result
  end

  def constructivity
    BuildingRegulation.group_by_constructivity(params)
  end

  def land_ocupation
    BuildingRegulation.group_by_land_ocupation(params)
  end

  def maximum_height
    BuildingRegulation.group_by_maximum_height(params)
  end

  def hectarea_inhabitants
    BuildingRegulation.group_by_hectarea_inhabitants(params)
  end

  def constructivity_limits
    BuildingRegulation.get_construct_limits
  end

  def land_ocupation_limits
    BuildingRegulation.get_land_ocupation_limits
  end

  def allowed_use_list
    LandUseType.get_allowed_use_list(params[:county_id], params[:wkt], params[:centerpt], params[:radius])
  end

  def dashboards
    respond_to do |f|
      f.js
    end
  end
end
