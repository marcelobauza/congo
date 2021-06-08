class BuildingRegulation < ApplicationRecord
  belongs_to :density_type
  belongs_to :county
  has_many :building_regulation_land_use_types
  has_many :land_use_types, through: :building_regulation_land_use_types

  validates_presence_of :county_id

  def self.save_filter_polygon f
    UserPolygon.save_polygons_for_user f
  end

  def self.get_density_types
    BuildingRegulation.select("density_i as density").
      group("density_i").
      order("density_i")
  end

  def self.group_by_constructivity filters
    find_by_columns_range(filters, "icinciti")
  end

  def self.group_by_land_ocupation filters
    find_by_columns_range(filters, 'osinciti')
  end

  def self.group_by_maximum_height filters
    find_by_columns_range(filters, 'aminciti')
  end

  def self.group_by_hectarea_inhabitants filters
    find_by_columns_range(filters, 'hectarea_inhabitants')
  end

  def self.find_by_columns_range filters, column
    BuildingRegulation.select("min(#{column}), max(#{column})").
      where(build_interval_conditions(filters)).take
  end

  def self.build_interval_conditions(filters)
    if !filters[:county_id].nil?
      cond = WhereBuilder.build_in_condition("county_id",filters[:county_id])
    elsif !filters[:wkt].nil?
      polygon = JSON.parse(filters[:wkt])
      cond = "ST_Intersects(the_geom, ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"polygon\", \"coordinates\":#{polygon[0]}}'),4326))"
    else
      cond = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius], true )
    end

    cond
  end

  def self.build_conditions(filters)
    cc = build_range_condition(filters[:from_construct], filters[:to_construct], :icinciti) if filters.has_key? :from_construct and filters.has_key? :to_construct
    cc = cc.build_range_condition(filters[:from_land_ocupation], filters[:to_land_ocupation], :osinciti) if filters.has_key? :from_land_ocupation and filters.has_key? :to_land_ocupation
    cc = cc.build_range_condition(filters[:from_inhabitants_hectare], filters[:to_inhabitants_hectare], :hectare_inhabitants) if filters.has_key? :from_inhabitants_hectare and filters.has_key? :to_inhabitants_hectare
    cc = cc.build_range_condition(filters[:from_max_height], filters[:to_max_height], :aminciti) if filters.has_key? :from_max_height and filters.has_key? :to_max_height

    cc
  end

  def self.build_in_condition values, column
    where("#{column} in", values)
  end

  def self.build_range_condition(from, to, column)
    if(from != '' && to != '')
      where("#{column} >= ? and #{column} <= ?", from.to_f, to.to_f)
    else
      all
    end
  end

  def save_building_regulation_data(data)
    ic = Iconv.new('UTF-8', 'ISO-8859-1')
    county = County.find_by_code(data["cod_com"].to_i.to_s)

    self.building_zone        = ic.iconv(data["zona"])
    self.construct            = data["ic"]
    self.land_ocupation       = data["os"]
    self.density_type_id      = data["am_cc"]
    self.county_id            = county.id
    self.site                 = ic.iconv(data["url"])
    self.identifier           = data["id"]
    self.comments             = ic.iconv(data["nota"])
    self.the_geom             = data["geom"]
    self.hectarea_inhabitants = data["habha"]
    self.grouping             = data["agrupamien"]
    self.parkings             = data["estacionam"]
    self.am_cc                = data["am_cc"]
    self.aminciti             = data["aminciti"]
    self.icinciti             = data["icinciti"]
    self.osinciti             = data["osinciti"]
    self.freezed              = data["congelado"]
    self.freezed_observations = data["obs_cong"]

    if self.save!
      save_land_use_types(data["usos"], self.id)
      County.update(county.id, :legislation_data => true) unless county.nil?
      return true
    end
    false
  end

  def self.get_construct_limits
    select = "MIN(construct) as min, MAX(construct) as max"

    BuildingRegulation.select(select).order("max").first
  end

  def self.get_land_ocupation_limits
    select = "MIN(land_ocupation) as min, MAX(land_ocupation) as max"

    BuildingRegulation.select(select).first
  end

  private

    def save_land_use_types(land_use, build_id)
      self.building_regulation_land_use_types.delete_all
      land_use.split(",").each do |l|
        land_use_id = LandUseType.find_by_identifier(l).id
        BuildingRegulationLandUseType.create(:building_regulation_id => build_id, :land_use_type_id => land_use_id)
      end
    end

    def self.reports_pdf filters
      BuildingRegulation.includes(:land_use_types).
        where(build_interval_conditions(filters)).
        build_conditions(filters)
    end

    def self.info_popup id
      select = "building_zone, construct, osinciti, aminciti, hectarea_inhabitants, grouping, density_type_id, id, freezed, freezed_observations, "
      select += "round((St_area(the_geom, false))::numeric,2) as area, county_id, comments, parkings, identifier "
      data = BuildingRegulation.includes(:county).where(id: id).select(select).first
      building = BuildingRegulationLandUseType.joins(:land_use_type).where(building_regulation_id: id).select(:name)

      return [data, building]
    end

    def self.kml_data filters

      data = BuildingRegulation.includes(:land_use_types).
        where(build_interval_conditions(filters)).
        build_conditions(filters)

      kml = KMLFile.new

      kml.objects << KML::Style.new(
        :id => "style_polygon",
        :line_style => KML::LineStyle.new(
          :color=> 'fd454f',
          :width => 2.5
        ),
        :poly_style => KML::PolyStyle.new(
          :color => '343455'
        )
      )
      document = KML::Document.new(name: "Normativa")
      data.each do |c|
        polygon = []
        c.the_geom.coordinates.each do |arr1|
          arr1.each do |arr2|
            arr2.each do |point|
              polygon.push(point[0], point[1], 100)
            end
          end
        end

        coordinates = polygon.join(',')

        document.features << KML::Placemark.new(
          name: "Normativa",
          description: "Normativa Edificación: #{c.building_zone}
                        IC: #{c.construct}
                        Altura: #{c.aminciti}
                        Ha/Ha: #{c.hectarea_inhabitants}",
                        style_url: '#style_polygon',
                        geometry: KML::Polygon.new(
                          outer_boundary_is: KML::LinearRing.new(
                            coordinates: "#{coordinates}"
                           )
                         )
        )
      end

      kml.objects << document

      kml.render
    end
end
