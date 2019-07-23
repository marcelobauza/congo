class BuildingRegulation < ApplicationRecord
  belongs_to :density_type
  belongs_to :county

  has_many :building_regulation_land_use_types

  validates_presence_of :county_id
  
	def self.get_density_types
		BuildingRegulation.find(:all, :select => "density_i as density", :group => "density_i", :order => "density_i")
	end

	def self.group_by_constructivity filters
        icinciti = find_by_columns_range(filters, "icinciti")
	end

	def self.group_by_land_ocupation filters
		osinciti = find_by_columns_range(filters, 'osinciti')
	end

	def self.group_by_maximum_height filters
		aminciti = find_by_columns_range(filters, 'aminciti')
	end

  def self.group_by_hectarea_inhabitants filters
    hectarea_inhabitants = find_by_columns_range(filters, 'hectarea_inhabitants')
  end
	
  def self.find_by_columns_range filters, column
    range = BuildingRegulation.select("min(#{column}), max(#{column})").
      where(build_interval_conditions(filters, column)).take
      range
	end


	def self.build_where_condition(filters)
    if !filters[:county_id].nil?
      conditions += "county_id = #{filters[:county_id]}" + Util.and
    elsif !filters[:wkt].nil?
      conditions += WhereBuilder.build_within_condition(filters[:wkt]) + Util.and
    else
      conditions += WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] ) + Util.and
      end
		conditions += build_conditions(filters)
		conditions
	end

	def self.get_polygon_count_by_filters(filters)
    BuildingRegulation.count(:joins => build_join(filters.has_key? :allowed_use_ids).
                             where( build_where_condition(filters)))
	end

	def self.buil_building_regulations_legend(filters)
		legend = {:title => I18n.translate(:BUILDING_REGULATIONS_LEGEND_TITLE), :items => []}

		join =  "INNER JOIN building_regulations ON building_regulations.density_type_id = density_types.id "
		join += "INNER JOIN building_regulation_land_use_types on "
		join += "building_regulation_land_use_types.building_regulation_id = building_regulations.id "
		join += "INNER JOIN user_expirations ON user_expirations.county_id = building_regulations.county_id " if User.current.is_count_down?

    density = DensityType.select("density_types.id, density_types.name, density_types.color").
			                    joins(join).
			                    where( build_where_condition(filters)).
			                    group("density_types.id, density_types.name, density_types.color, density_types.position").
			                    order( "density_types.position")

		density.each do |dens|
			legend[:items] << {:label => dens.name, :color => "#" + dens.color, :height => 15, :width => 15}
		end

		legend
	end

	def self.find_selected_multi_polygon(selected_point, filters)
	  if filters[:county_id].nil?
      condition = "ST_Intersects(the_geom, ST_GeomFromText('#{filters[:wkt]}', #{Util::WGS84_SRID})) AND "
    else
      condition = "county_id = #{filters[:county_id]} AND "
    end
	  
		condition += "ST_Intersects(the_geom, ST_GeomFromText('#{selected_point}', #{Util::WGS84_SRID}))"
		condition += " AND ST_Intersects(ST_GeomFromText('#{filters[:wkt]}', #{Util::WGS84_SRID}), ST_GeomFromText('#{selected_point}', #{Util::WGS84_SRID}))" unless filters[:wkt].nil?
		condition +=  build_conditions(filters)

    BuildingRegulation.select("DISTINCT(building_regulations.id)").
		                   joins(build_join(filters.has_key? :allowed_use_ids)).
                       where(condition).first
	end

	def self.build_interval_conditions(filters, column)
		if !filters[:county_id].nil?
		  cond = "county_id = #{filters[:county_id]}"
    elsif !filters[:wkt].nil?
      polygon = JSON.parse(filters[:wkt])
    cond = "ST_Intersects(the_geom, ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"polygon\", \"coordinates\":#{polygon[0]}}'),4326))"
		else
      cond = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] )
		end
    		  
