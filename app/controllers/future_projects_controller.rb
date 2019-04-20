class FutureProjectsController < ApplicationController
  before_action :set_future_project, only: [:show, :edit, :update, :destroy]

  def dashboards

end

  def future_projects_summary
    result = {:sheet => "Resumen", :data => []}

    begin
      general_data = general
      types = future_project_type
      desttypes = destination_project_type
      dtypes = destination_type
      ubimester = unit_bimester
      m2bimester = m2_built_bimester
      rates = future_project_rates
      #GENERAL
      result = {:sheet => "Resumen", :data => []}
      result[:data] << ["Información General"]

      general_data.each do |item|
        result[:data] << [item[:label], item[:value].to_i]
      end
      #TIPO DE EXPEDIENTE
      result[:data] << [""]
      result[:data] << ["Tipos de expediente"]
      result[:data] << ["Tipo", "Total de expedientes"]

      types.each_pair do |key, value|
        result[:data] << [FutureProjectType.find(key).name.capitalize, value.to_i]
      end

      #TIPO DE DESTINO
      result[:data] << [""]
      result[:data] << ["Tipos de destino"]
      result[:data] << ["Tipo", "Total de expedientes"]

      desttypes.each do |item|
        result[:data] << [item["project_type_name"], item["value"].to_i]
      end

      ##TIPO DE DESTINO OTRO
      result[:data] << [""]
      result[:data] << ["Tipo de destino"]

      categories = []

      dtypes.each do |item|
        item[:values].each do |itm|
          categories << itm["project_type"]
        end
      end

      result[:data] << [""] + categories.uniq!
      dtypes.each do |item|
        temp = [item[:type]]
        categories.each do |cat|
          val = 0

          item[:values].each do |ty|
            val = ty["value"].to_i if ty["project_type"] == cat
          end

          temp << val
        end
        result[:data] << temp
      end

      #UNIDADES NUEVAS POR BIMESTRE
      result[:data] << [""]
      result[:data] << ["Cantidad de unidades nuevas / bimestre"]
      result[:data] << ["Bimestre", "Anteproyecto", "Permiso edificación", "Recepción Municipal"]

      ubimester.last.each do |item|
        value_1 = item[:values].first["y_value"].to_i rescue 0
        value_2 = item[:values][1]["y_value"].to_i rescue 0
        value_3 = item[:values].last["y_value"].to_i rescue 0

        result[:data] << [(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), value_1, value_2, value_3]
      end

      #SUPERFICIE EDIFICADA POR EXPEDIENTE
      result[:data] << [""]
      result[:data] << ["Superficie edificada por expediente"]
      result[:data] << ["Bimestre", "Anteproyecto", "Permiso edificación", "Recepción Municipal"]

      m2bimester.last.each do |item|
        value_1 = item[:values].first["y_value"].to_i rescue 0
        value_2 = item[:values][1]["y_value"].to_i rescue 0
        value_3 = item[:values].last["y_value"].to_i rescue 0

        result[:data] << [(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), value_1, value_2, value_3]
      end

      #TASAS
      result[:data] << [""]
      result[:data] << ["Tasas"]
      result[:data] << ["Bimestre", "Tasa permiso / Anteproyecto", "Tasa recepciones / Permisos"]

      rates.each do |item|
        result[:data] << [(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), item[:perm_rate].to_f, item[:recept_rate].to_f]
      end

    rescue
      result[:data] = ["Sin datos"]
    end

    #file_path = Xls.generate [result], "/xls", {:file_name => "#{Time.now.strftime("%Y-%m-%d_%H.%M")}_expedientes", :clean_directory_path => true}
    #send_file file_path, :type => "application/excel"
   @result = result
  end
