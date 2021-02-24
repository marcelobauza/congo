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
      result.push({"title": "Precio UF", "series": price_uf_by_bimester(neighborhood, bimester, year)})
      result.push({"title": "Precio UFm2", "series": price_ufm2_by_bimester(neighborhood, bimester, year)})
      result.push({"title": "Relación Precios | Vacancia", "series": relation_price_by_vacancy(neighborhood, bimester, year)})
    end

    private

      def brief neighborhood, bimester, year
        data = []
        periods = Period.get_periods(bimester, year, 6, 1).reverse
        projects = RentProject.where(
          "ST_CONTAINS(
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom, 4326))"
        ).where(bimester: bimester, year: year)

        transactions = RentTransaction.where(
          "ST_CONTAINS(
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom, 4326))"
        ).where(conditions(bimester, year))

        bots = bots_offer(neighborhood, bimester, year)

        rent_offer      = (bots.count / 0.9)
        total_vacancy   = total_vacancy(neighborhood, bimester, year)
        total_households = neighborhood.total_houses + neighborhood.total_departments
        avg_u_rent      = bots.average(:surface).to_f
        avg_t_rent      = bots.average(:surface_t).to_f
        avg_u_sale      = transactions.average(:total_surface_building).to_f
        avg_cbr         = transactions.average(:calculated_value).to_i
        avg_price_uf    = bots.average(:price_uf).to_i
        avg_price_uf_m2 = average_price_uf_m2( bots.average(:price_uf).to_f, avg_u_rent.to_f).to_f
        gross_profitability = ((((12 * avg_price_uf) - (total_vacancy * 12 * avg_price_uf)) / avg_cbr.to_i) * 100).to_f
        pxq = ((avg_price_uf * ((total_households * neighborhood.tenure) - rent_offer)) / 1000).to_f

        data.push("name": "Barrio", "count": neighborhood.name)
        data.push("name": "Total Viviendas", "count": total_households )
        data.push("name": "Total Departamentos", "count": neighborhood.total_departments)
        data.push("name": "Tenencia Arriendo", "count": "%1.f" % (total_households * neighborhood.tenure).to_f)
        data.push("name": "Porcentaje de Arriedo", "count": "%.1f" % (neighborhood.tenure * 100).to_f)
        data.push("name": "Oferta de Arriendo" , "count": rent_offer.to_i )
        data.push("name": "Tasa de Vacancia", "count": total_vacancy)
        data.push("name": "Rentabilidad Bruta Anual", "count": ("%.1f" % gross_profitability).to_f)
        data.push("name": "Superficie Útil Oferta Arriendo", "count": ("%.1f" % avg_u_rent).to_f)
        data.push("name": "Superficie Útil Compraventas ", "count": ("%.1f" % avg_u_sale).to_f)
        data.push("name": "Superficie Terraza Oferta Arriendo", "count": ("%.1f" % (avg_t_rent - avg_u_rent).to_f))
        data.push("name": "Precio Compraventas | UF", "count": avg_cbr.to_i)
        data.push("name": "Precio Oferta Arriendo | UF mensual", "count":("%.1f" % avg_price_uf).to_f)
        data.push("name": "Precio Oferta Arriendo | UFm2 mensual", "count":("%.2f" % avg_price_uf_m2).to_f)
        data.push("name": "PxQ Mensual | UF miles", "count": pxq)

        data
      end

      def bots_offer neighborhood, bimester, year
        Bot.where(
          "ST_CONTAINS(
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom, 4326))"
        ).where(bimester: bimester, year: year, properties: 'Departamento')
      end

      def total_vacancy neighborhood, bimester, year
        future_projects = RentFutureProject.where(
          "ST_CONTAINS(
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom, 4326))"
        ).where('year >= ?', 2017).sum(:total_units)

        rent_department = (neighborhood.total_departments.to_i + future_projects.to_i) * neighborhood.tenure.to_f
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
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom, 4326))"
        ).where(bimester: bimester, year: year)

        mix_types = projects.group_by { |s| "#{s.bedroom.to_i + s.half_bedroom.to_i}|#{s.bathroom}"}
        data      = []

        mix_types.map do |key, mix|
          data.push("name": key, "count": mix.size)
        end
        data_bots = []
        bots = bots_offer(neighborhood, bimester, year)

        bots_mix_types = bots.group_by { |mt| "#{mt.bedroom.to_i}|#{mt.bathroom}" }

        bots_mix_types.map do |key, mix|
          data_bots.push("name": key, "count": mix.size)
        end

        series = [{
          "label": "Parque",
          "data": data
        },{
          "label": "Oferta",
          "data": data_bots
        }
        ]
      end

      def surface neighborhood, bimester, year
        periods = Period.get_periods(bimester, year, 6, 1).reverse
        data     = []
        data_cbr = []
        periods.each do |p|
          bots = bots_offer(neighborhood, p[:period], p[:year]).average(:surface)

          data.push("name": "#{p[:period]}/#{p[:year]}", "count": ("%.1f" % bots.to_f).to_f )

          transactions = RentTransaction.where(
            "ST_CONTAINS(
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom,4326))"
          ).where(bimester: p[:period], year: p[:year]).average(:total_surface_building)

          data_cbr.push("name":"#{p[:period]}/#{p[:year]}", "count": ("%.1f" % transactions.to_f).to_f)
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

          data.push("name": "#{p[:period]}/#{p[:year]}", "count": bots.to_i )

          transactions = RentTransaction.where(
            "ST_CONTAINS(
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom, 4326))"
          ).
          where(bimester: p[:period], year: p[:year]).average(:calculated_value)

          data_cbr.push("name":"#{p[:period]}/#{p[:year]}", "count": transactions.to_i)
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

          data.push("name": "#{p[:period]}/#{p[:year]}", "count": bots.avg_uf_m2.to_f)

          transactions = RentTransaction.where(
            "ST_CONTAINS(
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom, 4326))"
          ).
          where(
            bimester: p[:period], year: p[:year]
          )

          avg_t_surface_building = transactions.average(:total_surface_building).to_f
          t_avg_uf_m2            =  avg_t_surface_building > 0 ? (transactions.average(:calculated_value) / avg_t_surface_building).to_f : 0

         avg_uf_m2 = data_cbr.push("name":"#{p[:period]}/#{p[:year]}", "count": t_avg_uf_m2.to_f)
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
        data_profitability = []

        transactions = RentTransaction.where(
          "ST_CONTAINS(
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom, 4326))"
        ).where(conditions(bimester, year))


        bots = bots_offer(neighborhood, bimester, year)

        avg_price_uf    = bots.average(:price_uf).to_i
        avg_cbr         = transactions.average(:calculated_value).to_i


        periods.each do |p|
          result = total_vacancy(neighborhood, p[:period], p[:year])
          data.push("name": "#{p[:period]}/#{p[:year]}", "count": result.to_f )


          gross_profitability = (((((12 * avg_price_uf) - (result * 12 * avg_price_uf)) / avg_cbr.to_i)) * 100).to_i
          data_profitability.push("name": "#{p[:period]}/#{p[:year]}", "count": gross_profitability)
        end

        series = [
          {
            "label": "Arriendo",
            "data": data_profitability
          },
          {
            "label": "Vacancia",
            "data": data
          },
        ]
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
