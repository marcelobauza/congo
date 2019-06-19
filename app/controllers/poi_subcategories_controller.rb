class PoiSubcategoriesController < ApplicationController
  before_action :set_poi_subcategory, only: [:show, :edit, :update, :destroy]

  # GET /poi_subcategories
  # GET /poi_subcategories.json
  def index
    @poi_subcategories = PoiSubcategory.all
  end

  # GET /poi_subcategories/1
  # GET /poi_subcategories/1.json
  def show
  end

  # GET /poi_subcategories/new
  def new
    @poi_subcategory = PoiSubcategory.new
  end

  # GET /poi_subcategories/1/edit
  def edit
  end

  # POST /poi_subcategories
  # POST /poi_subcategories.json
  def create
    @poi_subcategory = PoiSubcategory.new(poi_subcategory_params)

    respond_to do |format|
      if @poi_subcategory.save
        format.html { redirect_to @poi_subcategory, notice: 'Poi subcategory was successfully created.' }
        format.json { render :show, status: :created, location: @poi_subcategory }
      else
        format.html { render :new }
        format.json { render json: @poi_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /poi_subcategories/1
  # PATCH/PUT /poi_subcategories/1.json
  def update
    respond_to do |format|
      if @poi_subcategory.update(poi_subcategory_params)
        format.html { redirect_to @poi_subcategory, notice: 'Poi subcategory was successfully updated.' }
        format.json { render :show, status: :ok, location: @poi_subcategory }
      else
        format.html { render :edit }
        format.json { render json: @poi_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /poi_subcategories/1
  # DELETE /poi_subcategories/1.json
  def destroy
    @poi_subcategory.destroy
    respond_to do |format|
      format.html { redirect_to poi_subcategories_url, notice: 'Poi subcategory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poi_subcategory
      @poi_subcategory = PoiSubcategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poi_subcategory_params
      params.require(:poi_subcategory).permit(:name)
    end
end
