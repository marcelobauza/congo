class Admin::SurveyorsController < ApplicationController
  before_action :set_surveyor, only: [:show, :edit, :update, :destroy]

  # GET /surveyors
  # GET /surveyors.json
  def index
    @surveyors = Surveyor.all
  end

  # GET /surveyors/1
  # GET /surveyors/1.json
  def show
  end

  # GET /surveyors/new
  def new
    @surveyor = Surveyor.new
  end

  # GET /surveyors/1/edit
  def edit
  end

  # POST /surveyors
  # POST /surveyors.json
  def create
    @surveyor = Surveyor.new(surveyor_params)

    respond_to do |format|
      if @surveyor.save
        format.html { redirect_to admin_surveyors_path(), notice: 'Surveyor was successfully created.' }
        format.json { render :show, status: :created, location: @surveyor }
      else
        format.html { render :new }
        format.json { render json: @surveyor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /surveyors/1
  # PATCH/PUT /surveyors/1.json
  def update
    respond_to do |format|
      if @surveyor.update(surveyor_params)
        format.html { redirect_to admin_surveyors_path(), notice: 'Surveyor was successfully updated.' }
        format.json { render :show, status: :ok, location: @surveyor }
      else
        format.html { render :edit }
        format.json { render json: @surveyor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveyors/1
  # DELETE /surveyors/1.json
  def destroy
    @surveyor.destroy
    respond_to do |format|
      format.html { redirect_to surveyors_url, notice: 'Surveyor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_surveyor
      @surveyor = Surveyor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def surveyor_params
      params.require(:surveyor).permit(:name)
    end
end
