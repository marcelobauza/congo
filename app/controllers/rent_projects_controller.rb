class RentProjectsController < ApplicationController
  before_action :set_rent_project, only: [:show, :edit, :update, :destroy]

  # GET /rent_projects
  # GET /rent_projects.json
  def index
    @rent_projects = RentProject.all
  end

  # GET /rent_projects/1
  # GET /rent_projects/1.json
  def show
  end

  # GET /rent_projects/new
  def new
    @rent_project = RentProject.new
  end

  # GET /rent_projects/1/edit
  def edit
  end

  # POST /rent_projects
  # POST /rent_projects.json
  def create
    @rent_project = RentProject.new(rent_project_params)

    respond_to do |format|
      if @rent_project.save
        format.html { redirect_to @rent_project, notice: 'Rent project was successfully created.' }
        format.json { render :show, status: :created, location: @rent_project }
      else
        format.html { render :new }
        format.json { render json: @rent_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rent_projects/1
  # PATCH/PUT /rent_projects/1.json
  def update
    respond_to do |format|
      if @rent_project.update(rent_project_params)
        format.html { redirect_to @rent_project, notice: 'Rent project was successfully updated.' }
        format.json { render :show, status: :ok, location: @rent_project }
      else
        format.html { render :edit }
        format.json { render json: @rent_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rent_projects/1
  # DELETE /rent_projects/1.json
  def destroy
    @rent_project.destroy
    respond_to do |format|
      format.html { redirect_to rent_projects_url, notice: 'Rent project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rent_project
      @rent_project = RentProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rent_project_params
      params.require(:rent_project).permit(:code, :name, :county_id, :project_type_id, :floors, :sale_date, :catastral_date, :offer, :surface_util, :terrace, :price, :the_geom, :bedroom, :bathroom, :half_bedroom, :total_beds, :population_per_building, :square_meters_terrain, :uf_terrain, :bimester, :year)
    end
end
