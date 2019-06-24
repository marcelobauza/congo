class ApplicationStatusesController < ApplicationController
  before_action :set_application_status, only: [:show, :edit, :update, :destroy]

  # GET /application_statuses
  # GET /application_statuses.json

  def load
    @row = ApplicationStatus.where(id: params[:id]).take
    respond_to do |f|
        f.js
  end
  end

  def index
    @application_statuses = ApplicationStatus.where(user_id: current_user.id)
  end

  # GET /application_statuses/1
  # GET /application_statuses/1.json
  def show
  end

  # GET /application_statuses/new
  def new
    @application_status = ApplicationStatus.new
  end

  # GET /application_statuses/1/edit
  def edit
  end

  # POST /application_statuses
  # POST /application_statuses.json
  def create

    @data = session[:data]
    @application_status = ApplicationStatus.new(application_status_params)
    @application_status[:filters] = @data
    respond_to do |format|
      if @application_status.save
        format.js
    end
  end
  end

  # PATCH/PUT /application_statuses/1
  # PATCH/PUT /application_statuses/1.json
  def update
    respond_to do |format|
      if @application_status.update(application_status_params)
        format.html { redirect_to @application_status, notice: 'Application status was successfully updated.' }
        format.json { render :show, status: :ok, location: @application_status }
      else
        format.html { render :edit }
        format.json { render json: @application_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_statuses/1
  # DELETE /application_statuses/1.json
  def destroy
    @application_status.destroy
    respond_to do |format|
      format.html { redirect_to application_statuses_url, notice: 'Application status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_status
      @application_status = ApplicationStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def application_status_params
      params.require(:application_status).permit(:name, :description, :user_id, :polygon, :layer_type, :filters).merge(user_id: current_user.id)
    end
end
