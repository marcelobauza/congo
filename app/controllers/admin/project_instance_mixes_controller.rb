class Admin::ProjectInstanceMixesController < ApplicationController
  before_action :set_project_project_instances
  before_action :set_project_instance_mix, only: [:show, :edit, :update, :destroy]

  layout 'admin'
  # GET /project_instance_mixes
  # GET /project_instance_mixes.json
  def index

    @project_instance_mixes = @project_instance.project_instance_mixes.all
  end

  # GET /project_instance_mixes/1
  # GET /project_instance_mixes/1.json
  def show
  end

  # GET /project_instance_mixes/new
  def new
    @project_instance_mix = @project_instance.project_instance_mixes.new
  end

  # GET /project_instance_mixes/1/edit
  def edit
  end

  # POST /project_instance_mixes
  # POST /project_instance_mixes.json
  def create
    @project_instance_mix = @project_instance.project_instance_mixes.new(project_instance_mix_params)

    respond_to do |format|
      if @project_instance_mix.save
        format.html { redirect_to @project_instance_mix, notice: 'Project instance mix was successfully created.' }
        format.json { render :show, status: :created, location: @project_instance_mix }
      else
        format.html { render :new }
        format.json { render json: @project_instance_mix.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_instance_mixes/1
  # PATCH/PUT /project_instance_mixes/1.json
  def update
    respond_to do |format|
      if @project_instance_mix.update(project_instance_mix_params)
        format.html { redirect_to admin_project_project_instance_project_instance_mixes_path(@project, @project_instance), notice: 'Project instance mix was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_instance_mix }
      else
        format.html { render :edit }
        format.json { render json: @project_instance_mix.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_instance_mixes/1
  # DELETE /project_instance_mixes/1.json
  def destroy
    @project_instance_mix.destroy
    respond_to do |format|
      format.html { redirect_to project_instance_mixes_url, notice: 'Project instance mix was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_project_project_instances
    @project = Project.find(params[:project_id])
    @project_instance = @project.project_instances.find(params[:project_instance_id])
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_project_instance_mix
    @project_instance_mix = ProjectInstanceMix.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_instance_mix_params
    params.require(:project_instance_mix).permit(:project_instance_id, :mix_id, :percentage, :stock_units, :mix_m2_field, :mix_m2_built, :mix_usable_square_meters, :mix_terrace_square_meters, :mix_uf_m2, :mix_selling_speed, :mix_uf_value, :living_room, :service_room, :h_office, :discount, :uf_min, :uf_max, :uf_parking, :uf_cellar, :common_expenses, :withdrawal_percent, :total_units, :t_min, :t_max, :home_type, :model, :get_bedroom, :get_bathroom)
  end
end
