class Admin::CountiesController < Admin::DashboardsController
  before_action :set_county, only: [:show, :edit, :update, :destroy]

  layout 'admin'

  def search
      if !params[:id].nil?
        @county = County.where(id: params[:id]).first
      end
      render json:  @county
  end

  def search_geojson

    #if !params[:county_id].nil?
      @county = County.where(
        id: 1
      ).select(
        'st_asgeojson(the_geom) as geo'
      ).first
    #end
    render json:  @county
  end

  # GET /counties
  # GET /counties.json
  def index
    @counties = County.all.order(:name)
  end

  # GET /counties/1
  # GET /counties/1.json
  def show
  end

  # GET /counties/new
  def new
    @county = County.new
  end

  # GET /counties/1/edit
  def edit
  end

  # POST /counties
  # POST /counties.json
  def create
    @county = County.new(county_params)

    respond_to do |format|
      if @county.save
        format.html { redirect_to counties_admin_path(), notice: 'County was successfully created.' }
        format.json { render :show, status: :created, location: @county }
      else
        format.html { render :new }
        format.json { render json: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /counties/1
  # PATCH/PUT /counties/1.json
  def update
    respond_to do |format|
      if @county.update(county_params)
        format.html { redirect_to admin_counties_path(), notice: 'County was successfully updated.' }
        format.json { render :show, status: :ok, location: @county }
      else
        format.html { render :edit }
        format.json { render json: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /counties/1
  # DELETE /counties/1.json
  def destroy
    @county.destroy
    respond_to do |format|
      format.html { redirect_to counties_url, notice: 'County was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_county
      @county = County.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def county_params
      params.require(:county).permit(:name, :code, :transaction_data, :demography_data, :legislation_data, :sales_project_data, :future_project_data, :commercial_project_data, :code_sii, :number_last_project_future, :enabled, :region_id)
    end
end
