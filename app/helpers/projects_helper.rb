module ProjectsHelper
  def sale_period d
    @area     ||= {}
    area_name = d['area_name']
    vp        = 0

    if @area.include? area_name
      vp                  = @area[area_name][:availability].to_i - d['availability'].to_i
      @area[area_name]    = { sale_period: d['availability'].to_i, availability: vp }
    else
      @area[area_name]    = { sale_period: d['availability'].to_i, availability: d['availability'].to_i }
      vp                  = d['availability'].to_i
    end

    vp
  end

  def sale_anual d
    year      = d['year']
    bimester  = d['bimester']
    area_name = d['area_name']

    sale_anual = Project.projects_by_parcel(year, bimester, area_name) - d['availability'].to_i

    @area[area_name].merge!({ sale_anual: sale_anual })

    sale_anual
  end

  def vvm d
    area_name = d['area_name']

    if @area.include? area_name
      (@area[area_name][:availability] / 2).to_f
    end
  end

  def vvma d
    area_name = d['area_name']

    if @area.include? area_name
      (@area[area_name][:sale_anual] / 12).to_f
    end

  end

  def mas d
    area_name = d['area_name']

    if @area.include? area_name
      vvm =  (@area[area_name][:availability] / 2 ).to_f
      (vvm / @area[area_name][:availability]).to_f
    end
  end

  def masa d
    area_name = d['area_name']

    if @area.include? area_name
      vvm =  (@area[area_name][:sale_anual] / 12 ).to_f

      (vvm / @area[area_name][:sale_anual]).to_f
    end
  end
end
