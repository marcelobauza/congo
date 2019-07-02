class CensusSourcesController < ApplicationController
  before_action :set_census_source, only: [:show, :edit, :update, :destroy]

  # GET /census_sources
  # GET /census_sources.json
  def index
    @census_sources = CensusSource.all
  end

  # GET /census_sources/1
  # GET /census_sources/1.json
  def show
  end

  # GET /census_sources/new
  def new
    @census_source = CensusSource.new
  end

  # GET /census_sources/1/edit
  def edit
  end

  # POST /census_sources
  # POST /census_sources.json
  def create
    @census_source = CensusSource.new(census_source_params)

    respond_to do |format|
      if @census_source.save
        format.html { redirect_to @census_source, notice: 'Census source was successfully created.' }
        format.json { render :show, status: :created, location: @census_source }
      else
        format.html { render :new }
        format.json { render json: @census_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /census_sources/1
  # PATCH/PUT /census_sources/1.json
  def update
    respond_to do |format|
      if @census_source.update(census_source_params)
        format.html { redirect_to @census_source, notice: 'Census source was successfully updated.' }
        format.json { render :show, status: :ok, location: @census_source }
      else
        format.html { render :edit }
        format.json { render json: @census_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /census_sources/1
  # DELETE /census_sources/1.json
  def destroy
    @census_source.destroy
    respond_to do |format|
      format.html { redirect_to census_sources_url, notice: 'Census source was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_census_source
      @census_source = CensusSource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def census_source_params
      params.require(:census_source).permit(:name)
    end
end
