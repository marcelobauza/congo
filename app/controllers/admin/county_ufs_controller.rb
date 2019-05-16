class Admin::CountyUfsController < ApplicationController
  before_action :set_admin_county_uf, only: [:show, :edit, :update, :destroy]

  # GET /admin/county_ufs
  # GET /admin/county_ufs.json
  def index
    @property_types = PropertyType.select("id, name").order(:name).map {|t| [t.name, t.id]}
    @property_types.insert(0, ["", nil])

    @counties = County.select("id, name").order(:name).map {|c| [c.name, c.id]}
    @counties.insert(0, ["", nil])
    @county_ufs = CountyUf.where(county_id: params[:county_id]).where(property_type_id: params[:property_type_id]).paginate(page: params[:page])
    @admin_county_ufs = CountyUf.all
  end

  # GET /admin/county_ufs/1
  # GET /admin/county_ufs/1.json
  def show
  end

  # GET /admin/county_ufs/new
  def new
    @admin_county_uf = CountyUf.new
  end

  # GET /admin/county_ufs/1/edit
  def edit
  end

  # POST /admin/county_ufs
  # POST /admin/county_ufs.json
  def create
    @admin_county_uf = CountyUf.new(admin_county_uf_params)

    respond_to do |format|
      if @admin_county_uf.save
        format.html { redirect_to @admin_county_uf, notice: 'County uf was successfully created.' }
        format.json { render :show, status: :created, location: @admin_county_uf }
      else
        format.html { render :new }
        format.json { render json: @admin_county_uf.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/county_ufs/1
  # PATCH/PUT /admin/county_ufs/1.json
  def update
    respond_to do |format|
      if @admin_county_uf.update(admin_county_uf_params)
        format.html { redirect_to @admin_county_uf, notice: 'County uf was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_county_uf }
      else
        format.html { render :edit }
        format.json { render json: @admin_county_uf.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/county_ufs/1
  # DELETE /admin/county_ufs/1.json
  def destroy
    @admin_county_uf.destroy
    respond_to do |format|
      format.html { redirect_to admin_county_ufs_url, notice: 'County uf was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin_county_uf
    @admin_county_uf = CountyUf.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_county_uf_params
    params.require(:admin_county_uf).permit(:county_id, :property_type_id, :uf_min, :uf_max)
  end
end
