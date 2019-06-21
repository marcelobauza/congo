class ProjectsController < ApplicationController
  def dashboards
  end

 def projects_summary
    begin
      global_information = Project.find_globals(params)
      general_data = [
        {:label => t(:TOTAL_PROJECTS_COUNT), :value => global_information[:project_count]},
        {:label => t(:MIN_SELLING_SPEED), :value => global_information[:min_selling_speed]},
        {:label => t(:MAX_SELLING_SPEED), :value => global_information[:max_selling_speed]},
        {:label => t(:AVG_SELLING_SPEED), :value => global_information[:avg_selling_speed]},
        {:label => t(:TOTAL_STOCK), :value => global_information[:total_units]},
        {:label => t(:SELLS), :value => global_information[:total_sold]},
        {:label => t(:AVAILABLE_STOCK), :value => global_information[:total_stock]},
        {:label => t(:MONTHS_TO_SPEND), :value => global_information[:spend_stock_months]},
        {:label => t(:UF_MIN_VALUE), :value => global_information[:min_uf]},
        {:label => t(:UF_MAX_VALUE), :value => global_information[:max_uf]},
        {:label => t(:UF_AVERAGE), :value => global_information[:avg_uf]},
        {:label => t(:UF_MIN_M2_VALUE), :value => global_information[:min_uf_m2]},
        {:label => t(:UF_MAX_M2_VALUE), :value => global_information[:max_uf_m2]},
        {:label => t(:UF_AVERAGE_M2), :value => global_information[:avg_uf_m2]}
      ]
      pstatus = Project.projects_group_by_count('project_statuses', params, false)
      ptypes = project_type
      pmixes = mix
      avai = availability
      uf_values = uf
      uf_m2_values = uf_m2
      uarea = usable_area
      garea = ground_area
      sbim = sales_bimester
      cfloor = floor
      uf_ranges = Project.projects_by_ranges('uf_avg_percent', params)
      agencies = projects_by_agency

      result =[]
      data =[]
      #GENERAL
      general_data.each do |item|
        data.push("name": item[:label], "count":item[:value].to_i)
      end

    result.push({"title":"Información General", "data": data})

      ##ESTADO PROYECTO

      data =[]
      pstatus.each do |item|
        data.push("name": item.name.capitalize, "count": item.value.to_i, "id":item.id)
      end
      result.push({"title":"Estado del Proyecto", "series":[{"data": data}]})

      ##TIPO PROYECTO
      data =[]

      ptypes.each do |item|
        data.push("name": item.name.capitalize, "count": item.value.to_i, "id":item.id)
      end
      result.push({"title":"Tipo de Propiedad", "series":[{"data": data}]})

      ##MIX
      data =[]

      stock_units =[]
      sold_units =[]
      categories=[]
      pmixes.each do |item|
        stock_units.push("name":item.mix_type, "count": item[:stock_units], "id":item.id)
        sold_units.push("name":item.mix_type, "count": item[:sold_units], "id":item.id)
      end
      categories.push({"label":"Venta Total", "data": sold_units});
      categories.push({"label":"Disponibilidad", "data": stock_units});
      result.push({"title":"Total Distribución por Mix", "series":categories})

      ##OFERTA, VENTA
      total_units=[]
      sold_units=[]
      stock_units=[]
      categories=[]
      avai.each do |item|
        total_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:total_units].to_i)
        sold_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:sold_units].to_i)
        stock_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:stock_units].to_i)
      end
      categories.push({"label":"Oferta", "data": total_units});
      categories.push({"label":"Venta", "data": sold_units});
      categories.push({"label":"Disponibilidad", "data": stock_units});
      result.push({"title":"Oferta, Venta y Disponibilidad por Bimestre", "series":categories})

      ##VALOR UF BIMESTRE
      #result[:data] << [""]
      min =[]
      max =[]
      avg =[]
      categories=[]
      uf_values.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end

      categories.push({"label":"Mínimo", "data": min});
      categories.push({"label":"Máximo", "data": max});
      categories.push({"label":"Promedio", "data": avg});

      result.push({"title":"Valor UF por Bimestre", "series":categories})

      ##VALOR UF/M2 BIMESTRE
      min =[]
      max =[]
      avg =[]
      categories=[]
      uf_m2_values.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end
      categories.push({"label":"Mínimo", "data": min});
      categories.push({"label":"Máximo", "data": max});
      categories.push({"label":"Promedio", "data": avg});

      result.push({"title":"UF/m2 por Bimestre", "series":categories})

      ##SUP UTIL BIMESTRE
      min =[]
      max =[]
      avg =[]
      categories=[]
      uarea.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end
      categories.push({"label":"Mínimo", "data": min});
      categories.push({"label":"Máximo", "data": max});
      categories.push({"label":"Promedio", "data": avg});

      result.push({"title":"Superficie Útil (m2) por Bimestre", "series":categories})

      ##SUP TERR BIMESTRE
      min =[]
      max =[]
      avg =[]
      categories=[]
      #result[:data] << [""]
      #result[:data] << ["Superficie Terreno/Terraza(m2) por Bimestre"]
      #result[:data] << ["Bimestre", "Mínimo", "Máximo", "Promedio"]

      garea.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end
      categories.push({"label":"Mínimo", "data": min});
      categories.push({"label":"Máximo", "data": max});
      categories.push({"label":"Promedio", "data": avg});

      result.push({"title":"Superficie Terreno/Terraza (m2) por Bimestre", "series":categories})

      ##CANT PROYECTOS BIMESTER
      data =[]

      sbim.each do |item|
        data.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:value].to_i)
      end
      result.push({"title":"Cantidad de Proyectos por Bimestre", "series":[{"data": data}]})

      ##CANT PISOS
      data =[]

      cfloor.each do |item|
        data.push("name": (item.min_value.to_i.to_s + " - " + item.max_value.to_i.to_s), "count": item.value.to_i)
      end
      result.push({"title":"Cantidad de Pisos", "series":[{"data": data}]})

      ##UNIDADES POR RANGO UF
      data =[]

      uf_ranges.each do |item|
        data.push("name": (item.min_value.to_i.to_s + " - " + item.max_value.to_i.to_s), "count": item.value.to_i)
      end
      result.push({"title":"Unidades Proyecto por Rango UF", "series":[{"data": data}]})

      data =[]
      agencies.each do |agency|
        data.push("name": agency.name, "id":agency.id)
      end
    result.push({"title": "Inmobiliarias", "data":data})


    rescue
      #result[:data] = ["Sin datos"]
    end
    #file_path = Xls.generate [result], "/xls", {:file_name => "#{Time.now.strftime("%Y-%m-%d_%H.%M")}_residenciales", :clean_directory_path => true}
    #send_file file_path, :type => "application/excel"
    @result = result
    return @result
  end


 def general
    global_information = Project.find_globals(params)

    @general = [
      {:label => t(:TOTAL_PROJECTS_COUNT), :value => NumberFormatter.format(global_information[:project_count], false)},
      {:label => t(:TOTAL_STOCK), :value => NumberFormatter.format(global_information[:total_units], false)},
      {:label => t(:SELLS), :value => NumberFormatter.format(global_information[:total_sold], false)},
      {:label => t(:AVAILABLE_STOCK), :value => NumberFormatter.format(global_information[:total_stock], false)},
      {:label => t(:PP_UTILES), :value => NumberFormatter.format(global_information[:pp_utiles], true)},
      {:label => t(:PP_UF), :value => NumberFormatter.format(global_information[:pp_uf], false)},
      {:label => t(:PP_UF_M2), :value => NumberFormatter.format(global_information[:pp_uf_dis_dpto], true)},
      {:label => t(:PP_UF_M2_C), :value => NumberFormatter.format(global_information[:pp_uf_dis_home], true)},
      {:label => t(:VHMO), :value => NumberFormatter.format(global_information[:vhmo], true)},
      {:label => t(:VHMD), :value => NumberFormatter.format(global_information[:vhmd], true)},
      {:label => t(:MASD), :value => NumberFormatter.format(global_information[:masd], true)}
    ]
    house_general(global_information) unless global_information[:ps_terreno].nil?
    department_general(global_information) unless global_information[:pp_terrace].nil?
  end


  def house_general(global_information)
    #@general << {:label => t(:MIN_M2_FIELD), :value => NumberFormatter.format(global_information[:min_m2_field], true)}
    #@general << {:label => t(:MAX_M2_FIELD), :value => NumberFormatter.format(global_information[:max_m2_field], true)}
    @general << {:label => t(:AVG_M2_FIELD), :value => NumberFormatter.format(global_information[:ps_terreno], true)}
    #@general << {:label => t(:MIN_M2_BUILT), :value => NumberFormatter.format(global_information[:min_m2_built], true)}
    #@general << {:label => t(:MAX_M2_BUILT), :value => NumberFormatter.format(global_information[:max_m2_built], true)}
    #@general << {:label => t(:AVG_M2_BUILT), :value => NumberFormatter.format(global_information[:avg_m2_built], true)}
  end

  def department_general(global_information)
    #@general << {:label => t(:MIN_TERRACE_AREA), :value => NumberFormatter.format(global_information[:min_terrace_square_m2], true)}
    #@general << {:label => t(:MAX_TERRACE_AREA), :value => NumberFormatter.format(global_information[:max_terrace_square_m2], true)}
    @general << {:label => t(:AVG_TERRACE_AREA), :value => NumberFormatter.format(global_information[:pp_terrace], true)}
    #@general << {:label => t(:MIN_USABLE_AREA), :value => NumberFormatter.format(global_information[:min_usable_square_m2], true)}
    #@general << {:label => t(:MAX_USABLE_AREA), :value => NumberFormatter.format(global_information[:max_usable_square_m2], true)}
    #@general << {:label => t(:AVG_USABLE_AREA), :value => NumberFormatter.format(global_information[:avg_usable_square_m2], true)}
  end

  def check
    if !params.has_key? :message or !params.has_key? :id
      render :text => "error"
      return
    end

    project = Project.find(params[:id], :select => "projects.id, projects.code")
    recipients = APP_CONFIG["send_mail"].split(",")

    if project.nil? or current_user.nil?
      render :text => "error"
      return
    end

    layer_data = "<b>" + t(:CHECK_PROJECT_TITLE) + "</b><br/><br/>"
    layer_data += t(:CHECK_PROJECT_CODE) + ": " + project[:code].to_s + "<br/>" unless project[:code].nil?

    Emailer.build_message(t(:CHECK_PROJECT_SUBJECT), recipients, current_user, params[:message], layer_data)
    render :text => "ok"
  end

  def project_status
    @statuses = Project.projects_group_by_count('project_statuses', params, false)

    respond_to do |format|
      format.xml { render :template => "projects/project_status" }
      format.html
      format.json { render :json => @statuses }
    end
  end

  def project_type
    @types = Project.projects_group_by_count('project_types', params, true)
  end

  def availability
    @stock = Project.projects_sum_by_stock(params)
  end

  def usable_area
    @usable_area = Project.projects_by_usable_area(params)
  end

  def floor
    @floor = Project.projects_by_ranges('floors', params)
  end

  def uf_value
    @uf_value = Project.projects_by_ranges('uf_avg_percent', params)

    respond_to do |format|
      format.xml { render :template => "projects/uf_value" }
      format.html
      format.json { render :json => @uf_value }
    end
  end

  def uf
    @uf = Project.projects_by_uf(params)
  end

  def uf_m2
    @uf_m2 = Project.projects_by_uf_m2(params)
  end

  def ground_area
    @ground_area = Project.projects_by_ground_area('ground_area', params)
  end

  def mix
    @mix = Project.projects_group_by_mix('mix', params)
  end

  def sales_bimester
    @sales = Project.projects_count_by_period('sale_bimester', params)
  end

  def period
    @period = Project.get_last_period
    @first_period = Project.get_first_bimester_with_projects

    unless Project.is_periods_distance_allowed?(@first_period, @period.first, @period.size)
      @first_period[:year] = @period.last[:year] unless @period.nil?
      @first_period[:bimester] = @period.last[:bimester] unless @period.nil?
    end
    render json: {data: @period}
  end

  def suggest
    @suggests = ProjectResult.get_search_suggests(params)
  end

  def search
    @updated = ProjectResult.search(params)
  end

  def benchmarking_list
    @bench_projects = ProjectResult.get_benchmarking_project_list(params[:result_id], params[:project_instance_id])
    @current_project = ProjectInstance.find(params[:project_instance_id])
  end

  def benchmarking
    @sales_stock = ProjectInstance.stock_sales_benchmarking(params[:project_ids])
    @historical_sales = ProjectInstance.historical_sales_month_benchmarking(params[:project_ids])

    @usable_square_meters, @usable_avgs = ProjectInstance.usable_square_meters_min_max_avg(params[:project_ids])
    @uf_values, @uf_values_avgs = ProjectInstance.uf_value_min_max_avg(params[:project_ids])
    @uf_m2, @uf_m2_avgs = ProjectInstance.uf_m2_min_max_avg(params[:project_ids])
    @monthly_sales = ProjectInstance.monthly_sales_volume(params[:project_ids])
  end

  def projects_by_agency
    @agencies = Project.projects_group_by_count('agencies', params, false)

    #respond_to do |format|
    #  format.xml { render :template => "projects/projects_by_agency" }
    #  format.html
    #  format.json { render :json => @agencies }
    #end
  end

  def around_pois
    project_id = ProjectInstance.find(params[:id]).project_id

    pois = Poi.get_around_pois(project_id, "projects", params[:wkt])
    render :xml => pois.to_xml(:skip_instruct => true, :skip_types => true, :dasherize => false)
  end

  def transactions_quarter
    filters = build_comparative_params(params)
    @transactions_quarter = Transaction.group_transaction_county_and_quarter(filters)
    render :xml => @transactions_quarter.to_xml(:skip_instruct => true, :skip_types => true, :dasherize => false)
  end

  def average_uf_quarter
    filters = build_comparative_params(params)
    @average_uf_quarter = Transaction.group_transaction_criteria_by_quarter(filters, TransactionsController::AVG_CRITERIA)
  end

  def mixes
    @offer_mix = ProjectInstance.find_offer_mix(params[:project_instance_id])
    @sale_mix = ProjectInstance.find_sale_mix(params[:project_instance_id])
  end

  private

  def build_comparative_params(params)
    params[:seller_type_ids] = Array.new

    if (params.has_key?(:to_year))
      period = Transaction.get_last_period
      params[:to_period] = period[0][:period]
      params[:to_year] = period[0][:year]
    end

    seller_types = SellerType.find(:all, :conditions => "name IN('INMOBILIARIA', 'EMPRESA')")
    seller_types.collect { |item| params[:seller_type_ids] << item.id }
    params
  end
end
