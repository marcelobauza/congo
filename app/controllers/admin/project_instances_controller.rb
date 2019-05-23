class Admin::ProjectInstancesController < ApplicationController
  before_action :set_project_instance, only: [:show, :edit, :update, :destroy]

  # GET /project_instances
  # GET /project_instances.json
  def index
    @project_instances = ProjectInstance.all
  end

  # GET /project_instances/1
  # GET /project_instances/1.json
  def show
  end

  # GET /project_instances/new
  def new
    @project_instance = ProjectInstance.new
  end

  # GET /project_instances/1/edit
  def edit
  end

  # POST /project_instances
  # POST /project_instances.json
  def create
    @project_instance = ProjectInstance.new(project_instance_params)

    respond_to do |format|
      if @project_instance.save
        format.html { redirect_to @project_instance, notice: 'Project instance was successfully created.' }
        format.json { render :show, status: :created, location: @project_instance }
      else
        format.html { render :new }
        format.json { render json: @project_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_instances/1
  # PATCH/PUT /project_instances/1.json
  def update
    respond_to do |format|
      if @project_instance.update(project_instance_params)
        format.html { redirect_to @project_instance, notice: 'Project instance was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_instance }
      else
        format.html { render :edit }
        format.json { render json: @project_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_instances/1
  # DELETE /project_instances/1.json
  def destroy
    @project_instance.destroy
    respond_to do |format|
      format.html { redirect_to project_instances_url, notice: 'Project instance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_instance
      @project_instance = ProjectInstance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_instance_params
      params.require(:project_instance).permit(:project_id, :project_status_id, :bimester, :year, :active, :DEFAULT, :true, :comments, :cadastre, :validated, :DEFAULT, :false)
    end
end
