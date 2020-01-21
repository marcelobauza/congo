class UserPolygon < ApplicationRecord
  belongs_to :user

  def self.save_polygons_for_user data
    @wkt =  convert_geometry_as_text data
    return if @wkt.nil?
    @wkt.each do |wkt|
      up = UserPolygon.new()
      up.wkt = wkt['wkt']
      up.user_id = data[:user_id]
      up.layertype = data['controller']
      up.save!
    end
  end

  def self.convert_geometry_as_text data
    type_geometry = data[:type_geometry]
    case type_geometry
    when 'circle' 
      radius = data['radius'].to_f / 1000
      @wkt = ActiveRecord::Base.connection.execute("select ST_ASTEXT(st_buffer(ST_GeomFromText('POINT(#{data[:centerpt]})'), #{radius}, 8 )) as wkt")
    when 'polygon'
      polygon = JSON.parse(data[:wkt])
      @wkt = ActiveRecord::Base.connection.execute("select st_astext(st_geomfromGeojson('{\"type\":\"Polygon\", \"coordinates\": #{polygon[0]} }')) as wkt")
    else
      county_id = data[:county_id]
      county = County.find(county_id)
      @wkt=[]
      county.each do |c|
        @wkt.push({"wkt" => c.the_geom.as_text})
      end
    end
    @wkt
  end

  def self.get_csv_data(filters)

    cond = "created_at::date BETWEEN '#{Date.strptime(filters[:date_from], "%d/%m/%Y").to_s}' " 
    cond += "AND '#{Date.strptime(filters[:date_to], "%d/%m/%Y").to_s}'"
    user_polygons = UserPolygon.where(cond)  
     return CsvParser.get_user_polygons_csv_data(user_polygons)
  
  end

  def self.to_csv(options = {})
    desired_column = ['user','date', 'layer', 'wkt', 'company']
    header_names = ['Usuario', 'Fecha', 'Capa', 'Wkt', 'Empresa']

    CSV.generate(options) do |csv|
      csv << header_names
      all.each do |product|
        csv << product.attributes.values_at(*desired_column)
      end
    end
  end
end
