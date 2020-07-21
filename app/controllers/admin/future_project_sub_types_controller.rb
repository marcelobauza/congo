class Admin::FutureProjectSubTypesController < ApplicationController
  before_action :set_admin_future_project_sub_type, only: [:show, :edit, :update, :destroy]

  # GET /admin/future_project_sub_types
  # GET /admin/future_project_sub_types.json
  def index
    @future_project_sub_types = FutureProjectSubType.all
  end

  # GET /admin/future_project_sub_types/1
  # GET /admin/future_project_sub_types/1.json
  def show
  end

  # GET /admin/future_project_sub_types/new
  def new
    @future_project_sub_type = FutureProjectSubType.new
  end

  # GET /admin/future_project_sub_types/1/edit
  def edit
  end

  # POST /admin/future_project_sub_types
  # POST /admin/future_project_sub_types.json
  def create
    @future_project_sub_type = FutureProjectSubType.new(admin_future_project_sub_type_params)

    respond_to do |format|
      if @future_project_sub_type.save
        format.html { redirect_to admin_future_project_sub_types_path, notice: 'Future project sub type was successfully created.' }
        format.json { render :show, status: :created, location: @future_project_sub_type }
      else
        format.html { render :new }
        format.json { render json: @future_project_sub_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/future_project_sub_types/1
  # PATCH/PUT /admin/future_project_sub_types/1.json
  def update
    respond_to do |format|
      if @future_project_sub_type.update(admin_future_project_sub_type_params)
        format.html { redirect_to @future_project_sub_type, notice: 'Future project sub type was successfully updated.' }
        format.json { render :show, status: :ok, location: @future_project_sub_type }
      else
        format.html { render :edit }
        format.json { render json: @future_project_sub_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/future_project_sub_types/1
  # DELETE /admin/future_project_sub_types/1.json
  def destroy
    @future_project_sub_type.destroy
    respond_to do |format|
      format.html { redirect_to admin_future_project_sub_types_url, notice: 'Future project sub type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_future_project_sub_type
      @future_project_sub_type = FutureProjectSubType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_future_project_sub_type_params
      params.require(:future_project_sub_type).permit(:name)
    end
end
