class ReportsController < ApplicationController

  def future_projects_data
    filters                 = JSON.parse(session[:data].to_json, {:symbolize_names => true})
    data                    = FutureProject.reports(filters)
    total_downloads_allowed = current_user.company.future_projects_downloads || 0
    months                  = current_user.role.plan_validity_months
    layer                   = 'future_projects'

    ActiveRecord::Base.transaction do
      if months > 0
        allowed_downloads_by_plans layer, total_downloads_allowed, data
      else
        total_accumulated_downloads = current_user.downloads_users.where('created_at::date = ?', Date.today).sum(:future_projects)

        limit_downloads total_downloads_allowed, total_accumulated_downloads, data, layer
      end
    end

    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Datos_ExpedientesMunicipales.xlsx"'
      }
    end
  end

  def future_projects_data_kml
    filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @xl = FutureProject.kml_data(filters)
    send_data @xl,
          :type => 'text/xml; charset=UTF-8;',
              :disposition => "attachment; filename=Datos_ExpedientesMunicipales.kml"
  end

  def future_projects_summary
    filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @xl2 = FutureProject.summary(filters)
    @info=[]
    @tipo_expediente=[]
    @tipo_destino=[]
    @tipo_destino_bar=[]
    @title = []

    @xl2.each do |data|
      if (data[:title] == 'Resumen')
        @info=[]
        data[:data].each do |v|
          @vv = v
          @info.push([v[:name], v[:count]])
        end
      end
      if (data[:title] == 'Tipo de Expendiente' )
        data[:series][0][:data].each do |tp|
          @tipo_expediente.push([tp[:name], tp[:count]])
        end
      end
      if (data[:title] == 'Destino Obra' )
        data[:series][0][:data].each do |td|
          @tipo_destino.push([td[:name], td[:count]])
        end
      end
      if (data[:title] == 'Tipo de Expediente / Destino' )
        data[:series].each do |td|
          @data_destino_bar=[]
          td[:data].each do |tdb|
            @data_destino_bar.push([tdb[:name], tdb[:count]]) if tdb[:count] > 0
          end
          @tipo_destino_bar.push({"#{td[:label]}":@data_destino_bar}) if @data_destino_bar.any?
        end
      end
    end
    result =[]
    @ubimester = FutureProject.future_projects_by_period("COUNT", "unit_bimester",filters)

    result.push(["Bimestre", "Anteproyecto", "Permiso edificacion", "Recepcion Municipal"])

    @ubimester.last.each do |item|
      value_1 = item[:values].first["y_value"].to_i rescue 0
      value_2 = item[:values][1]["y_value"].to_i rescue 0
      value_3 = item[:values].last["y_value"].to_i rescue 0
      result.push([(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), value_1, value_2, value_3])
    end
    @ubc = result

    result =[]
    @built_bimester = FutureProject.future_projects_by_period("SUM", "m2_built_bimester", filters)
    result.push(["Bimestre", "Anteproyecto", "Permiso edificacion", "Recepcion Municipal"])
    @built_bimester.last.each do |item|
      value_1 = item[:values].first["y_value"].to_i rescue 0
      value_2 = item[:values][1]["y_value"].to_i rescue 0
      value_3 = item[:values].last["y_value"].to_i rescue 0

      result.push([(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), value_1, value_2, value_3])
    end
    @bb = result

    result =[]
    @projects = FutureProject.future_project_rates("future_project_rates", filters)
    @projects.each do |item|
      result.push([(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), item[:perm_rate].to_f, item[:recept_rate].to_f])
    end
    @rates = result
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Resumen_ExpedientesMunicipales.xlsx"'
      }
    end
  end

  def transactions_data_kml
    filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @xl = Transaction.kml_data(filters)
    send_data @xl,
          :type => 'text/xml; charset=UTF-8;',
              :disposition => "attachment; filename=Datos_Compraventas.kml"
  end

  def transactions_data
    filters                 = JSON.parse(session[:data].to_json, {:symbolize_names => true})
    filters[:user_id]       = current_user.id
    data                    = Transaction.reports(filters)
    total_downloads_allowed = current_user.company.transactions_downloads || 0
    months                  = current_user.role.plan_validity_months
    layer                   = 'transactions'

    ActiveRecord::Base.transaction do
      if months > 0
        allowed_downloads_by_plans layer, total_downloads_allowed, data
      else
        total_accumulated_downloads = current_user.downloads_users.where('created_at::date = ?', Date.today).sum(layer.to_sym)

        limit_downloads total_downloads_allowed, total_accumulated_downloads, data, layer
      end
    end

    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Datos_Compraventas.xlsx"'
      }
    end
  end

  def transactions_summary
    filters           = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    filters[:user_id] = current_user.id
    @transaction = Transaction.summary(filters)
    @info=[]
    @ptypes=[]
    @seller=[]
    @uf_periods=[]
    @average_uf_periods=[]
    @transactions_ufs=[]
    @transaction_bimester=[]

    @transactions_by_periods = Transaction.group_transaction_bimester(filters)

      @transactions_by_periods.map do |tt|
        if tt.any?
          @transaction_bimester.push([tt[0][:periods],tt[0][:value]])
        end
      end

    @transaction.each do |data|
      @ddy = data[:title]
      @dd = data
      if data[:title] == "Información General"
        data[:data].each do |d|
            @info.push([d[:name], d[:count]])
        end
      end

      if data[:title] == "Uso"
        data[:series][0][:data].each do |pt|
            @ptypes.push([pt[:name], pt[:count]])
        end
      end
      if data[:title] == "Vendedor"
        data[:series][0][:data].each do |s|
            @seller.push([s[:name], s[:count]])
        end
      end

      if data[:title] == "PxQ | UF"
        data[:series][0][:data].each do |s|
            @uf_periods.push([s[:name], s[:count]])
        end
      end
      if data[:title] == "Precio Promedio | UF"
        data[:series][0][:data].each do |s|
            @average_uf_periods.push([s[:name], s[:count]])
        end
      end
      if data[:title] == "Compraventas por Rango Precio"
        data[:series][0][:data].each do |s|
            @transactions_ufs.push([s[:name], s[:count]])
        end
      end

    end
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Resumen_Compraventas.xlsx"'
      }
    end
  end

  def projects_data
    filters                 = JSON.parse(session[:data].to_json, {:symbolize_names => true})
    total_downloads_allowed = current_user.company.projects_downloads || 0
    months                  = current_user.role.plan_validity_months
    layer                   = 'projects'
    @data                   = []

    (@project_homes, @project_departments = Project.reports(filters)).each do |project|
      codes = []
      data  = project

      codes << project.map(&:code).uniq if project.present?

      ActiveRecord::Base.transaction do
        if months > 0
          allowed_downloads_by_plans(layer, total_downloads_allowed, data, count: codes.count)
          @data << @xl
        else
          total_accumulated_downloads = current_user.downloads_users.where('created_at::date = ?', Date.today).sum(:projects)

        @data << limit_downloads(total_downloads_allowed, total_accumulated_downloads, data, layer)
        end
      end
    end

    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Datos_ProyectosEnVenta.xlsx"'
      }
    end
  end

  def projects_data_kml
    filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @xl = Project.kml_data(filters)
    send_data @xl,
          :type => 'text/xml; charset=UTF-8;',
          :disposition => "attachment; filename=Datos_ProyectosEnVenta.kml"
  end

  def projects_summary
    filters   = JSON.parse(session[:data].to_json, {:symbolize_names => true})
    @summary  = Project.summary filters
    @info     = []
    @pstatus  = []
    @ptypes   = []
    @agencies = []

    @summary.each do |data|
      if (data[:title] == 'Resumen')
        data[:data].each do |v|
          @info.push([v[:name], v[:count]])
        end
      end

      if (data[:title]== 'Estado Obra')
        data[:series][0][:data].each do |v|
          @pstatus.push([v[:name], v[:count]])
        end
      end

      if (data[:title]== 'Uso')
        data[:series][0][:data].each do |v|
          @ptypes.push([v[:name], v[:count]])
        end
      end

      if data[:title] == 'Proyectos por Inmobiliaria'
        data[:data].map do |v|
          @agencies.push([v[:name]])
        end
      end
    end

      result=[]
      pmixes = Project.projects_group_by_mix('mix', filters, false)

    pmixes.each do |item|
      value_1 = item[:mix_type]
      value_2 = item[:stock_units]
      value_3 = item[:sold_units]
      result.push({"mix_type":value_1, "stock_units":value_2, "sold_units":value_3 })
    end
    @pm = result

      result =[]
      avai = Project.projects_sum_by_stock(filters)
      avai.each do |av|
      total_units = av[:total_units].to_i rescue 0
      sold_units = av[:sold_units].to_i rescue 0
      stock_units = av[:stock_units].to_i rescue 0
      bimester = av[:bimester].to_s + "/" + av[:year].to_s[2,3]

      result.push({"bimester":bimester, "total_units":total_units, "sold_units":sold_units, "stock_units":stock_units})

      end
    @avai = result


    result =[]
   uf_values = Project.projects_by_uf(filters)

   uf_values.each do |ufb|
      max = ufb[:max].to_i rescue 0
      min = ufb[:min].to_i rescue 0
      avg = ufb[:avg].to_i rescue 0
      bimester = ufb[:bimester].to_s + "/" + ufb[:year].to_s[2,3]
      result.push({"bimester":bimester,"max":max, "min":min,"avg":avg})
   end
