module ProjectsHelper
  def sale_period d
    @area     ||= {}
    area_name = d['area_name']
    vp        = 0

    if @area.include? area_name
      vp                  = @area[area_name][:sale_period] - d['availability']
      @area[area_name]    = { sale_period: d['availability'], availability: vp }
    else
      @area[area_name]    = { sale_period: d['availability'], availability: d['availability'] }
      vp                  = d['availability']
    end

    vp
  end

  def sale_anual d
    year      = d['year']
    bimester  = d['bimester']
    area_name = d['area_name']

    sale_anual = Project.projects_by_parcel(year, bimester, area_name) - d['availability']

    @area[area_name].merge!({ sale_anual: sale_anual })

    sale_anual
  end

  def vvm d
    area_name = d['area_name']

    if @area.include? area_name
      (@area[area_name][:availability] / 2)
    end
  end

  def vvma d
    area_name = d['area_name']

    if @area.include? area_name
      (@area[area_name][:sale_anual] / 12)
    end

  end

  def mas d
    area_name = d['area_name']

    if @area.include? area_name
      vvm =  (@area[area_name][:availability] / 2 ).to_f

      (vvm / @area[area_name][:availability])
    end
  end

  def masa d
    area_name = d['area_name']

    if @area.include? area_name
      vvm =  (@area[area_name][:sale_anual] / 12 ).to_f

      (vvm / @area[area_name][:sale_anual])
    end
  end
end
