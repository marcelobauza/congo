class FutureProjectsController < ApplicationController
  before_action :set_future_project, only: [:show, :edit, :update, :destroy]

  def graduated_points
      @interval = FutureProject.interval_graduated_points(params)
      render json: {data: @interval}
  end

  def dashboards
    respond_to do |f|
      f.js
    end
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

      data =[]
      result=[]
      general_data.each do |item|
        data.push("name": item[:label], "count":item[:value].to_i)
      end
      result.push({"title":"Información General", "data": data})

      #TIPO DE EXPEDIENTE
      data =[]
      types.each_pair do |key, value|
        data.push("name": FutureProjectType.find(key).name.capitalize, "count":value.to_i)
      end
      result.push({"title":"Tipo de Expendiente", "series":[{"data": data}]})

      #TIPO DE DESTINO PIE
      data =[]
      desttypes.each do |item|
        data.push("name": item["project_type_name"], "count": item["value"].to_i)
      end
      result.push({"title":"Tipo de Destino Pie",  "series": [{"data": data}]})
      ##TIPO DE DESTINO BAR
      categories = []
      series = []
      count = 0
      dtypes.each do |item|
        label = item[:type]
        data =[]
        item[:values].each do |itm|
          data.push("name": itm["project_type"], "count": itm["value"].to_i)
        end
        categories.push({"label": label, "data": data} )
        count = count + 1
      end
      result.push({"title": "Tipo de Destino Bar", "series":categories})

      #UNIDADES NUEVAS POR BIMESTRE
      categories = []
      a = []
      p = []
      r = []
      ubimester.last.each do |item|
        @item = item
        item[:values].each do |itm|

          if itm["y_label"] == 'ANTEPROYECTO'
            a.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )

          end
          if itm["y_label"] == 'PERMISO DE EDIFICACION'
            p.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )

          end

          if itm["y_label"] == 'RECEPCION MUNICIPAL'
            r.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )

          end
        end
      end
      categories.push({"label": "Anteproyecto", "data": a})
      categories.push({"label": "Permiso Edif.", "data": p})
      categories.push({"label": "Recep. Munic.", "data": r})
      result.push({"title": "Cantidad de Nuevas Unidades / Bimestre", "series": categories})

      #SUPERFICIE EDIFICADA POR EXPEDIENTE

      categories = []
      a = []
      p = []
      r = []
      m2bimester.last.each do |item|

        item[:values].each do |itm|

          if itm["y_label"] == 'ANTEPROYECTO'
            a.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )
          end
          if itm["y_label"] == 'PERMISO DE EDIFICACION'
            p.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )
          end

          if itm["y_label"] == 'RECEPCION MUNICIPAL'
            r.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )
          end
        end
      end
      categories.push({"label": "Anteproyecto", "data": a})
      categories.push({"label": "Permiso Edif.", "data": p})
      categories.push({"label": "Recep. Munic.", "data": r})
      result.push({"title": "Superficie Edificada Por Expediente", "series": categories })



      #TASAS
      categories=[]
      p = []
      r = []
      rates.each do |item|
        p.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":item[:perm_rate] )
        r.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":item[:recept_rate] )
      end
      categories.push({"label": "Tasa Permiso / Anteproyecto", "data": p})
      categories.push({"label": "Tasa Recepciones / Permisos", "data": r})
      result.push({"title": "Tasas", "series":categories})

    rescue
      result[:data] = ["Sin datos"]
    end

    #file_path = Xls.generate [result], "/xls", {:file_name => "#{Time.now.strftime("%Y-%m-%d_%H.%M")}_expedientes", :clean_directory_path => true}
    #send_file file_path, :type => "application/excel"
    @result = result
    return @result
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
end
