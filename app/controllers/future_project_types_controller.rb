class FutureProjectTypesController < ApplicationController
  before_action :set_future_project_type, only: [:show, :edit, :update, :destroy]

  def legend_points

    @legend = FutureProjectType.where(id: params[:future_project_type_ids]) if params.has_key? :future_project_type_ids
    @legend = FutureProjectType.all if !params.has_key? :future_project_type_ids
    render json: @legend
  end
  # GET /future_project_types
  # GET /future_project_types.json
  def index
    @future_project_types = FutureProjectType.all
  end

  # GET /future_project_types/1
  # GET /future_project_types/1.json
  def show
  end

  # GET /future_project_types/new
  def new
    @future_project_type = FutureProjectType.new
  end

  # GET /future_project_types/1/edit
  def edit
  end

  # POST /future_project_types
  # POST /future_project_types.json
  def create
    @future_project_type = FutureProjectType.new(future_project_type_params)

    respond_to do |format|
      if @future_project_type.save
        format.html { redirect_to @future_project_type, notice: 'Future project type was successfully created.' }
        format.json { render :show, status: :created, location: @future_project_type }
      else
        format.html { render :new }
        format.json { render json: @future_project_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /future_project_types/1
  # PATCH/PUT /future_project_types/1.json
  def update
    respond_to do |format|
      if @future_project_type.update(future_project_type_params)
        format.html { redirect_to @future_project_type, notice: 'Future project type was successfully updated.' }
        format.json { render :show, status: :ok, location: @future_project_type }
      else
        format.html { render :edit }
        format.json { render json: @future_project_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /future_project_types/1
  # DELETE /future_project_types/1.json
  def destroy
    @future_project_type.destroy
    respond_to do |format|
      format.html { redirect_to future_project_types_url, notice: 'Future project type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_future_project_type
      @future_project_type = FutureProjectType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def future_project_type_params
      params.require(:future_project_type).permit(:name, :abbrev, :color)
    end
end