@ufb=result
    result =[]
   ufm2_values = Project.projects_by_uf_m2(filters)

   ufm2_values.each do |ufb|
      max = ufb[:max].to_f rescue 0
      min = ufb[:min].to_f rescue 0
      avg = ufb[:avg].to_f rescue 0
      bimester = ufb[:bimester].to_s + "/" + ufb[:year].to_s[2,3]
      result.push({"bimester":bimester,"max":max, "min":min,"avg":avg})
   end
@ufm2b=result

    result =[]
   sup_area = Project.projects_by_usable_area(filters)

   sup_area.each do |su|
      max = su[:max].to_i rescue 0
      min = su[:min].to_i rescue 0
      avg = su[:avg].to_i rescue 0
      bimester = su[:bimester].to_s + "/" + su[:year].to_s[2,3]
      result.push({"bimester":bimester,"max":max, "min":min,"avg":avg})
   end
@sup_u_m2=result


    result =[]
   ground_area = Project.projects_by_ground_area('ground_area',filters)

   if ground_area
     ground_area.each do |st|
       max = st[:max].to_i rescue 0
       min = st[:min].to_i rescue 0
       avg = st[:avg].to_i rescue 0
       bimester = st[:bimester].to_s + "/" + st[:year].to_s[2,3]
       result.push({"bimester":bimester,"max":max, "min":min,"avg":avg})
     end

     @ground_area=result
   end
      result =[]
      sbim = Project.projects_count_by_period('sale_bimester', filters)
    sbim.each do |sb|
      total_units = sb[:value]
      bimester = sb[:bimester].to_s + "/" + sb[:year].to_s[2,3]
      result.push("bimester":bimester, "total_units":total_units)
    end
