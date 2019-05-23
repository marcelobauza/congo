class Admin::ProjectMixesController < ApplicationController
  before_action :set_project_mix, only: [:show, :edit, :update, :destroy]

  # GET /project_mixes
  # GET /project_mixes.json
  def index
    @project_mixes = ProjectMix.all
  end

  # GET /project_mixes/1
  # GET /project_mixes/1.json
  def show
  end

  # GET /project_mixes/new
  def new
    @project_mix = ProjectMix.new
  end

  # GET /project_mixes/1/edit
  def edit
  end

  # POST /project_mixes
  # POST /project_mixes.json
  def create
    @project_mix = ProjectMix.new(project_mix_params)

    respond_to do |format|
      if @project_mix.save
        format.html { redirect_to @project_mix, notice: 'Project mix was successfully created.' }
        format.json { render :show, status: :created, location: @project_mix }
      else
        format.html { render :new }
        format.json { render json: @project_mix.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_mixes/1
  # PATCH/PUT /project_mixes/1.json
  def update
    respond_to do |format|
      if @project_mix.update(project_mix_params)
        format.html { redirect_to @project_mix, notice: 'Project mix was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_mix }
      else
        format.html { render :edit }
        format.json { render json: @project_mix.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_mixes/1
  # DELETE /project_mixes/1.json
  def destroy
    @project_mix.destroy
    respond_to do |format|
      format.html { redirect_to project_mixes_url, notice: 'Project mix was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_mix
      @project_mix = ProjectMix.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_mix_params
      params.require(:project_mix).permit(:bedroom, :bathroom, :mix_type)
    end
end