#		cond += build_range_condition(filters[:from_construct], filters[:to_construct], 'construct') if filters.has_key? :from_construct and filters.has_key? :to_construct and column != "construct"
#		cond += build_range_condition(filters[:from_land_ocupation], filters[:to_land_ocupation], 'land_ocupation') if filters.has_key? :from_land_ocupation and filters.has_key? :to_land_ocupation and column != "land_ocupation"
#		cond += build_in_condition(filters[:allowed_use_ids], 'building_regulation_land_use_types.land_use_type_id')  if filters.has_key? :allowed_use_ids and filters.has_key? :allowed_use_ids
		#cond += "#{Util.and}building_regulations.county_id IN(#{User.current.county_ids.join(",")})" if User.current.county_ids.length > 0
		cond
	end
  def self.build_conditions(filters)
    cond = ""
    cond += build_range_condition(filters[:from_construct], filters[:to_construct], 'construct') if filters.has_key? :from_construct and filters.has_key? :to_construct
    cond += build_range_condition(filters[:from_land_ocupation], filters[:to_land_ocupation], 'land_ocupation') if filters.has_key? :from_land_ocupation and filters.has_key? :to_land_ocupation
    cond += build_in_condition(filters[:allowed_use_ids], 'building_regulation_land_use_types.land_use_type_id')  if filters.has_key? :allowed_use_ids and filters.has_key? :allowed_use_ids
    #cond += "#{Util.and}building_regulations.county_id IN(#{User.current.county_ids.join(",")})" if User.current.county_ids.length > 0
    cond
  end


	def self.build_in_condition values, column
		" AND " + column + " IN(" + values.join(",") + ")"
	end

	def self.build_range_condition(from, to, column)
		cond = " AND ("

		0.upto(from.count - 1) do |i|
			cond += "(#{column} >= #{from[i]} AND #{column} <= #{to[i]}) OR"
		end

		cond = cond.chomp(" OR") + ")"
	end

	def save_building_regulation_data(geom, data)
		ic = Iconv.new('UTF-8', 'ISO-8859-1')

                     county = County.find_by_code(data["COD_COM"].to_i.to_s)
                     self.building_zone =  ic.iconv(data["zona"])
                    # self.max_height = ic.iconv(data["altMax"])
                     self.construct = data["IC"]
                     self.land_ocupation = data["OS"]
                     #self.last_actualization = ic.iconv(data["FuenteFech"])
                     self.density_type_id = data["AM_CC"]
                     self.county_id = county.id unless county.nil?
                     self.site = ic.iconv(data["URL"])
                     self.identifier = data["id"]
                     self.comments = ic.iconv(data["Nota"])
                     self.the_geom = geom
                     self.hectarea_inhabitants = data["Habha"]
                     self.grouping = data["Agrupamien"]
                     self.parkings = data["Estacionam"]
                     self.am_cc = data["AM_CC"]
                     self.aminciti = data["am_inciti"]
                     self.icinciti = data["ic_inciti"]
                     self.osinciti = data["os_inciti"]

		if self.save
			save_land_use_types(data["Usos"], self.id)
			County.update(county.id, :legislation_data => true) unless county.nil?
			return true
		end
		false
	end

	def self.get_construct_limits
		select = "MIN(construct) as min, MAX(construct) as max"

    @a = BuildingRegulation.select(select).order("max").first
    @a

	end

	def self.get_land_ocupation_limits
		select = "MIN(land_ocupation) as min, MAX(land_ocupation) as max"
    BuildingRegulation.select(select).first
	end

	def self.build_join(land_use_filter=false)
		join = "INNER JOIN density_types ON density_types.id = building_regulations.density_type_id "

		if (land_use_filter)
      join
			join += "INNER JOIN building_regulation_land_use_types ON "
			join += "building_regulations.id = building_regulation_land_use_types.building_regulation_id "
		end
		join
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
    fields = [:building_zone, :construct, :land_ocupation, :density_type_id, :am_cc, :icinciti, :osinciti, :aminciti, :hectarea_inhabitants]
             @pdf = BuildingRegulation.where(build_where_condition(filters)).group(fields).select(fields)
  end
end
