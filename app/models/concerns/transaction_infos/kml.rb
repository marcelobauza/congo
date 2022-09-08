module Transactions::Kml
  extend ActiveSupport::Concern

  module ClassMethods
    def kml_data filters
      data    = reports(filters)
      kml      = KMLFile.new
      document = KML::Document.new(name: "CBR")

      data.each do |d|
        document.features << KML::Placemark.new(
          name: d.address,
          description: "Uso: #{d.code_destination}
                        Fecha: #{d.inscription_date}
                        UF: #{d.calculated_value}
                        Util: #{d.uf_m2_u}
                        Terreno: #{d.total_surface_terrain}}",
          geometry: KML::Point.new(
            coordinates: {lat: d.the_geom.y, lng: d.the_geom.x})
        )
      end

      kml.objects << document
      kml.render
    end
  end
end
