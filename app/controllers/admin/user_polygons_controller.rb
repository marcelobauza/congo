class Admin::UserPolygonsController < ApplicationController
  before_action :set_user_polygon, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  def export_data
    @user_polygons = UserPolygon.new
  end

  def generate_csv
    file = UserPolygon.get_csv_data(params)
    send_file file, :type => 'text/csv', :disposition => "inline", :filename => "user_polygoms.csv"
  end


  # GET /user_polygons
  # GET /user_polygons.json
  def index
    @user_polygons = UserPolygon.all
  end

  # GET /user_polygons/1
  # GET /user_polygons/1.json
  def show
  end

  # GET /user_polygons/new
  def new
    @user_polygon = UserPolygon.new
  end

  # GET /user_polygons/1/edit
  def edit
  end

  # POST /user_polygons
  # POST /user_polygons.json
  def create
    @user_polygon = UserPolygon.new(user_polygon_params)

    respond_to do |format|
      if @user_polygon.save
        format.html { redirect_to @user_polygon, notice: 'User polygon was successfully created.' }
        format.json { render :show, status: :created, location: @user_polygon }
      else
        format.html { render :new }
        format.json { render json: @user_polygon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_polygons/1
  # PATCH/PUT /user_polygons/1.json
  def update
    respond_to do |format|
      if @user_polygon.update(user_polygon_params)
        format.html { redirect_to @user_polygon, notice: 'User polygon was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_polygon }
      else
        format.html { render :edit }
        format.json { render json: @user_polygon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_polygons/1
  # DELETE /user_polygons/1.json
  def destroy
    @user_polygon.destroy
    respond_to do |format|
      format.html { redirect_to user_polygons_url, notice: 'User polygon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_polygon
    @user_polygon = UserPolygon.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_polygon_params
    params.require(:user_polygon).permit(:user_id, :wkt, :layertype, :text)
  end
end
