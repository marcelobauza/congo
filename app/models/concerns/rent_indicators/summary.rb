module RentIndicators::Summary
  extend ActiveSupport::Concern

  module ClassMethods

    def summary params
      data   = []
      result = []

      neighborhood = Neighborhood.find(params[:id])

      projects = RentProject.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      ).
      where(bimester: 1, year: params[:to_year])

      transactions = Transaction.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      ).
      where(bimester: 1, year: params[:to_year])

      future_projects = FutureProject.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      ).
      where(bimester: params[:period], year: params[:to_year])

      bots = Bot.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      ).
      where(bimester: params[:period], year: params[:to_year])

      rent_offer = (bots.count / 0.9)
      rent_department = (neighborhood.total_departments.to_i + future_projects.count) * neighborhood.tenure
      total_vacancy = rent_department.to_f / rent_offer.to_f
      avg_u_rent = bots.average(:surface)
      avg_u_sale = transactions.average(:total_surface_building)
      avg_cbr = transactions.average(:calculated_value)
      avg_price_uf = bots.average(:price_uf)
      avg_price_uf_m2 = bots.average(:price_uf).to_f / avg_u_rent.to_f

      data.push("name": "Total Viviendas", "count": neighborhood.total_houses)
      data.push("name": "Total Departamentos", "count": neighborhood.total_departments)
      data.push("name": "Tenencia de Arriedo", "count": neighborhood.tenure)
      data.push("name": "Oferta de Arriendo" , "count": rent_offer.to_i )
      data.push("name": "Tasa de Vacancia", "count": total_vacancy.to_f)
      data.push("name": "Rentabilidad Bruta Anual", "count": 4)
      data.push("name": "Superficie Util Oferta Arriendo", "count": avg_u_rent.to_f)
      data.push("name": "Superficie Util Compraventas ", "count": avg_u_sale.to_f)
      data.push("name": "Superficie Terraza Oferta Arriendo", "count": 4)
      data.push("name": "Precio Compraventas | UF", "count": avg_cbr.to_f)
      data.push("name": "Precio Oferta Arriendo | UF mensual", "count": avg_price_uf.to_f)
      data.push("name": "Precio Oferta Arriendo | UFm2 mensual", "count": avg_price_uf_m2.to_f)
      data.push("name": "PxQ mensual | UF miles", "count": 4)

      result.push({"title": "Resumen Bimestre", data: data})
      result.push({"title": "Distribución Programas", "series": distribution_by_mix_types(projects)})
      result.push({"title": "Superficie", "series": surface(bots)})
      result.push({"title": "Precio UF mes", "series": price_uf_by_bimester(bots)})
      result.push({"title": "UFm2 mes", "series": price_uf_by_bimester(bots)})
      result.push({"title": "Relación Precios | Vacancia", "series": relation_price_by_vacancy(bots)})
    end

    private
    def distribution_by_mix_types projects
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

    def surface bots
      avg  = bots.average(:price_uf).to_f
      data = []

      data.push("name": "6/20", "count": avg.to_f )

      series = [{
        "label": "Arriendo",
        "data": data
      }]
    end

    def price_uf_by_bimester bots
      avg  = bots.average(:price_uf).to_f
      data = []

      data.push("name": "6/20", "count": avg.to_f)

      series = [{
        "label": "Arriendo",
        "data": data
      }]

    end

    def price_ufm2_by_bimester bots
      avg  = bots.average(:price_uf).to_f
      data = []

      data.push("name": "6/20", "count": avg.to_f )

      series = [{
        "label": "Arriendo",
        "data": data
      }]
    end

    def relation_price_by_vacancy bots
      avg  = bots.average(:price_uf).to_f
      data = []

      data.push("name": "6/20", "count": avg.to_f )

      series = [{
        "label": "Arriendo",
        "data": data
      }]
    end
  end
end
