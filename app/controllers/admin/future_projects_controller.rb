class Admin::FutureProjectsController < ApplicationController
  before_action :set_future_project, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  def export_data
    @counties = County.order(name: :asc)
    @future_project = FutureProject.new
  end
  def generate_csv
    file = FutureProject.get_csv_data(params)
    send_file file, :type => 'text/csv', :disposition => "inline", :filename => "future_project.csv"
  end

  # GET /future_projects
  # GET /future_projects.json
  def index
    @future_projects = FutureProject.where(nil)
    @future_projects = @future_projects.future_project_type_filter(params[:future_project_type_id]) if !params[:future_project_type_id].nil?
    @future_projects = @future_projects.project_type_filter(params[:project_type_id]) if !params[:project_type_id].nil?
    @future_projects = @future_projects.code_filter(params[:code]) if !params[:code].nil?

    @future_projects = @future_projects.all.paginate(page: params[:page])
  end

  # GET /future_projects/1
  # GET /future_projects/1.json
  def show
  end

  # GET /future_projects/new
  def new
    @future_project = FutureProject.new
  end

  # GET /future_projects/1/edit
  def edit
  end

  # POST /future_projects
  # POST /future_projects.json
  def create
    @future_project = FutureProject.new(future_project_params)

    respond_to do |format|
      if @future_project.save
        format.html { redirect_to @future_project, notice: 'Future project was successfully created.' }
        format.json { render :show, status: :created, location: @future_project }
      else
        format.html { render :new }
        format.json { render json: @future_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /future_projects/1
  # PATCH/PUT /future_projects/1.json
  def update
    respond_to do |format|
      if @future_project.update(future_project_params)
        format.html { redirect_to admin_future_projects_path(), notice: 'Future project was successfully updated.' }
        format.json { render :show, status: :ok, location: @future_project }
      else
        format.html { render :edit }
        format.json { render json: @future_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /future_projects/1
  # DELETE /future_projects/1.json
  def destroy
    @future_project.destroy
    respond_to do |format|
      format.html { redirect_to admin_future_projects_url, notice: 'Future project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_future_project
    @future_project = FutureProject.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def future_project_params
    params.require(:future_project).permit(:code, :address, :name, :role_number, :file_number, :file_date, :owner, :legal_agent, :architect, :floors, :undergrounds, :total_units, :total_parking, :total_commercials, :m2_approved, :m2_built, :m2_field, :cadastral_date, :comments, :bimester, :year, :cadastre, :active, :project_type_id, :future_project_type_id, :county_id, :the_geom, :t_ofi)
  end
end