def general
    rates, global_information = FutureProject.find_globals(params)
    @general = []
    return if global_information.nil?

    global_information.each do |typ|
      @general << {:label => t(:TOTAL_PERMISSIONS) + " " + typ["name"].titleize, :value => typ["count_project"]}
    end

    global_information.each do |typ|
      @general << {:label => t(:AVG_PERMISSIONS) + " " + typ["name"].titleize, :value => typ["avg_project_bim"]}
    end

    global_information.each do |typ|
      @general << {:label => t(:M2_BUILT_PERMISSIONS) + " " + typ["name"].titleize, :value => typ["total_surface"]}
    end

    global_information.each do |typ|
      @general << {:label => t(:AVG_M2_BUILT_PERMISSIONS) + " " + typ["name"].titleize, :value => typ["avg_surface"]}
    end

    @general << {:label => t(:PERMISSION_DRAFT_RATE), :value => rates[:permission_draft_rate]}
    @general << {:label => t(:RECEPTION_PERMISSION_RATE), :value => rates[:reception_permission_rate]}
  end


  def future_project_type
    @types = FutureProject.group_by_project_type('future_project_types', params)
  end

  def destination_type
    @types = FutureProject.units_by_project_type(params)
  end

  def destination_project_type
    @types = FutureProject.projects_by_destination_project_type(params, 'project_types')
  end

  def unit_bimester
    @fut_types, @projects = FutureProject.future_projects_by_period("COUNT", "unit_bimester", params)
  end

  def m2_built_bimester
    @fut_types, @projects = FutureProject.future_projects_by_period("SUM", "m2_built_bimester", params)
  end

  def future_project_rates
    @projects = FutureProject.future_project_rates("future_project_rates", params)
  end

  def benchmarking_list
    @bench_projects = FutureProjectResult.get_benchmarking_project_list(params[:result_id], params[:project_id])
    @current_project = FutureProject.find(params[:project_id])
  end

  def benchmarking
    @projects = FutureProject.get_bench_values(params[:project_ids])
  end

  def period
    @period = FutureProject.get_last_period
    @first_period = FutureProject.get_first_bimester_with_future_projects

    unless @period.nil?
      unless FutureProject.is_periods_distance_allowed?(@first_period , @period.first, @period.size)
        @first_period[:year] = @period.last[:year]
        @first_period[:period] = @period.last[:period]
      end
    end

  end

  def suggest
    @suggests = FutureProjectResult.get_search_suggests(params)
  end

  def search
    @updated = FutureProjectResult.search(params)
  end

  def around_pois
    pois = Poi.get_around_pois(params[:id], "future_projects", params[:wkt])
    render :xml => pois.to_xml(:skip_instruct => true, :skip_types => true, :dasherize => false)
  end
  # GET /future_projects
  # GET /future_projects.json
  def index
    @future_projects = FutureProject.all
  end

  # GET /future_projects/1
  # GET /future_projects/1.json
  def show
  end

  # GET /future_projects/new
  def new
    @future_project = FutureProject.new
  end

  # GET /future_projects/1/edit
  def edit
  end

  # POST /future_projects
  # POST /future_projects.json
  def create
    @future_project = FutureProject.new(future_project_params)

    respond_to do |format|
      if @future_project.save
        format.html { redirect_to @future_project, notice: 'Future project was successfully created.' }
        format.json { render :show, status: :created, location: @future_project }
      else
        format.html { render :new }
        format.json { render json: @future_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /future_projects/1
  # PATCH/PUT /future_projects/1.json
  def update
    respond_to do |format|
      if @future_project.update(future_project_params)
        format.html { redirect_to @future_project, notice: 'Future project was successfully updated.' }
        format.json { render :show, status: :ok, location: @future_project }
      else
        format.html { render :edit }
        format.json { render json: @future_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /future_projects/1
  # DELETE /future_projects/1.json
  def destroy
    @future_project.destroy
    respond_to do |format|
      format.html { redirect_to future_projects_url, notice: 'Future project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_future_project
      @future_project = FutureProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def future_project_params
      params.require(:future_project).permit(:code, :address, :name, :role_number, :file_number, :file_date, :owner, :legal_agent, :architect, :floors, :undergrounds, :total_units, :total_parking, :total_commercials, :m2_approved, :m2_built, :m2_field, :cadastral_date, :comments, :bimester, :year, :cadastre, :active, :project_type_id, :future_project_type_id, :county_id, :the_geom, :t_ofi)
    end
end
