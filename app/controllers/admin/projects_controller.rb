class Admin::ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def kpi
    if !params['county_id'].nil? || !params['polygon_id'].nil?
      @kpi = Project.kpi(params['county_id'], params['year_from'], params['year_to'], params['bimester_id'],  params['project_type_id'], params[:polygon_id])

      if  !@kpi.nil?

        if !params['county_id'].empty?
          @kpi_primary_data = Project.getPrimaryEvolution()
          @county_name = County.where(id: params[:county_id]).select(:name)
        end
        @kpi_evolution = Project.getCountyEvolution

      end
    end
  end

  def export_data
    @projects = Project.new
  end

  def generate_csv
    file = Project.get_csv_data(params[:search])
    send_file file, :type => 'text/csv', :disposition => "inline", :filename => "projects.csv"
  end

  def download_area_data
  end

  def generate_area_csv
    file = Project.get_area_data_csv(params[:search])
    send_file file, :type => 'text/csv', :disposition => "inline", :filename => "projects_area.csv"
  end

  # GET /projects
  # GET /projects.json
  def index
      @projects = Project.find_index(params)
        .paginate(page: params[:page], per_page: 10)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_admin_project_path(@project), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to edit_admin_project_path(@project.id), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to admin_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:code, :name, :address, :floors, :DEFAULT,  :county_id, :agency_id, :integer, :project_type_id, :the_geom, :build_date, :sale_date, :transfer_date, :pilot_opening_date, :quantity_department_for_floor, :elevators, :general_observation, :latitude, :longitude)
  end
end
