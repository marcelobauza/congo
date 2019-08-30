class DensityTypesController < ApplicationController
  before_action :set_density_type, only: [:show, :edit, :update, :destroy]

  def legend_points

    @legend = DensityType.where.not(identifier: 'null') 
    render json: @legend
  end
  # GET /density_types
  # GET /density_types.json
  def index
    @density_types = DensityType.all
  end

  # GET /density_types/1
  # GET /density_types/1.json
  def show
  end

  # GET /density_types/new
  def new
    @density_type = DensityType.new
  end

  # GET /density_types/1/edit
  def edit
  end

  # POST /density_types
  # POST /density_types.json
  def create
    @density_type = DensityType.new(density_type_params)

    respond_to do |format|
      if @density_type.save
        format.html { redirect_to @density_type, notice: 'Density type was successfully created.' }
        format.json { render :show, status: :created, location: @density_type }
      else
        format.html { render :new }
        format.json { render json: @density_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /density_types/1
  # PATCH/PUT /density_types/1.json
  def update
    respond_to do |format|
      if @density_type.update(density_type_params)
        format.html { redirect_to @density_type, notice: 'Density type was successfully updated.' }
        format.json { render :show, status: :ok, location: @density_type }
      else
        format.html { render :edit }
        format.json { render json: @density_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /density_types/1
  # DELETE /density_types/1.json
  def destroy
    @density_type.destroy
    respond_to do |format|
      format.html { redirect_to density_types_url, notice: 'Density type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_density_type
      @density_type = DensityType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def density_type_params
      params.require(:density_type).permit(:name, :color, :position, :identifier)
    end
end
