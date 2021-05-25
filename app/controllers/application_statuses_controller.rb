class ApplicationStatusesController < ApplicationController
  before_action :set_application_status, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /application_statuses
  # GET /application_statuses.json

  def load
    @row = ApplicationStatus.where(id: params[:id]).take.as_json
    @row = @row['filters']
    respond_to do |f|
        f.js
  end
  end

  def colleagues
    @colleagues = User.where(company: current_user.company).where.not(id: current_user.id).or(User.where(role_id: 6)).select(:id, :complete_name).order(:complete_name)
    @row_to_share = params[:id]
  end

  def share_users
    @row_filter = ApplicationStatus.where(id: params[:share_users]['row_to_share']).select(:filters, :name)
    @ids = params[:share_users][:ids].reject(&:blank?) 
@ids.each do |id|
        ApplicationStatus.create(user_id: id, filters: @row_filter[0]['filters'], name: @row_filter[0]['name'])
    end
    respond_to do |f|
        f.js
  end
  end


  def index
    @application_statuses = ApplicationStatus.where(user_id: current_user.id).order(sort_column + ' ' + sort_direction)
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
  end

  private

  def sort_column
    ApplicationStatus.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_application_status
      @application_status = ApplicationStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def application_status_params
      params.require(:application_status).permit(:name, :description, :user_id, :polygon, :layer_type, :filters).merge(user_id: current_user.id)
    end
end
