class BuildingRegulationsController < ApplicationController
  before_action :set_building_regulation, only: [:show, :edit, :update, :destroy]

  def building_regulation_download
    county_file = params[:county_id]
    zip_file = "#{Rails.root}/db/data/pdf/#{county_file}.zip"
    if Dir.entries("#{Rails.root}/db/data/pdf/").detect {|f| f.match county_file}.nil? or county_file == ''
      send_file("#{Rails.root}/db/data/pdf/normativa_inexistente.zip", :type => 'application/zip',
                :disposition => 'inline', :filename => "normativa_inexistente.zip", :layout => false)
    else
      send_file(zip_file, :type => 'application/zip', :disposition => 'inline', :filename => county_file, :layout => false)
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
    
    params[:user_id] = current_user.id
    BuildingRegulation.save_filter_polygon params

    @a = allowed_use_list
    result.push({"label":"Uso", "data":@a})
    @c = constructivity
    result.push({"label":"Constructibilidad", "min": @c[:min], "max": @c[:max]})
    @l = land_ocupation
    result.push({"label":"Ocupación de Suelo", "min": @l[:min], "max": @l[:max]})
    @mh = maximum_height
    result.push({"label":"Altura Máxima", "min": @mh[:min], "max": @mh[:max]})

    @hh = hectarea_inhabitants
    result.push({"label":"Habitantes por Hectárea", "min": @hh[:min], "max": @hh[:max]})
    render json: result
  end

  def constructivity
    @construct = BuildingRegulation.group_by_constructivity(params)
  end

  def land_ocupation
    @land_ocupation = BuildingRegulation.group_by_land_ocupation(params)
  end

  def maximum_height
      @maximum_height = BuildingRegulation.group_by_maximum_height(params)
  end
  def hectarea_inhabitants
      @hectarea_inhabitants = BuildingRegulation.group_by_hectarea_inhabitants(params)
  end
  def constructivity_limits
    @list = BuildingRegulation.get_construct_limits
  end

  def land_ocupation_limits
    @list = BuildingRegulation.get_land_ocupation_limits
  end

  def allowed_use_list
    @list = LandUseType.get_allowed_use_list(params[:county_id], params[:wkt], params[:centerpt], params[:radius])
    @list
  end

  def dashboards
    respond_to do |f|
      f.js
    end
  end

  # GET /building_regulations
  # GET /building_regulations.json

  # GET /building_regulations/1
  # GET /building_regulations/1.json
  def show
  end

  # GET /building_regulations/new
  def new
    @building_regulation = BuildingRegulation.new
  end

  # GET /building_regulations/1/edit
  def edit
  end

  # POST /building_regulations
  # POST /building_regulations.json
  def create
    @building_regulation = BuildingRegulation.new(building_regulation_params)

    respond_to do |format|
      if @building_regulation.save
        format.html { redirect_to @building_regulation, notice: 'Building regulation was successfully created.' }
        format.json { render :show, status: :created, location: @building_regulation }
      else
        format.html { render :new }
        format.json { render json: @building_regulation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /building_regulations/1
  # PATCH/PUT /building_regulations/1.json
  def update
    respond_to do |format|
      if @building_regulation.update(building_regulation_params)
        format.html { redirect_to @building_regulation, notice: 'Building regulation was successfully updated.' }
        format.json { render :show, status: :ok, location: @building_regulation }
      else
        format.html { render :edit }
        format.json { render json: @building_regulation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /building_regulations/1
  # DELETE /building_regulations/1.json
  def destroy
    @building_regulation.destroy
    respond_to do |format|
      format.html { redirect_to building_regulations_url, notice: 'Building regulation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_building_regulation
    @building_regulation = BuildingRegulation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def building_regulation_params
    params.require(:building_regulation).permit(:building_zone, :construct, :land_ocupation, :site, :the_geom, :identifier, :density_type_id, :county_id, :comments, :hectarea_inhabitants, :grouping, :parkings, :am_cc, :aminciti, :icinciti, :osinciti)
  end
end
