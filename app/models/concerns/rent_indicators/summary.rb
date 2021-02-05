module RentIndicators::Summary
  extend ActiveSupport::Concern

  module ClassMethods
    def summary params
      data     = []
      result   = []
      year     = params[:to_year].to_i
      bimester = params[:to_period].to_i

      neighborhood = Neighborhood.find(params[:id])

      result.push({"title": "Resumen Bimestre", data: brief(neighborhood, bimester, year)})
      result.push({"title": "Distribución Programas", "series": distribution_by_mix_types(neighborhood, bimester, year)})
      result.push({"title": "Superficie", "series": surface(neighborhood, bimester, year)})
      result.push({"title": "Precio UF mes", "series": price_uf_by_bimester(neighborhood, bimester, year)})
      result.push({"title": "UFm2 mes", "series": price_ufm2_by_bimester(neighborhood, bimester, year)})
      result.push({"title": "Relación Precios | Vacancia", "series": relation_price_by_vacancy(neighborhood, bimester, year)})
    end

    private
    def brief neighborhood, bimester, year
      data = []
      periods = Period.get_periods(bimester, year, 6, 1).reverse
      projects = RentProject.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      ).where(bimester: bimester, year: year)

      transactions = RentTransaction.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      ).where(conditions(bimester, year))

      bots = bots_offer(neighborhood, bimester, year)

      rent_offer      = (bots.count / 0.9)
      total_vacancy   = total_vacancy(neighborhood, bimester, year)
      total_households = neighborhood.total_houses + neighborhood.total_departments
      avg_u_rent      = bots.average(:surface)
      avg_u_sale      = transactions.average(:total_surface_building)
      avg_cbr         = transactions.average(:calculated_value)
      avg_price_uf    = bots.average(:price_uf)
      avg_price_uf_m2 = average_price_uf_m2( bots.average(:price_uf).to_f, avg_u_rent.to_f)
      gross_profitability = (((12 * avg_price_uf) - (total_vacancy * 12 * avg_price_uf)) / avg_cbr)* 100

      data.push("name": "Barrio", "count": neighborhood.name)
      data.push("name": "Total Viviendas", "count": total_households )
      data.push("name": "Total Departamentos", "count": neighborhood.total_departments)
      data.push("name": "Tenencia Arriedo", "count": total_households * neighborhood.tenure)
      data.push("name": "Porcentaje de Arriedo", "count": neighborhood.tenure)
      data.push("name": "Oferta de Arriendo" , "count": rent_offer.to_i )
      data.push("name": "Tasa de Vacancia", "count": total_vacancy)
      data.push("name": "Rentabilidad Bruta Anual", "count": ("%.1f" % gross_profitability).to_f)
      data.push("name": "Superficie Util Oferta Arriendo", "count": ("%.1f" % avg_u_rent).to_f)
      data.push("name": "Superficie Util Compraventas ", "count": ("%.1f" % avg_u_sale).to_f)
      data.push("name": "Superficie Terraza Oferta Arriendo", "count": 4)
      data.push("name": "Precio Compraventas | UF", "count": avg_cbr.to_i)
      data.push("name": "Precio Oferta Arriendo | UF mensual", "count":("%.1f" % avg_price_uf).to_f)
      data.push("name": "Precio Oferta Arriendo | UFm2 mensual", "count":("%.2f" % avg_price_uf_m2).to_f)
      data.push("name": "PxQ mensual | UF miles", "count": 4)

      data
    end

    def bots_offer neighborhood, bimester, year
      Bot.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      ).where(bimester: bimester, year: year, properties: 'Departamento')
    end

    def total_vacancy neighborhood, bimester, year
      future_projects = RentFutureProject.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      ).where('year >= ?', 2017).sum(:total_units)

      rent_department = (neighborhood.total_departments.to_i + future_projects.to_i) * neighborhood.tenure
      bots            = bots_offer(neighborhood, bimester, year)
      rent_offer      = (bots.count / 0.9)

      return 0 if (rent_department == 0 || rent_offer == 0)
      rent_offer.to_f / rent_department.to_f
    end

    def average_price_uf_m2 avg_price_uf, avg_u_rent
      return 0 if avg_price_uf == 0 || avg_u_rent == 0
      avg_price_uf / avg_u_rent
    end

    def distribution_by_mix_types neighborhood, bimester, year
      projects = RentProject.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      ).where(bimester: bimester, year: year)

      mix_types = projects.group_by { |s| "#{s.bedroom}.#{s.half_bedroom}|#{s.bathroom}"}
      data      = []

      mix_types.map do |key, mix|
        data.push("name": key, "count": mix.size)
      end

      series = [{
        "label": "Parque",
        "data": data
      }]
    end

    def surface neighborhood, bimester, year
      periods = Period.get_periods(bimester, year, 6, 1).reverse
      data     = []
      data_cbr = []
      periods.each do |p|
        bots = bots_offer(neighborhood, p[:period], p[:year]).average(:surface)

        data.push("name": "#{p[:period]}/#{p[:year]}", "count": bots.to_f )

        transactions = RentTransaction.where(
          "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
        ).where(bimester: p[:period], year: p[:year]).average(:total_surface_building)
        data_cbr.push("name":"#{p[:period]}/#{p[:year]}", "count": transactions.to_f)
      end

      series = [{
        "label": "Arriendo",
        "data": data
      },
      {
        "label": "Venta",
        "data": data_cbr
      }]
    end

    def price_uf_by_bimester neighborhood, bimester, year
      periods = Period.get_periods(bimester, year, 6, 1).reverse
      data     = []
      data_cbr = []
      periods.each do |p|
        bots = bots_offer(neighborhood, p[:period], p[:year]).average(:price_uf)

        data.push("name": "#{p[:period]}/#{p[:year]}", "count": bots.to_f )

        transactions = RentTransaction.where(
          "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
        ).
        where(bimester: p[:period], year: p[:year]).average(:calculated_value)

        data_cbr.push("name":"#{p[:period]}/#{p[:year]}", "count": transactions.to_f)
      end

      series = [{
        "label": "Arriendo",
        "data": data
      },
      {
        "label": "Venta",
        "data": data_cbr
      }]
    end

    def price_ufm2_by_bimester neighborhood, bimester, year
      periods = Period.get_periods(bimester, year, 6, 1).reverse
      data     = []
      data_cbr = []
      periods.each do |p|
        bots = bots_offer(neighborhood, p[:period], p[:year]).select('avg(price_uf) / avg(surface) as avg_uf_m2').take

        data.push("name": "#{p[:period]}/#{p[:year]}", "count": bots.avg_uf_m2.to_f )

        transactions = RentTransaction.where(
          "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
        ).
        where(
          bimester: p[:period], year: p[:year]
        ).select(
          'avg(calculated_value) / avg(total_surface_building) as avg_uf_m2'
        ).take

        data_cbr.push("name":"#{p[:period]}/#{p[:year]}", "count": transactions.avg_uf_m2.to_f)
      end

      series = [{
        "label": "Arriendo",
        "data": data
      },
      {
        "label": "Venta",
        "data": data_cbr
      }]
    end

    def relation_price_by_vacancy neighborhood, bimester,year
      periods = Period.get_periods(bimester, year, 6, 1).reverse
      data = []

      periods.each do |p|
        result = total_vacancy(neighborhood, p[:period], p[:year])
        data.push("name": "#{p[:period]}/#{p[:year]}", "count": result.to_f )
      end
      series = [{
        "label": "Arriendo/Venta",
        "data": data
      }]
    end

    def conditions bimester, year
      ors = []
      periods = Period.get_periods(bimester, year, 6, 1)
      periods.each do |p|
        ors << get_periods_query_new(p[:period], p[:year])
      end
      ors.join(' OR ')
    end

    def get_periods_query_new(period, year)
      conditions = "("
      conditions += WhereBuilder.build_equal_condition('bimester', period)
      conditions += Util.and
        conditions += WhereBuilder.build_equal_condition('year', year)
      conditions += ")"
    end
  end
end
