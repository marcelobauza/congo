class LandUseTypesController < ApplicationController
  before_action :set_land_use_type, only: [:show, :edit, :update, :destroy]

  # GET /land_use_types
  # GET /land_use_types.json
  def index
    @land_use_types = LandUseType.all
  end

  # GET /land_use_types/1
  # GET /land_use_types/1.json
  def show
  end

  # GET /land_use_types/new
  def new
    @land_use_type = LandUseType.new
  end

  # GET /land_use_types/1/edit
  def edit
  end

  # POST /land_use_types
  # POST /land_use_types.json
  def create
    @land_use_type = LandUseType.new(land_use_type_params)

    respond_to do |format|
      if @land_use_type.save
        format.html { redirect_to @land_use_type, notice: 'Land use type was successfully created.' }
        format.json { render :show, status: :created, location: @land_use_type }
      else
        format.html { render :new }
        format.json { render json: @land_use_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /land_use_types/1
  # PATCH/PUT /land_use_types/1.json
  def update
    respond_to do |format|
      if @land_use_type.update(land_use_type_params)
        format.html { redirect_to @land_use_type, notice: 'Land use type was successfully updated.' }
        format.json { render :show, status: :ok, location: @land_use_type }
      else
        format.html { render :edit }
        format.json { render json: @land_use_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /land_use_types/1
  # DELETE /land_use_types/1.json
  def destroy
    @land_use_type.destroy
    respond_to do |format|
      format.html { redirect_to land_use_types_url, notice: 'Land use type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_land_use_type
      @land_use_type = LandUseType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def land_use_type_params
      params.require(:land_use_type).permit(:name, :abbreviation, :identifier)
    end
end
