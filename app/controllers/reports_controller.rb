class ReportsController < ApplicationController
  def future_projects_data
    filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @xl = FutureProject.reports(filters)
    respond_to do |format|
      format.xlsx 
    end
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
      @dd = data
      if (data[:title] == 'Información General') 
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
      if (data[:title] == 'Tipo de Destino Pie' )
        data[:series][0][:data].each do |td|
          @tipo_destino.push([td[:name], td[:count]])
        end
      end
      if (data[:title] == 'Tipo de Destino Bar' )
        data[:series].each do |td|
          @data_destino_bar=[]
          td[:data].each do |tdb|
            @data_destino_bar.push([tdb[:name], tdb[:count]])
          end
          @tipo_destino_bar.push({"#{td[:label]}":@data_destino_bar})
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
    @ub = result

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
      format.xlsx 
    end

  end
end
