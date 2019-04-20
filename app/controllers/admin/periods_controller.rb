class Admin::PeriodsController < ApplicationController
  before_action :set_admin_period, only: [:show, :edit, :update, :destroy]

  # GET /admin/periods
  # GET /admin/periods.json
  def index
    @periods = Period.all
  end

  # GET /admin/periods/1
  # GET /admin/periods/1.json
  def show
  end

  # GET /admin/periods/new
  def new
    @period = Period.new
  end

  # GET /admin/periods/1/edit
  def edit
  end

  # POST /admin/periods
  # POST /admin/periods.json
  def create
    @period = Period.new(admin_period_params)

    respond_to do |format|
      if @period.save
        format.html { redirect_to admin_periods_path(), notice: 'Period was successfully created.' }
        format.json { render :show, status: :created, location: @period }
      else
        format.html { render :new }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/periods/1
  # PATCH/PUT /admin/periods/1.json
  def update
    respond_to do |format|
      if @period.update(admin_period_params)
        format.html { redirect_to admin_period_path(), notice: 'Period was successfully updated.' }
        format.json { render :show, status: :ok, location: @period }
      else
        format.html { render :edit }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/periods/1
  # DELETE /admin/periods/1.json
  def destroy
    @period.destroy
    respond_to do |format|
      format.html { redirect_to admin_periods_url, notice: 'Period was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_period
      @period = Period.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_period_params
      params.require(:period).permit(:bimester, :year, :active)
    end
end
