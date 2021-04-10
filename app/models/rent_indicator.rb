class RentIndicator < ApplicationRecord
  include GeometryOptions
  include RentIndicators::Summary

  def self.rent_geo filters
    rent =  Neighborhood.where(
      conditions_by(filters)).
      order(id: :desc)

    factory = RGeo::GeoJSON::EntityFactory.instance
    feature = []
    rent.each do |c|
      vacancy = total_vacancy(c, filters[:bimester], filters[:year])
      price = bots_offer(c, filters[:bimester], filters[:year]).average(:price)
      feature << factory.feature(c.the_geom,nil,{name: c.name, id: c.id, vacancy: (vacancy * 100).to_i, price: "%.1f" % (price.to_f).to_f })
    end

    output_geojson_collection =  RGeo::GeoJSON.encode factory.feature_collection(feature)
  end

  def select_neighboorhood
    b = Neighboorhood.first
  end

  def self.reports_pdf filters
    result = {}
    charts = []
    result['charts'] = charts
    result
  end
end
