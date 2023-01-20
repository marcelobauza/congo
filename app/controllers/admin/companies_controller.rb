class Admin::CompaniesController < Admin::DashboardsController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :export_csv_downloads_by_company]

  layout 'admin'

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.order(:name)
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_companies_path, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to admin_companies_path, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    respond_to do |format|
      if !@company.users.any?
        @company.destroy
        format.html { redirect_to admin_companies_url, notice: 'Company was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to admin_companies_url, notice: "Empresa no puede ser eliminada, tiene usuarios #{@company.users.count} asociados" }
        format.json { head :no_content }
      end
    end
  end

  def export_csv_downloads_by_company
    data = DownloadsUser.export_csv_downloads_by_company @company, 'year', current_user

    send_file data, :type => 'text/csv', :disposition => "inline", :filename => "Descargar_por_empresa.csv"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).
        permit(:name, :projects_downloads, :transactions_downloads,
          :future_projects_downloads, :enabled, :enabled_date
        )
    end
end