@total_projects_bimester = result

    result =[]
    cfloor = Project.projects_by_ranges('floors', filters)
    cfloor.each do |cf|
      name = cf[:min_value].to_s + " - " + cf[:max_value].to_s
      value = cf[:value].to_i rescue 0
    result.push({"name":name, "value":value})
    end

    @floor = result

    result =[]
    uf_range = Project.projects_by_ranges('uf_avg_percent', filters)
    uf_range.each do |ufr|
      name = ufr[:min_value].to_s + " - " + ufr[:max_value].to_s
      value = ufr[:value].to_i rescue 0
    result.push({"name":name, "value":value})
    end
    @range = result

    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Resumen_ProyectosEnVenta.xlsx"'
      }
    end

  end

  def projects_pdf
    filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @pdf = Project.reports_pdf filters

    render json: {"data":@pdf}
  end

  def rent_indicators_pdf
    filters = JSON.parse(session[:data].to_json, {:symbolize_names => true})
    @pdf    = RentIndicator.reports_pdf filters

    render json: @pdf
  end

  def transactions_pdf
    filters = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @pdf    = Transaction.reports_pdf filters

    render json: { "data":@pdf }
  end

  def building_regulations_pdf
    filters = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @data   = BuildingRegulation.reports_pdf filters
  end

  def building_regulations_kml
    filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @data = BuildingRegulation.kml_data filters
    send_data @data,
          :type => 'text/xml; charset=UTF-8;',
          :disposition => "attachment; filename=Datos_Normativa.kml"
  end

  def rent_indicators_summary
    filters          = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @rent_indicators = RentIndicator.summary filters

    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Resumen_ArriendoResidencial.xlsx"'
      }
    end
  end

  private

    def limit_downloads total_downloads_allowed, total_accumulated_downloads, data, layer, count: nil
      total_downloads = total_downloads_allowed - total_accumulated_downloads

      if total_downloads > 0
				limit = if count
					count <= total_downloads ? data.count : total_downloads
				else
        	data.count <= total_downloads ? data.count : total_downloads
				end

        @xl = data.limit(limit)

        current_user.downloads_users.create! "#{layer}": limit
      else
        @message = "Ha superado el límite de descarga"
      end
    end

    def allowed_downloads_by_plans layer, total_downloads_allowed, data, count: nil
      from_date         = current_user.company.enabled_date
      to_date           = from_date + current_user.role.plan_validity_months.months
      allowed_downloads = (from_date..to_date).include? Date.today

      if allowed_downloads
        total_accumulated_downloads = User.accumulated_download_by_company current_user.id, layer

        limit_downloads total_downloads_allowed, total_accumulated_downloads, data, layer, count: nil
      else
        @message = "No tiene plan permitido"
      end
    end
end
