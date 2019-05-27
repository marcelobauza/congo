class BuildingRegulation < ApplicationRecord
  belongs_to :density_type
  belongs_to :county

  has_many :building_regulation_land_use_types

  validates_presence_of :county_id
  
	def self.get_density_types
		BuildingRegulation.find(:all, :select => "density_i as density", :group => "density_i", :order => "density_i")
	end

	def self.group_by_constructivity filters
		find_group_by_column filters, 'construct'
	end

	def self.group_by_land_ocupation filters
		find_group_by_column filters, 'land_ocupation'
	end

	def self.find_group_by_column filters, column
		ranges = get_columns_ranges column
		building_regulations = []
		count = 0
		ranges.each do |range|
			
			breg = find_by_columns_range(filters, column, range[:from], range[:to])
			
			building_regulations << breg
			count += 1 if breg.value.to_i == 0
		end

		return [] if count == building_regulations.size
		return building_regulations
	end

	def self.get_columns_ranges column
		intervals_quantity = 5
		br = BuildingRegulation.find(:first, :select => "max(#{column})")

		factor = br.max.to_f / intervals_quantity
		ranges = [{:from => 0.0, :to => factor}]
		count = 1

		while count < intervals_quantity
			ranges.push({:from => ranges[(count - 1)][:to], :to => ranges[(count - 1)][:to] + factor});
			count += 1
		end

		ranges[ranges.length - 1][:to] = ranges[ranges.length - 1][:to] + factor;

		return ranges
	end

	def self.find_by_columns_range filters, column, from, to
		label = ">= " + from.to_s + " < " + to.to_s

		BuildingRegulation.find(:first,
		:select => "'#{label.to_s}' as label, count(*) as value, #{from} as from, #{to} as to",
		:joins => build_join(filters.has_key? :allowed_use_ids),
		:conditions => build_interval_conditions(filters, column, from, to))
	end

	def self.get_query_for_results(filters, result_id)
		sub_query = "SELECT '#{result_id}' as result_id, building_regulations.id as building_regulation_id, "
		sub_query += "building_regulations.identifier, density_types.color as density_color, building_zone, "
		
		if filters[:county_id].nil?
      sub_query += "MULTI(#{WhereBuilder.build_intersection_condition(filters[:wkt])}) as the_geom "
    else
      sub_query += "the_geom "
    end
		
		sub_query += "FROM building_regulations #{build_join(filters.has_key? :allowed_use_ids)}"
		sub_query += "WHERE #{build_where_condition(filters)}"
		sub_query
	end

	def self.build_where_condition(filters)
	  if filters[:county_id].nil?
      conditions = WhereBuilder.build_intersects_condition(filters[:wkt])
    else
      conditions = "county_id = #{filters[:county_id]}"
    end
		conditions += build_conditions(filters)
		conditions
	end

	def self.get_polygon_count_by_filters(filters)
		BuildingRegulation.count(:joins => build_join(filters.has_key? :allowed_use_ids),
		:conditions => build_where_condition(filters))
	end

	def self.buil_building_regulations_legend(filters)
		legend = {:title => I18n.translate(:BUILDING_REGULATIONS_LEGEND_TITLE), :items => []}

		join =  "INNER JOIN building_regulations ON building_regulations.density_type_id = density_types.id "
		join += "INNER JOIN building_regulation_land_use_types on "
		join += "building_regulation_land_use_types.building_regulation_id = building_regulations.id "
		join += "INNER JOIN user_expirations ON user_expirations.county_id = building_regulations.county_id " if User.current.is_count_down?

		density = DensityType.find(:all,
			:select => "density_types.id, density_types.name, density_types.color",
			:joins => join,
			:conditions => build_where_condition(filters),
			:group => "density_types.id, density_types.name, density_types.color, density_types.position",
			:order => "density_types.position")

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

		BuildingRegulation.find(:first,
		:select => "DISTINCT(building_regulations.id)",
		:joins => build_join(filters.has_key? :allowed_use_ids),
		:conditions => condition)
	end

	def self.build_conditions(filters)
		cond = ""
		cond += build_range_condition(filters[:from_construct], filters[:to_construct], 'construct') if filters.has_key? :from_construct and filters.has_key? :to_construct
		cond += build_range_condition(filters[:from_land_ocupation], filters[:to_land_ocupation], 'land_ocupation') if filters.has_key? :from_land_ocupation and filters.has_key? :to_land_ocupation
		cond += build_in_condition(filters[:allowed_use_ids], 'building_regulation_land_use_types.land_use_type_id')  if filters.has_key? :allowed_use_ids and filters.has_key? :allowed_use_ids
		cond += "#{Util.and}building_regulations.county_id IN(#{User.current.county_ids.join(",")})" if User.current.county_ids.length > 0
		cond
	end

	def self.build_interval_conditions(filters, column, from, to)
		if filters[:county_id].nil?
		  cond = "ST_Intersects(the_geom, ST_GeomFromText('#{filters[:wkt]}', #{Util::WGS84_SRID}))"
		else
		  cond = "county_id = #{filters[:county_id]}"
		end
    		  
		cond += " AND #{column} >= #{from} and #{column} < #{to}"
		cond += build_range_condition(filters[:from_construct], filters[:to_construct], 'construct') if filters.has_key? :from_construct and filters.has_key? :to_construct and column != "construct"
		cond += build_range_condition(filters[:from_land_ocupation], filters[:to_land_ocupation], 'land_ocupation') if filters.has_key? :from_land_ocupation and filters.has_key? :to_land_ocupation and column != "land_ocupation"
		cond += build_in_condition(filters[:allowed_use_ids], 'building_regulation_land_use_types.land_use_type_id')  if filters.has_key? :allowed_use_ids and filters.has_key? :allowed_use_ids
		cond += "#{Util.and}building_regulations.county_id IN(#{User.current.county_ids.join(",")})" if User.current.county_ids.length > 0
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
		BuildingRegulation.find(:first, :select => select)
	end

	def self.get_land_ocupation_limits
		select = "MIN(land_ocupation) as min, MAX(land_ocupation) as max"
		BuildingRegulation.find(:first, :select => select)
	end

	def self.build_join(land_use_filter=false)
		join = "INNER JOIN density_types ON density_types.id = building_regulations.density_type_id "

		if (land_use_filter)
			join += "INNER JOIN building_regulation_land_use_types ON "
			join += "building_regulations.id = building_regulation_land_use_types.building_regulation_id "
		end

		join += "INNER JOIN user_expirations ON user_expirations.county_id = building_regulations.county_id " if User.current.is_count_down?
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
end
