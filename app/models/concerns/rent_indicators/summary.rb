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
      where(bimester: 1, year: params[:to_year])

      bots = Bot.where(
        "ST_CONTAINS(
          ST_GEOMFROMTEXT('#{neighborhood.the_geom}',4326), the_geom)"
      )

      rent_offer = (bots.count / 0.9)
      rent_department = (neighborhood.total_departments.to_i + future_projects.count) * neighborhood.tenure
      total_vacancy = rent_department / rent_offer
      avg_u_rent = bots.average(:surface)
      avg_u_sale = transactions.average(:total_surface_building)
      avg_cbr = transactions.average(:calculated_value)
      avg_price_uf = bots.average(:price_uf)
      avg_price_uf_m2 = bots.average(:price_uf) / avg_u_rent

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

      result.push("title": "Resumen Bimestre", data: data)
      result
    end
  end
end
