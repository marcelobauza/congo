class CensusController < ApplicationController
  before_action :set_censu, only: [:show, :edit, :update, :destroy]


  def dashboards
    respond_to do |f|
      f.js
    end
  end




  # GET /census
  # GET /census.json
  def index
    @census = Censu.all
  end

  # GET /census/1
  # GET /census/1.json
  def show
  end

  # GET /census/new
  def new
    @censu = Censu.new
  end

  # GET /census/1/edit
  def edit
  end

  # POST /census
  # POST /census.json
  def create
    @censu = Censu.new(censu_params)

    respond_to do |format|
      if @censu.save
        format.html { redirect_to @censu, notice: 'Censu was successfully created.' }
        format.json { render :show, status: :created, location: @censu }
      else
        format.html { render :new }
        format.json { render json: @censu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /census/1
  # PATCH/PUT /census/1.json
  def update
    respond_to do |format|
      if @censu.update(censu_params)
        format.html { redirect_to @censu, notice: 'Censu was successfully updated.' }
        format.json { render :show, status: :ok, location: @censu }
      else
        format.html { render :edit }
        format.json { render json: @censu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /census/1
  # DELETE /census/1.json
  def destroy
    @censu.destroy
    respond_to do |format|
      format.html { redirect_to census_url, notice: 'Censu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_censu
      @censu = Censu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def censu_params
      params.require(:censu).permit(:age_0_9, :age_10_19, :age_20_29, :age_30_39, :age_40_49, :age_50_59, :age_60_69, :age_70_79, :age_80_more, :home_1p, :home_2p, :home_3p, :home_4p, :home_5p, :owner, :leased, :transferred, :free, :possession, :male, :female, :married, :coexist, :single, :canceled, :separated, :widowed, :m_status_total, :not_attended, :basic, :high_school, :cft, :ip, :university, :education_level_total, :salaried, :domestic_service, :independient, :employee_employer, :unpaid_familiar, :labor_total, :abc1, :c2, :c3, :d, :e, :socio_economic_total, :homes_abc1, :homes_c2, :homes_c3, :homes_d, :homes_e, :predominant, :census_source_id, :county_id, :block, :the_geom, :homes_total, :population_total)
    end
end
