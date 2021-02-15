class RentFutureProjectsController < ApplicationController
  before_action :set_rent_future_project, only: [:show, :edit, :update, :destroy]

  # GET /rent_future_projects
  # GET /rent_future_projects.json
  def index
    @rent_future_projects = RentFutureProject.all
  end

  # GET /rent_future_projects/1
  # GET /rent_future_projects/1.json
  def show
  end

  # GET /rent_future_projects/new
  def new
    @rent_future_project = RentFutureProject.new
  end

  # GET /rent_future_projects/1/edit
  def edit
  end

  # POST /rent_future_projects
  # POST /rent_future_projects.json
  def create
    @rent_future_project = RentFutureProject.new(rent_future_project_params)

    respond_to do |format|
      if @rent_future_project.save
        format.html { redirect_to @rent_future_project, notice: 'Rent future project was successfully created.' }
        format.json { render :show, status: :created, location: @rent_future_project }
      else
        format.html { render :new }
        format.json { render json: @rent_future_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rent_future_projects/1
  # PATCH/PUT /rent_future_projects/1.json
  def update
    respond_to do |format|
      if @rent_future_project.update(rent_future_project_params)
        format.html { redirect_to @rent_future_project, notice: 'Rent future project was successfully updated.' }
        format.json { render :show, status: :ok, location: @rent_future_project }
      else
        format.html { render :edit }
        format.json { render json: @rent_future_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rent_future_projects/1
  # DELETE /rent_future_projects/1.json
  def destroy
    @rent_future_project.destroy
    respond_to do |format|
      format.html { redirect_to rent_future_projects_url, notice: 'Rent future project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rent_future_project
      @rent_future_project = RentFutureProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rent_future_project_params
      params.require(:rent_future_project).permit(:code, :address, :name, :role_number, :file_number, :file_date, :owner, :legal_agent, :architech, :floors, :undergrounds, :total_units, :total_parking, :total_commercials, :m2_approved, :m2_built, :m2_field, :t_ofi, :cadastral_date, :comments, :bimester, :year, :project_type_id, :future_project_type_id, :county_id)
    end
end
