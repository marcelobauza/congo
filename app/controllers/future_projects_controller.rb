class FutureProjectsController < ApplicationController
  before_action :set_future_project, only: [:show, :edit, :update, :destroy]

  def dashboards
    respond_to do |f|
      f.js    
    end 
  end

  def future_projects_summary
    result = {:sheet => "Resumen", :data => []}

    #begin
    general_data = general
    types = future_project_type
    desttypes = destination_project_type
    dtypes = destination_type
    ubimester = unit_bimester
    m2bimester = m2_built_bimester
    rates = future_project_rates
    #GENERAL

    data =[]
    result=[]
    general_data.each do |item|
      data.push("name": item[:label], "count":item[:value].to_i)
    end
    result.push(["chart0": {"title":"Informacion General", "serie0": {"data": data}}])

    #TIPO DE EXPEDIENTE
    data =[]
    types.each_pair do |key, value|
      data.push("name": FutureProjectType.find(key).name.capitalize, "count":value.to_i)
    end
    result.push(["chart1": {"title":"Tipo de Expendiente", "serie0":{"data": data}}])

    #TIPO DE DESTINO
    data =[]
    desttypes.each do |item|
      data.push("name": item["project_type_name"], "count": item["value"].to_i)
    end
    result.push(["chart2": {"title":"Tipo de Expendiente",  "data": data}])
    ##TIPO DE DESTINO OTRO
    categories = []
    series = []
    count = 0
    chart = ["chart3":{"title": "Tipo de Destino"}]
    dtypes.each do |item|
      label = item[:type]
      data =[]
      item[:values].each do |itm|
        data.push("name": itm["project_type"], "count": itm["value"].to_i)
      end
      chart[0][:chart3].merge!("serie#{count}":{"label": label, "data": data}  )
      count = count + 1 
    end
    result.push(chart)

    #UNIDADES NUEVAS POR BIMESTRE
    chart4 = ["chart4":{"title": "Cantidad de unidades nuevas / bimestre"}]
    a = []
    p = []
    r = []
    ubimester.last.each do |item|
      @item = item
      item[:values].each do |itm|

        if itm["y_label"] == 'ANTEPROYECTO'
          a.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )           
          chart4[0][:chart4].merge!("serie0":{"label": "ANTEPROYECTO", "data": a})
        end
        if itm["y_label"] == 'PERMISO DE EDIFICACION'
          p.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )           
          chart4[0][:chart4].merge!("serie1":{"label": "PERMISO DE EDIFICACION", "data": p})
        end

        if itm["y_label"] == 'RECEPCION MUNICIPAL'
          r.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )           
          chart4[0][:chart4].merge!("serie2":{"label": "RECEPCION MUNICIPAL", "data": r})
        end

      end
    end
    result.push(chart4)

    #SUPERFICIE EDIFICADA POR EXPEDIENTE

    chart5 = ["chart5":{"title": "Superficie edificada por expediente"}]
    a = []
    p = []
    r = []
    m2bimester.last.each do |item|
      item[:values].each do |itm|

        if itm["y_label"] == 'ANTEPROYECTO'
          a.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )           
          chart5[0][:chart5].merge!("serie0":{"label": "ANTEPROYECTO", "data": a})
        end
        if itm["y_label"] == 'PERMISO DE EDIFICACION'
          p.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )           
          chart5[0][:chart5].merge!("serie1":{"label": "PERMISO DE EDIFICACION", "data": p})
        end

        if itm["y_label"] == 'RECEPCION MUNICIPAL'
          r.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )           
          chart5[0][:chart5].merge!("serie2":{"label": "RECEPCION MUNICIPAL", "data": r})
        end

      end
    end
    result.push(chart5)



    #TASAS

    chart6 = ["chart6":{"title": "Tasas"}]
    p = []
    r = []
    rates.each do |item|
      p.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":item[:perm_rate] )           
      chart6[0][:chart6].merge!("serie0":{"label": "Tasa Permiso / Anteproyecto", "data": p})

      r.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":item[:recept_rate] )           
      chart6[0][:chart6].merge!("serie1":{"label": "Tasa Recepciones / Permisos", "data": r})
    end
    result.push(chart6)

    @result = result
    return @result

    # result[:data] << [""]
    # result[:data] << ["Tasas"]
    # result[:data] << ["Bimestre", "Tasa permiso / Anteproyecto", "Tasa recepciones / Permisos"]

    # rates.each do |item|
    #   result[:data] << [(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), item[:perm_rate].to_f, item[:recept_rate].to_f]
    # end

    #rescue
    #  result[:data] = ["Sin datos"]
    #end

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
