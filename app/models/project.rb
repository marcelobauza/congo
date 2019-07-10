class Project < ApplicationRecord
  # acts_as_indexed :fields => [:name, :address, :code]

  has_many :project_instances, :dependent => :destroy
  has_many :project_instance_mixes, :through => :project_instances
  has_many :project_statuses, :through => :project_instances
  belongs_to :project_type
  has_many :agency_rols
  has_many :agencies, :through => :agency_rols

  belongs_to :project_type
  belongs_to :county

  delegate :name, :to => :county, :prefix => true, :allow_nil => true
  delegate :name, :to => :get_agency, :prefix => true, :allow_nil => true
  delegate :id, :to => :get_agency, :prefix => true, :allow_nil => true
  delegate :name, :to => :get_constructor, :prefix => true, :allow_nil => true
  delegate :id, :to => :get_constructor, :prefix => true, :allow_nil => true
  delegate :name, :to => :get_seller, :prefix => true, :allow_nil => true
  delegate :id, :to => :get_seller, :prefix => true, :allow_nil => true

  include WhereBuilder
  include Util
  include Ranges

  validates_presence_of :address,
    :county_id,
    :project_type_id,
    :name,
    :floors,
    :longitude,
    :latitude

  validate :point_is_located_within_the_specified_county, :unless => Proc.new { |t| t.county.blank? or t.longitude.blank? or t.latitude.blank? }
  #  validates_numericality_of :floors, :only_integer => true, :unless => 'floors.blank?'

  validates_each :build_date, :sale_date, :transfer_date do |record, attr, value|
    if value.split('/').count != 3
      record.errors.add(attr, "La fecha no tiene el formato esperado. El formato debe ser 'dd/mm/aaaa'")
    else
      d, m, y = value.split('/')
      if !(1..31).include? d.to_i
        record.errors.add(attr, "El dia debe ser un valor entre 1 y 31 (dd/mm/aaaa)")
      end

      if !(1..12).include? m.to_i
        record.errors.add(attr, "El mes debe ser un valor entre 1 y 12 (dd/mm/aaaa)")
      end
    end
  end

  accepts_nested_attributes_for :project_instances, :project_instance_mixes

  attr_accessor :latitude, :longitude

  before_validation :build_geom

  before_create  :generate_code

  #include GeoRuby::Shp4r

  BIMESTER_QUANTITY = 6


  def self.parcel_project(project)

    parcel = Project.find_by_sql("select p.gid from parcels p, projects r where st_contains (p.the_geom, r.the_geom) and r.id = #{project}")
    return parcel
  end

  def self.parcels 
    parcels = Util.execute("select distinct(p.gid) as gid, st_astext(p.the_geom), p.area_name from parcels p, report_emis r  where st_contains(p.the_geom, r.the_geom)  ")
    parcels
  end

  def self.emi(not_project, project_type_id, wkt, bimester, year,  county_id = nil)

    joins = " inner join agency_rols on project_instance_mix_views.project_id = agency_rols.project_id "
    joins += " inner join agencies on agency_rols.agency_id = agencies.id "

    selects = " distinct on (project_instance_mix_views.the_geom) project_instance_mix_views.the_geom, " 
    selects += " project_instance_mix_views.name as name,  " 
    selects += " agencies.name as agency_name, " 
    selects += "total_available(project_instance_mix_views.project_instance_id)as stock_units," 
    selects += " project_instance_mix_views.project_id as row_number, "
    selects += " round(vhmd(project_instance_mix_views.project_instance_id)::numeric,1) as vhmu, " 
    selects += " round(pp_uf_m2 (project_instance_mix_views.project_instance_id)::numeric,1)  as uf_m2, "
    selects += "(select round(sum((mix_usable_square_meters * total_units) * (uf_min * (1::numeric - percentage / 100::numeric) + uf_max * (1::numeric - percentage / 100::numeric)) / 2::numeric / mix_usable_square_meters ) / sum(mix_usable_square_meters * total_units),1)  from project_instance_mixes where project_instance_id = project_instance_mix_views.project_instance_id ) as uf_m2_u,  "
    selects += "pp_uf(project_instance_mix_views.project_instance_id) as uf_value"

    conditions =  "ST_Contains(ST_Transform(ST_GeomFromText('#{wkt}',4326),4326), project_instance_mix_views.the_geom)" if !wkt.nil?
    conditions +=  " and project_instance_mix_views.project_type_id = '#{project_type_id}' " 
    conditions += " and  project_instance_mix_views.project_id not in (#{not_project}) "  unless not_project.nil? || not_project.empty?
    conditions += " and bimester = #{bimester }"
    conditions += " and year = #{year }"
    projects = ProjectInstanceMixView.find(:all, 
                                           :select => selects,
                                           :joins => joins,
                                           :conditions =>  conditions,
                                           :order => "project_instance_mix_views.the_geom"
                                          ) 
    return projects; 
  end

  def self.generate_map_images(wkt, result_id, layer_type, directory, name, parcel_id = nil )

    uf_m2 = false
    #Buffer
    buffer_token = Buffer.create_buffer(wkt)
    bottom_left, top_right = Buffer.get_buffer_bounding_box(buffer_token)

    #MAP IMAGES
    map = MapUtil.new

    layer_name ="EMI_LAYER_TYPE"
    geoserver = GeoServerUtil.new(layer_name)

    geoserver.layer_type[:value_column].each_with_index do |column, i|
      #GEOSERVER ATTRIBUTES
      map.attributes[:bottom_left] = bottom_left
      map.attributes[:top_right] = top_right
      map.attributes[:directory] = directory

      map.attributes[:wms_config] = geoserver.build_geoserver_wms_emi_configuration(buffer_token, result_id, i, uf_m2, parcel_id)

      #CREATE WMS IMAGES FOR REPORTS
      #			base = map.build_report_base_wms_image
      #			mask = map.build_report_mask_wms_images
      map.build_report_emi_points_wms_images(name)

    end
  end

  def self.kpi(county_id, year_from, year_to, bimester, project_type_id, polygon_id )

    if  ((county_id.empty? || polygon_id.empty?) && year_from.empty? && year_to.empty? && bimester.empty? && project_type_id.empty?) 

      return;
    end


    if !county_id.empty?    
      sql_county_code = ("select code from counties where id = #{county_id}")
      county_code_exec = Util.execute(sql_county_code)
      county_code  = county_code_exec[0]['code'].to_i
    end
    bim_from, bim_to = 1, 6

    if bimester != "0"
      bim_from, bim_to = bimester, bimester
    end

    if !county_id.empty?    

      result = ("select inciti_kpi_generate_primary_data(#{county_code}, #{year_from}, #{year_to}, #{bim_from}, #{bim_to}, #{project_type_id})")

    else

      result = ("select kpi__polygon_generate_primary_data(#{polygon_id}, #{year_from}, #{year_to}, #{bim_from}, #{bim_to}, #{project_type_id})")

    end
    kpi = Util.execute(result)

  end

  def self.getPrimaryEvolution ()
  end

  def self.getCountyEvolution ()
    Util.execute("select * from evolution_view order by year, bimester")
  end


  def latitude
    @latitude ||= self.the_geom.y if self.the_geom
    return @latitude ? @latitude : ""
  end

  def longitude
    @longitude ||= self.the_geom.x if self.the_geom
    return @longitude ? @longitude : ""
  end

  def get_agency
    get_agency_by_rol(Agency::ROL[:agency])
  end

  def get_constructor
    get_agency_by_rol(Agency::ROL[:contructor])
  end

  def get_seller
    get_agency_by_rol(Agency::ROL[:seller])
  end


  def self.find_index(project_type, bimester, county, year, search)

    @joins = Array.new
    @joins << " inner join project_instances pi on projects.id = pi.project_id "     
    @joins << " inner join project_instance_mixes pim on pi.id = pim.project_instance_id "
    @joins << " inner join project_statuses ps on ps.id = pi.project_status_id "
    @joins << " inner join project_mixes pm on pim.mix_id = pm.id "

    select = " pi.project_id ,"
    select += " projects.project_type_id,"
    select += " pi.bimester,"
    select += " pi.year,"
    select += " projects.code,"
    select += " projects.name,"
    select += " (select name from agencies a inner join agency_rols ar on a.id  = ar.agency_id where ar.project_id = projects.id and rol ilike 'INMOBILIARIA' limit 1) as agency,"
    select += " county_name(projects.county_id) as countyname, "

    if !search.nil?
      letter =  search.at(6)
      letter = letter.delete('"')
      if letter == 'C'
        project_type = '1' 
      else 
        project_type = '2' 
      end
    end

    if ( project_type == '1')

      select += " min((t_min + t_max) /2)   as ps_terreno_min, "
      select += " max((t_min + t_max)/2 ) as ps_terreno_max, " 
      select += " min(round((pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric / (pim.mix_usable_square_meters + ((t_min + t_max)/2) * 0.25)::numeric,1)) AS uf_m2_ut_min, "
      select += " max(round((pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric / (pim.mix_usable_square_meters + ((t_min + t_max)/2) * 0.25)::numeric,1)) AS uf_m2_ut_max, "
      select += " round(sum((mix_usable_square_meters * pim.total_units) * round((pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric / (pim.mix_usable_square_meters + ((t_min + t_max)/2) * 0.25)::numeric,1)) / sum(mix_usable_square_meters * pim.total_units), 1) as pp_UFm2ut,"

    else

      select += " projects.floors,"
      select += " min(pim.mix_terrace_square_meters) as min_terrazas,"
      select += " max(pim.mix_terrace_square_meters) as max_terrazas,"
      select += " min(round((uf_min * (1::numeric - percentage / 100::numeric) + uf_max * (1::numeric - percentage / 100::numeric)) / 2::numeric / (mix_usable_square_meters + mix_terrace_square_meters * 0.5),1)) AS uf_m2_min,"
      select += " max(round((uf_min * (1::numeric - percentage / 100::numeric) + uf_max * (1::numeric - percentage / 100::numeric)) / 2::numeric / (mix_usable_square_meters + mix_terrace_square_meters * 0.5),1)) AS uf_m2_max,"
      select += " round(sum((mix_usable_square_meters * pim.total_units) * round((uf_min * (1::numeric - percentage / 100::numeric) + uf_max * (1::numeric - percentage / 100::numeric)) / 2::numeric / (mix_usable_square_meters + mix_terrace_square_meters * 0.5),1)) / sum(mix_usable_square_meters * pim.total_units), 1)  as pp_UFm2ut,"

      select += " round((sum(pim.mix_usable_square_meters * pim.total_units) / sum(pim.total_units))::numeric, 1)  as pp_utiles,"
      select += " round(sum(pim.mix_terrace_square_meters * pim.total_units) / sum(pim.total_units), 1)  as pp_terrazas,"
    end

    select += " min(pim.mix_usable_square_meters) as Min_utiles,"
    select += " max(pim.mix_usable_square_meters) as Max_utiles,"
    select += " count(pm.bedroom) as bedroom,"
    select += " sum(pim.discount) as discount,"
    select += " (select min(uf_min) from project_instance_mixes where project_instance_id = pi.id) as uf_min_percent,"
    select += " (select max(uf_min) from project_instance_mixes where project_instance_id = pi.id) as uf_max_percent,"
    select += " round(pp_uf(pi.id)::numeric,0) AS pp_uf,"
    select += " sum(pim.total_units) as total_units,"
    select += " sum(pim.stock_units)  as stock_units,"
    select += " sum(pim.total_units - pim.stock_units) AS sold_units,"
    select += " sum(round((vhmu(pim.total_units, pim.stock_units, pi.cadastre, projects.sale_date)::numeric),1)) AS vhmu,"
    select += " round(sum(pim.total_units - pim.stock_units) / sum(pim.total_units::numeric) * 100,1)  as percentage_sold,"
    select += " sum(round(masd(pi.id)::numeric,1)) as vhmud,"
    select += " round(pxq(pi.id)::numeric, 1) AS pxq,"
    select += " round((vhmd(pi.id) * pp_uf_dis(pi.id) / 1000::double precision)::numeric,1) AS pxq_d,"
    select += " ps.name as status"


    conditions = " 1 = 1" 
    conditions += " and projects.project_type_id = #{project_type}" if !project_type.nil?
    conditions += " and bimester = #{bimester } " if !bimester.nil?
    conditions += " and county_id = #{county} " if !county.nil?
    conditions += " and year = #{year} " if !year.nil?
    conditions += " and code = '#{search}'"  if !search.nil?
    groups = "project_id, bimester, year, code, projects.name, agency, floors,  uf_min_percent, uf_max_percent, pp_uf, uf_m2, pxq, status, pxq_d, agency,  countyname, project_type_id"

    Project.find(:all,
                 :select => select,
                 :joins => @joins.uniq.join(" "),
                 :conditions => conditions,
                 :group => groups,
                 :order => ('year, bimester'))

  end


  def self.find_globals(filters)
    
    select =  "COUNT(DISTINCT(project_instance_mix_views.project_id)) AS project_count, SUM(project_instance_mix_views.total_units) AS total_units, "
    select += "SUM(project_instance_mix_views.total_units - project_instance_mix_views.stock_units) AS total_sold, "
    select += "SUM(project_instance_mix_views.stock_units) AS total_stock, "
    select += "CASE SUM(project_instance_mix_views.total_units) WHEN 0 THEN 0 "
    select += "ELSE SUM(project_instance_mix_views.mix_usable_square_meters * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units)END AS pp_utiles, "
    select += "CASE SUM(project_instance_mix_views.total_units) WHEN 0 THEN 0 "
    select += "ELSE SUM(project_instance_mix_views.mix_terrace_square_meters * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units)END AS pp_terrace, "
    select += "SUM((project_instance_mix_views.t_min + project_instance_mix_views.t_max)/2 * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units) AS ps_terreno, "
    select += "CASE SUM(project_instance_mix_views.total_m2) WHEN 0 THEN 0 "
    select += "ELSE SUM(project_instance_mix_views.total_m2 * project_instance_mix_views.uf_avg_percent)/SUM(project_instance_mix_views.total_m2) END AS pp_uf, "
    select += "CASE SUM(project_instance_mix_views.dis_m2) WHEN 0 THEN 0 "
    select += "ELSE (SUM(project_instance_mix_views.total_m2 * uf_avg_percent) / (SUM(project_instance_mix_views.total_m2 * (mix_usable_square_meters + 0.5 * mix_terrace_square_meters)))) END AS pp_uf_dis_dpto, "
    select += "CASE SUM(project_instance_mix_views.ps_terreno) WHEN 0 THEN 0 "
    select += "ELSE (SUM(project_instance_mix_views.total_m2 * uf_avg_percent) / (SUM(project_instance_mix_views.total_m2 * (mix_usable_square_meters + 0.25 * ps_terreno))))  END AS pp_uf_dis_home, "
    select += "CASE SUM(project_instance_mix_views.total_m2) WHEN 0 THEN 0 "
    select += "ELSE AVG(project_instance_mix_views.uf_m2_home) END AS pp_uf_m2, "
    select += "SUM(vhmu) AS vhmo, "
    select += "SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END) AS vhmd, "
    select += "CASE SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END) WHEN 0 THEN SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END) "
    select += "ELSE SUM(project_instance_mix_views.stock_units)/SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END) END AS masd, "
    select += "MIN(uf_m2) as min_uf_m2, "
    select += "MAX(uf_m2) as max_uf_m2, "
    select += "AVG(uf_m2) as avg_uf_m2, "
    select += "MIN(uf_min_percent) as min_uf, "
    select += "MAX(uf_max_percent) as max_uf, "
    select += "AVG(uf_avg_percent) as avg_uf"


    ProjectInstanceMixView.select(select).
      where(build_conditions_new(filters, nil, false)).first
  end

  def self.get_query_for_results(filters, result_id, map_columns)
    @joins = Array.new
    @joins << "INNER JOIN project_instance_views ON project_instance_views.project_id = projects.id "
    joins_by_filter(filters)

    query = "SELECT #{result_id} as result_id, project_instance_views.id as project_instance_id, projects.the_geom, "
    query += "#{map_columns.join(',')}, #{MapUtil::HEATMAP_VALUE} as heatmap_value, "
    query += "'#{Util::NORMAL_MARKER_COLOR}' as marker_color FROM projects "
    query += @joins.uniq.join(" ")
    query += "WHERE #{build_conditions(filters, nil, false)}"
    query
  end

  def self.get_points_count_by_filters(filters, column)
    @joins = Array.new
    @joins << "INNER JOIN project_instance_views ON project_instance_views.project_id = projects.id "
    joins_by_filter(filters)

    Project.find(:first,
                 :select => "count(distinct(project_instance_views.project_id)) as count_all",
                 :joins => @joins.uniq.join(" "),
                 :conditions => "#{build_conditions(filters, nil, false)} AND project_instance_views.#{column} >= 1").count_all.to_i
  end

  def self.get_heat_map_points_count_by_filters(filters)
    @joins = Array.new
    @joins << "INNER JOIN project_instance_views ON project_instance_views.project_id = projects.id "
    joins_by_filter(filters)

    Project.find(:first,
                 :select => "count(distinct(project_instance_views.project_id)) as count_all",
                 :joins => @joins.uniq.join(" "),
                 :conditions => "#{build_conditions(filters, nil, false)}").count_all.to_i
  end

  #FIND PROJECTS BY WIDGETS. COUNT
  def self.projects_group_by_count(widget, filters, has_color)
    @joins = Array.new

    case widget
    when 'agencies'
      @joins << "INNER JOIN agencies ON agencies.id = project_instance_mix_views.agency_id "
    when 'project_types'
      @joins << "INNER JOIN project_types ON project_types.id = project_instance_mix_views.project_type_id "
    when 'project_statuses'
      @joins << "INNER JOIN project_statuses ON project_statuses.id = project_instance_mix_views.project_status_id "

    end 
    select = "#{widget}.id, #{widget}.name"
    select += ", #{widget}.color" if has_color

    ProjectInstanceMixView.select( "#{select}, COUNT(#{widget}.name) as value").
      joins(@joins.uniq.join(" ")).
      where(build_conditions_new(filters, widget)).
      group(select).
      order("#{widget}.name")
  end

  def self.projects_sum_by_stock(filters)
    select = "SUM(stock_units) as stock_units, SUM(total_units)as total_units, "
    select += "SUM(total_units - stock_units) as sold_units, year, bimester"

    load_values = lambda do |result, project, bimester|
      obj = {:stock_units => "null", :total_units => "null", :sold_units => "null",
             :bimester => bimester[:period], :year => bimester[:year]}
      obj[:stock_units] = project[:stock_units].to_i unless project.nil? or project[:stock_units].nil?
      obj[:total_units] = project[:total_units].to_i unless project.nil? or project[:total_units].nil?
      obj[:sold_units] = project[:sold_units].to_i unless project.nil? or project[:sold_units].nil?
      result << obj
    end

    values_by_period3("stock", select, filters, load_values)
  end

  def self.projects_by_uf(filters)
    select = "MIN(uf_avg_percent) as min, "
    select += "MAX(uf_avg_percent) as max, "
    select += "CASE sum(total_m2) WHEN 0 THEN 0 ELSE sum(total_m2 * uf_avg_percent)/sum(total_m2) END AS avg,"

    select += "project_instance_mix_views.year, project_instance_mix_views.bimester"

    values_by_period3("uf", select, filters, load_min_avg_max_values)

  end

  def self.projects_by_usable_area(filters)
    select = "MIN(mix_usable_square_meters) as min, "
    select += " MAX(mix_usable_square_meters) as max, "
    select += "(SUM(total_units * COALESCE(mix_usable_square_meters,0)) / SUM(total_units)) as avg,"
    select += "year, bimester "

    values_by_period3("usable_area", select, filters, load_min_avg_max_values)

  end

  def self.projects_by_ranges(widget, filters)
    @joins = Array.new

    query_condition = " year = #{filters[:to_year]}  " 
    query_condition += " and bimester = #{filters[:to_period]} "
    query_condition += " and  county_id = #{filters[:county_id]} "  if filters.has_key? :county_id 
    query_condition += "and " +  WhereBuilder.build_in_condition("project_type_id", filters[:project_type_ids]) if filters.has_key? :project_type_ids
    query_condition += " and " + WhereBuilder.build_within_condition(filters[:wkt]) if filters.has_key? :wkt

    values = get_valid_min_max_limits(widget, filters)
    ranges = get_valid_ranges(values, widget) 

    total_ranges = ranges.count - 1

    result = Array.new

    0.upto(total_ranges) do |i|
      if (filters[:widget] == 'floors')
        select = "count(distinct(project_id)) as value, #{ranges[i]["min"].to_i} as min_value, #{ranges[i]["max"].to_i} as max_value"
      else
        select = "sum(total_units) as value, #{ranges[i]["min"].to_i} as min_value, #{ranges[i]["max"].to_i} as max_value"
      end
      cond = "#{query_condition} AND " + WhereBuilder.build_between_condition("ROUND(#{widget})", ranges[i]["min"].to_i, ranges[i]["max"].to_i)
      proj = ProjectInstanceMixView.select(select).
        where(cond).first

      result << proj
    end
    result
  end

  def self.get_valid_ranges(values, action)

    if (action == 'floors')

      ranges = get_range_floors
    else
      ranges = get_ranges
    end


    min_value = values[0]["min"].to_i
    max_value = values[0]["max"].to_i


    index_min = -1
    index_max = -1

    ranges.each_with_index do |r, index|

      index_min = index if min_value >= r["min"].to_i && min_value <= r["max"].to_i

      index_max = index if max_value <= r["max"].to_i && max_value >= r["min"].to_i
      index_max = index if max_value > r["max"].to_i
    end


    ranges[index_min..index_max]

  end

  def self.get_range_floors

    ranges_result = []

    sub_range_1 = {"min" => 0, "max" => 3}
    sub_range_2 = {"min" => 4, "max" => 7}
    sub_range_3 = {"min" => 8, "max" => 12}
    sub_range_4 = {"min" => 13, "max" => 20}
    sub_range_5 = {"min" => 21, "max" => 50}

    ranges_result << sub_range_1 << sub_range_2 << sub_range_3 << sub_range_4 << sub_range_5 


  end




  #TODO: Cambiar! traer de la base de datos!
  def self.get_ranges

    #emula lo que vendria de la db.

    ranges_result = []

    sub_range_1 = {"min" => 0, "max" => 440}
    sub_range_2 = {"min" => 441, "max" => 929}
    sub_range_3 = {"min" => 930, "max" => 1549}
    sub_range_4 = {"min" => 1550, "max" => 3399}
    sub_range_5 = {"min" => 3400, "max" => 5390}
    sub_range_6 = {"min" => 5391, "max" => 7950}
    sub_range_7 = {"min" => 7951, "max" => 11500}
    sub_range_8 = {"min" => 11501, "max" => 15600}
    sub_range_9 = {"min" => 15601, "max" => 500000}

    ranges_result << sub_range_1 << sub_range_2 << sub_range_3 << sub_range_4 << sub_range_5 << sub_range_6 << sub_range_7 << sub_range_8 << sub_range_9

  end

  def self.projects_by_uf_m2(filters)

    select = " case when min(uf_m2) IS NULL then min(uf_m2_home) else min(uf_m2) end as min, "
    select += " case when max(uf_m2) IS NULL then max(uf_m2_home) else max(uf_m2) end as max, "
    select += " case when avg(uf_m2) IS NULL then avg(uf_m2_home) else avg(uf_m2) end as avg, "
    select += " year, bimester "

    values_by_period3("uf_m2", select, filters, load_min_avg_max_values)
  end


  def self.values_by_period3(widget, select, filters, proc)

    result = []
    @joins = Array.new

    condition = Util.and + build_conditions_new(filters, widget)
    bimesters = get_bimesters filters

    bimesters.each do |bimester|
      cond_query = get_periods_query_new(bimester[:period], bimester[:year]) + condition

      project = ProjectInstanceMixView.select(select).
        where(cond_query).
        group('year, bimester').
        order('year, bimester').first

      proc.call result, project, bimester
    end


    result.reverse
  end


  def self.projects_by_ground_area(widget, filters)
    if (filters['project_type_ids'] == 1)

      select = "min(ps_terreno) as min, "
      select += "max(ps_terreno) as max, "
      select += "avg(ps_terreno) as avg, "
    else
      select = "min(mix_terrace_square_meters) as min, "
      select += "max(mix_terrace_square_meters) as max, "
      select += "avg(mix_terrace_square_meters) as avg, "
    end

    select += "year, bimester "
    values_by_period3(widget, select, filters, load_min_avg_max_values)
  end

  #FIND PROJECTS BY MIX TYPE
  def self.projects_group_by_mix(widget, filters)
    @joins = Array.new
    #BUILD JOINS
    joins_by_widget(widget)

    select = "sum(project_instance_mix_views.stock_units) as stock_units,
              sum(project_instance_mix_views.total_units - project_instance_mix_views.stock_units) as sold_units, "
    select += "project_mixes.mix_type, project_mixes.id"


    if filters.has_key? :mix_ids
      query = " mix_id = #{filters[:mix_ids].join(',')} and " 
      query += build_conditions_new(filters, widget, false) 
    else
      query = build_conditions_new(filters, widget, false) 
    end 


    ProjectInstanceMixView.select(select).
      joins(@joins.uniq.join(" ")).
      where( query).
      group("project_mixes.mix_type, project_mixes.id").
      order("project_mixes.mix_type")
  end

  def save_project_data(data, project_type, geom)
    ic = Iconv.new('UTF-8', 'ISO-8859-1')
    type = ProjectType.find_by_name(project_type)

    county = County.find_by_code(data["COMUNA"].to_i.to_s)
    agency = Agency.find_or_create_by(name: ic.iconv(data["INMOBILIAR"]))

    self.code = data["COD_PROY"]
    self.address = ic.iconv(data["DIRECCION"].gsub("'","''"))
    self.name = ic.iconv(data["NOMBRE"])
    self.floors = data["N_PISOS"].to_i unless data["N_PISOS"] == -1
    self.agency_id = agency.id
    self.project_type_id = type.id
    self.county_id = county.id
    self.the_geom = geom

    result = self.save
    County.update(county.id, :sales_project_data => true) unless county.nil? if result

    result
  end
  def save_project_data_fulcrum(data,  geom)
    ic = Iconv.new('UTF-8', 'ISO-8859-1')
    type = ProjectType.find_by_name(data['tipo_de_pr'])
    county = County.find_by_code(data["county_id"].to_i.to_s)
    agency = Agency.find_or_create_by_name(ic.iconv(data["inmobiliar"]))

    self.code = data["cod_proy"]
    self.name = ic.iconv(data["nombre"])
    self.address = ic.iconv(data["direccion"].gsub("'","''"))
    self.floors = data["n_pisos"].to_i unless data["n_pisos"] == -1
    self.county_id = county.id
    self.project_type_id = type.id
    #self.agency_id = agency.id
    self.the_geom = geom
    self.build_date = data['build_date'].strftime("%d/%m/%y") 
    self.sale_date = data['sale_date'].strftime("%d/%m/%y") 
    self.transfer_date= data['transfer_d'].strftime("%d/%m/%y") 
    self.pilot_opening_date = data['pilot_open'].strftime("%d/%m/%y") 
    self.elevators = data['ascensores']
    self.quantity_department_for_floor = data["dpto_piso"]
    self.general_observation = data['gral_ob']


    result = self.save
    County.update(county.id, :sales_project_data => true) unless county.nil? if result
    result
  end

  def self.projects_count_by_period(widget, filters)
    select = "COUNT(DISTINCT(project_instance_mix_views.project_id)) as value, project_instance_mix_views.year, project_instance_mix_views.bimester"
    values_by_period3(widget, select, filters, load_value)
  end

  def self.load_value
    lambda do |result, project, bimester|
      obj = {:value => "null", :bimester => bimester[:period], :year => bimester[:year]}
      obj[:value] = project[:value] unless project.nil?
      result << obj
    end
  end

  def self.load_min_avg_max_values
    lambda do |result, project, bimester|
      obj = {:min => "null", :max => "null", :avg => "null", :bimester => bimester[:period], :year => bimester[:year]}
      obj[:min] = project[:min].to_f.round(1) unless project.nil? or project[:min].nil?
      obj[:avg] = project[:avg].to_f.round(1) unless project.nil? or project[:avg].nil?
      obj[:max] = project[:max].to_f.round(1) unless project.nil? or project[:max].nil?
      result << obj
    end
  end

  # def self.values_by_period(widget, select, filters, proc)
  #   result = []
  #   @joins = Array.new


  #   joins_by_widget(widget)
  #   joins_by_filter(filters)

  #   condition = Util.and + build_conditions(filters, widget)
  #   bimesters = get_bimesters filters

  #   bimesters.each do |bimester|
  #     cond_query = get_periods_query(bimester[:period], bimester[:year]) + condition

  #     project = Project.find(:first,
  #                            :select => select,
  #                            :joins => @joins.uniq.join(" "),
  #                            :conditions => cond_query,
  #                            :group => 'year, bimester',
  #                            :order => 'year, bimester')

  #     proc.call result, project, bimester
  #   end

  #   result.reverse
  # end

  #def self.values_by_period2(widget, select, filters, proc)
  #  result = []
  #  @joins = Array.new
  #  @joins << "INNER JOIN project_instance_views ON project_instance_views.id = project_instance_id "

  #  #joins_by_widget(widget)
  #  #joins_by_filter(filters)

  #  condition = Util.and + build_conditions(filters, widget, true)
  #  bimesters = get_bimesters filters

  #  bimesters.each do |bimester|
  #    cond_query = get_periods_query_for_view(bimester[:period], bimester[:year]) + condition

  #    project = ProjectInstanceMixView.find(:first,
  #                                          :select => select,
  #                                          :joins => @joins.uniq.join(" "),
  #                                          :conditions => cond_query,
  #                                          :group => 'project_instance_mix_views.year, project_instance_mix_views.bimester',
  #                                          :order => 'project_instance_mix_views.year, project_instance_mix_views.bimester')

  #    proc.call result, project, bimester
  #  end

  #  result.reverse
  #end

  def self.get_first_bimester_with_projects
    period = ProjectInstance.find(:first,
                                  :select => "project_instances.year, project_instances.bimester",
                                  :conditions => "project_instances.active = true AND (projects.bank_project = false OR projects.bank_project IS NULL)",
                                  :joins => :project,
                                  :group => "year, bimester",
                                  :order => "year, bimester"
                                 )

    return nil if period.nil?
    return {:period => period.bimester, :year => period.year}
  end

  def self.get_last_period
    period = Period.find(:first,
                         #:select => "project_instances.year, project_instances.bimester",
                         :select => "year,bimester",
                         #:conditions => "project_instances.active = true AND (projects.bank_project = false OR projects.bank_project IS NULL)",
                         :conditions => "active = true ",
                         # :joins => :project,
                         :group => "year, bimester",
                         :order => "year desc, bimester desc")

    if period.nil?
      Period.get_periods(1, 2010, BIMESTER_QUANTITY, 1)
    else
      Period.get_periods(period.bimester, period.year, BIMESTER_QUANTITY, 1)

    end
  end

  def self.is_periods_distance_allowed? from_period, to_period, distance
    f_period = from_period[:period]
    f_year = from_period[:year]
    t_period = to_period[:period]
    t_year = to_period[:year]

    if Period.get_distance_between_periods(f_period, f_year, t_period, t_year, 1) < distance
      return false
    end

    return true
  end

  def project_type_name
    self.project_type.try :name
  end

  def county_name
    self.county.try :name
  end

  def agency_name
    self.agency.try :name
  end

  def point_is_located_within_the_specified_county
    point_county = County.find_by_lon_lat(self.longitude, self.latitude)
    if point_county.nil?
      errors.add(
        :county_id,
        :not_within_county,
        :point_county => I18n.t(:none),
        :selected_county => self.county.name)
    else
      errors.add(
        :county_id,
        :not_within_county,
        :point_county => point_county.name,
        :selected_county => self.county.name) unless point_county.id == self.county_id
    end
  end

  def build_geom
    self.the_geom = "POINT(#{self.longitude.to_f}  #{self.latitude.to_f})" if self.latitude and self.longitude
  end

  def self.build_value_column(map_by)
    map_type = MappableField.find(map_by) unless map_by.nil?

    if map_type.nil?
      value_column = "1 as isoline_value"
    else
      case map_type.name
      when 'STOCK_MAPPABLE_FIELD'
        value_column = "project_instances.stock_units as isoline_value"
      when 'UF_TOTAL_MAPPABLE_FIELD'
        value_column = "project_instances.uf_value as isoline_value"
      when 'UF_M2_MAPPABLE_FIELD'
        value_column = "project_instances.uf_m2 as isoline_value"
      when 'SELLING_SPEED_MAPPABLE_FIELD'
        value_column = "project_instances.selling_speed as isoline_value"
      end
    end
    value_column
  end

  def self.build_conditions(filters, self_not_filter=nil, useView = false)

    @conditions = ''
    unless filters[:county_id].nil? and filters[:wkt].nil?
      if !filters[:county_id].nil?
        @conditions = "county_id = #{filters[:county_id]}" + Util.and
      elsif !filters[:wkt].nil? 
          @conditions = WhereBuilder.build_within_condition(filters[:wkt]) + Util.and
      else
        
      @conditions = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] ) + Util.and
          end
    end
    @conditions += WhereBuilder.build_range_periods_by_bimester(filters[:to_period], filters[:to_year], BIMESTER_QUANTITY, useView) if filters.has_key? :to_period
    @conditions += bimesters_condition(filters, self_not_filter, useView)
    @conditions += ids_conditions(filters, self_not_filter, useView)
    @conditions += between_condition(filters, self_not_filter)
    @conditions += "county_id IN(#{User.current.county_ids.join(",")})#{Util.and}" if User.current.county_ids.length > 0
    @conditions.chomp!(Util.and)
    @conditions
  end


  def self.build_conditions_new(filters, self_not_filter=nil, useView = false)

    @conditions = ''
    unless filters[:county_id].nil? and filters[:wkt].nil?
      if filters[:county_id].nil?
        @conditions = WhereBuilder.build_within_condition(filters[:wkt]) + Util.and
      else
        @conditions = "county_id = #{filters[:county_id]}" + Util.and
        end
    end
    @conditions += WhereBuilder.build_range_periods_by_bimester(filters[:to_period], filters[:to_year], BIMESTER_QUANTITY, useView) if filters.has_key? :to_period
    @conditions += bimesters_condition(filters, self_not_filter, useView)
    @conditions += ids_conditions_new(filters, self_not_filter, useView)
    @conditions += between_condition_new(filters, self_not_filter)
    #@conditions += "county_id IN(#{User.current.county_ids.join(",")})#{Util.and}" if User.current.county_ids.length > 0
    @conditions.chomp!(Util.and)
    @conditions
  end


  def self.bimesters_condition(filters, self_not_filter, useView = false)
    conditions = ""

    if filters.has_key? :periods and (self_not_filter == 'floors' or self_not_filter == 'project_statuses' or self_not_filter == 'project_types' or self_not_filter == 'mix' or self_not_filter == 'agencies' or self_not_filter == 'uf_value' or self_not_filter.nil?)
      conditions = WhereBuilder.build_bimesters_condition(filters[:periods], filters[:years], useView)
    end

    conditions
  end

  def self.get_periods_query(period, year)
    conditions = "("
    conditions += WhereBuilder.build_equal_condition('project_instances.bimester', period)
    conditions += Util.and
      conditions += WhereBuilder.build_equal_condition('project_instances.year', year)
    conditions += ")"
    return conditions
  end

  def self.get_periods_query_new(period, year)
    conditions = "("
    conditions += WhereBuilder.build_equal_condition('bimester', period)
    conditions += Util.and
      conditions += WhereBuilder.build_equal_condition('year', year)
    conditions += ")"
    return conditions
  end



  def self.get_periods_query_for_view(period, year)
    conditions = "("
    conditions += WhereBuilder.build_equal_condition('project_instance_views.bimester', period)
    conditions += Util.and
      conditions += WhereBuilder.build_equal_condition('project_instance_views.year', year)
    conditions += ")"
    return conditions
  end

  def self.between_condition(filters, self_not_filter)
    conditions = ""

    #FILTERS THE DIFERENT INSTANCES FOR THE SAME PROJECT BY THEIRS DATE

    #  if filters.has_key? :from_instance_date
    #    conditions += WhereBuilder.build_between_condition('project_instances.instance_date', filters[:from_instance_date], filters[:to_instance_date])

    # end

    #FILTERS THE PROJECTS BY A RANGE OF FLOORS
    if filters.has_key? :from_floor
      conditions += "( "
      0.upto(filters[:from_floor].length - 1) do |i|
        conditions += WhereBuilder.build_between_condition('floors', filters[:from_floor][i], filters[:to_floor][i])
        conditions += Util.and
      end

      conditions.chomp!(Util.and)
      conditions += " )" + Util.and
    end

    #FILTERS THE PROJECTS BY A RANGE OF UF VALUES
    #    if filters.has_key? :from_uf_value
    #      p "paso por el filtro"
    #      conditions += "( "
    #      0.upto(filters[:from_uf_value].length - 1) do |i|
    #        conditions += WhereBuilder.build_between_condition('project_instance_mix_views.uf_avg_percent', filters[:from_uf_value][i], filters[:to_uf_value][i])
    #        conditions += Util.and
    #      end

    #      conditions.chomp!(Util.and)
    #      conditions += " )" + Util.and
    #    end

    conditions
  end
  def self.between_condition_new(filters, self_not_filter)
    conditions = ""

    #FILTERS THE DIFERENT INSTANCES FOR THE SAME PROJECT BY THEIRS DATE

    #  if filters.has_key? :from_instance_date
    #    conditions += WhereBuilder.build_between_condition('project_instances.instance_date', filters[:from_instance_date], filters[:to_instance_date])

    # end

    #FILTERS THE PROJECTS BY A RANGE OF FLOORS
    if filters.has_key? :from_floor
      conditions += "( "
      0.upto(filters[:from_floor].length - 1) do |i|
        conditions += WhereBuilder.build_between_condition('project_instance_mix_views.floors', filters[:from_floor][i], filters[:to_floor][i])
        conditions += Util.and
      end

      conditions.chomp!(Util.and)
      conditions += " )" + Util.and
    end

    #FILTERS THE PROJECTS BY A RANGE OF UF VALUES
    if filters.has_key? :from_uf_value
      p "paso por el filtro"
      conditions += "( "
      0.upto(filters[:from_uf_value].length - 1) do |i|
        conditions += WhereBuilder.build_between_condition('project_instance_mix_views.uf_avg_percent', filters[:from_uf_value][i], filters[:to_uf_value][i])
        conditions += Util.and
      end

      conditions.chomp!(Util.and)
      conditions += " )" + Util.and
    end

    conditions
  end

  def self.ids_conditions(filters, self_not_filter, useView = false)
    conditions = ""
    #PROJECT STATUSES
    if filters.has_key? :project_status_ids and self_not_filter != 'project_statuses'
      query_field = useView ? "project_instance_mix_views.project_status_id" : "project_instance_views.project_status_id"
      conditions += WhereBuilder.build_in_condition(query_field, filters[:project_status_ids])
      conditions += Util.and
    end

    #PROJECT TYPES
    if filters.has_key? :project_type_ids and self_not_filter != 'project_types'

      if useView 
        conditions += WhereBuilder.build_in_condition("project_instance_mix_views.project_type_id", filters[:project_type_ids])
      else
        conditions += WhereBuilder.build_in_condition("project_type_id", filters[:project_type_ids])

        conditions += Util.and
      end
    end

=begin
    #AGENCIES
    if filters.has_key? :project_agency_ids and self_not_filter != 'agencies'
      conditions += WhereBuilder.build_in_condition("projects.agency_id", filters[:project_agency_ids])
      conditions += Util.and
    end

    #MIXES
    if filters.has_key? :mix_ids and self_not_filter != 'mix'
      conditions += "project_instance_mix_views.mix_id IN (#{filters[:mix_ids].join(",")})"
      conditions += Util.and
    end



=end

    #MIXES funciona
    if filters.has_key? :mix_ids and self_not_filter != 'mix'
      conditions += "project_instance_views.id  IN(SELECT project_instance_id "
      conditions += "FROM project_instance_mixes WHERE mix_id IN(#{filters[:mix_ids].join(",")}))"
      conditions += Util.and
    end

    if filters.has_key? :project_agency_ids and self_not_filter != 'agencies'
      conditions += " projects.agency_id IN (#{filters[:project_agency_ids].join(",")}) "

      conditions += Util.and
    end

    conditions
  end


  def self.ids_conditions_new(filters, self_not_filter, useView = false)
    conditions = ""
    #PROJECT STATUSES
    if filters.has_key? :project_status_ids and self_not_filter != 'project_statuses'
      query_field = "project_instance_mix_views.project_status_id" 
      conditions += WhereBuilder.build_in_condition(query_field, filters[:project_status_ids])
      conditions += Util.and
    end

    #PROJECT TYPES
    if filters.has_key? :project_type_ids and self_not_filter != 'project_types'
      conditions += WhereBuilder.build_in_condition("project_instance_mix_views.project_type_id", filters[:project_type_ids])
      conditions += Util.and
    end


    #MIXES funciona 
    if filters.has_key? :mix_ids and self_not_filter != 'mix'
      conditions += "project_instance_mix_views.project_instance_id  IN(SELECT project_instance_id "
      conditions += "FROM project_instance_mixes WHERE mix_id IN(#{filters[:mix_ids].join(",")}))"
      conditions += Util.and
    end
    #terminar condicion con la relacion de las agencias
    #AGENCIES
    if filters.has_key? :project_agency_ids and self_not_filter != 'agencies'
      conditions += " project_instance_mix_views.agency_id IN (#{filters[:project_agency_ids].join(",")}) "

      conditions += Util.and
    end


=begin

    #MIXES
    if filters.has_key? :mix_ids and self_not_filter != 'mix'
      conditions += "project_instance_mix_views.mix_id IN (#{filters[:mix_ids].join(",")})"
 #     conditions += "FROM project_instance_mix_views  WHERE IN(#{filters[:mix_ids].join(",")}))"
      conditions += Util.and

    end



    #AGENCIES
    if filters.has_key? :project_agency_ids and self_not_filter != 'agencies'
      conditions += WhereBuilder.build_in_condition("projects.agency_id", filters[:project_agency_ids])
      conditions += Util.and
    end

=end

    conditions

  end



  def self.joins_by_filter(filters)
    @joins << "INNER JOIN user_expirations ON user_expirations.county_id = projects.county_id " if User.current and User.current.is_count_down?

    if filters.has_key? :project_instance_id
      @joins << "INNER JOIN project_instances ON project_instances.project_id = projects.id "
    end

    if filters.has_key? :agency_ids
      @joins << "INNER JOIN agencies ON agencies.id = projects.agency_id "
    end

    if filters.has_key? :project_type_ids
      @joins << "INNER JOIN project_types ON project_types.id = projects.project_type_id "
    end

    if filters.has_key? :project_status_ids
      #@joins << "INNER JOIN project_instances ON project_instances.project_id = projects.id "
      @joins << "INNER JOIN project_statuses ON project_statuses.id = project_instance_views.project_status_id "
    end

    if filters.has_key? :from_floor or filters.has_key? :from_instance_date
      #@joins << "INNER JOIN project_instances ON project_instances.project_id = projects.id "
    end

    if filters.has_key? :periods
      #@joins << "INNER JOIN project_instances ON project_instances.project_id = projects.id "
    end
  end

  def self.joins_by_widget(widget)
    case widget
    when 'counties'
      @joins << "INNER JOIN counties ON projects.county_id = counties.id "
    when 'agencies'
      @joins << "INNER JOIN agencies ON agencies.id = projects.agency_id "
    when 'project_types'
      @joins << "INNER JOIN project_types ON project_types.id = projects.project_type_id "
    when 'project_statuses'
      #@joins << "INNER JOIN project_instances ON project_instances.project_id = projects.id "
      @joins << "INNER JOIN project_statuses ON project_statuses.id = project_instance_views.project_status_id "
    when 'mix'
      #@joins << "INNER JOIN project_instances ON project_instances.project_id = projects.id "
      #@joins << "INNER JOIN project_instance_mixes ON project_instances.id = project_instance_mixes.project_instance_id "
      @joins << "INNER JOIN project_mixes ON project_instance_mix_views.mix_id = project_mixes.id "

    when 'stock', 'usable_area', 'uf', 'uf_m2', 'ground_area', 'sale_bimester', 'floors', 'uf_value'
      @joins << "INNER JOIN project_instances ON project_instances.project_id = projects.id "
      @joins << "INNER JOIN project_instance_mixes ON project_instances.id = project_instance_mixes.project_instance_id "

    end
  end

  def self.get_valid_min_max_limits(column, filters)
    query = "SELECT ROUND(MIN(#{column})) as MIN, ROUND(MAX(#{column})) AS MAX FROM project_instance_mix_views "
    query += @joins.uniq.join(" ")
    query += " WHERE #{build_conditions_new(filters, column)} AND #{column} > 1"
    ActiveRecord::Base.connection().execute(query)
  end

  def self.get_bimesters filters
    bimesters = []

    if filters[:to_period].nil?
      first = ProjectInstance.find(:first, :select => "bimester, year", :group => "year, bimester", :order => "year, bimester")
      last = ProjectInstance.find(:first, :select => "bimester, year", :group => "year, bimester", :order => "year desc, bimester desc")
      bimesters = Period.get_between_periods(first.bimester.to_i, first.year.to_i, last.bimester.to_i, last.year.to_i, 1)

    else
      bimesters = Period.get_periods(filters[:to_period].to_i, filters[:to_year].to_i, BIMESTER_QUANTITY, 1)
    end

    bimesters
  end

  private

  def get_agency_by_rol(rol)
    agency = nil
    self.agency_rols.each do |ar|
      return ar.agency if ar.rol == rol
    end

    agency = Agency.new
    agency.name = 'none'

    return agency
  end

  def generate_code
    return unless self.code.nil? 

    select = "select code from projects where county_id = #{self.county.id} order by id desc limit 2;"
    result = Util.execute(select)
    code = result[0]['code'].split('-')[1]
    code_number = code.gsub(/[^1-9]/, '').to_i + 1
    type = self.project_type.name[0, 1]
    self.code = self.county.code + "-" + type + "%04d" % code_number.to_s
  end

  def date_format
    check_date_format self.build_date
    check_date_format self.sale_date
    check_date_format self.transfer_date
    check_date_format self.pilot_opening_date
  end

  def check_date_format(date)
    if date.split('/').count != 3
      self.build_date.errors.add_to_base("La fecha no tiene el formato esperado. El formato debe ser 'dd/mm/aaaa'")
    else
      d, m, y = date.split('/')
      if !(1..31).include? d.to_i
        self.build_date.errors.add_to_base("El dia debe ser un valor entre 1 y 31 (dd/mm/aaaa)")
      end

      if !(1..12).include? m.to_i
        self.build_date.errors.add_to_base("El mes debe ser un valor entre 1 y 12 (dd/mm/aaaa)")
      end
    end
  end
  def self.house_general(global_information)
p "paso"
        general_data =  {:label => I18n.t(:AVG_M2_FIELD), :value => NumberFormatter.format(global_information[:ps_terreno], true)} 
end
  def  self.department_general(global_information)

        general_data = {:label => I18n.t(:AVG_TERRACE_AREA), :value => NumberFormatter.format(global_information[:pp_terrace], true)} 
end

  def self.summary f

    filters  = JSON.parse(f.to_json, {:symbolize_names=> true})
    begin
      global_information = Project.find_globals(filters)
      general_data = [
        {:label => I18n.t(:TOTAL_PROJECTS_COUNT), :value => NumberFormatter.format(global_information[:project_count], false)},
        {:label => I18n.t(:TOTAL_STOCK), :value => NumberFormatter.format(global_information[:total_units], false)},
        {:label => I18n.t(:SELLS), :value => NumberFormatter.format(global_information[:total_sold], false)},
        {:label => I18n.t(:AVAILABLE_STOCK), :value => NumberFormatter.format(global_information[:total_stock], false)},
        {:label => I18n.t(:PP_UTILES), :value => NumberFormatter.format(global_information[:pp_utiles], true)},
        {:label => I18n.t(:PP_UF), :value => NumberFormatter.format(global_information[:pp_uf], false)},
        {:label => I18n.t(:PP_UF_M2), :value => NumberFormatter.format(global_information[:pp_uf_dis_dpto], true)},
        {:label => I18n.t(:PP_UF_M2_C), :value => NumberFormatter.format(global_information[:pp_uf_dis_home], true)},
        {:label => I18n.t(:VHMO), :value => NumberFormatter.format(global_information[:vhmo], true)},
        {:label => I18n.t(:VHMD), :value => NumberFormatter.format(global_information[:vhmd], true)},
        {:label => I18n.t(:MASD), :value => NumberFormatter.format(global_information[:masd], true)}
      ]

      general_data << house_general(global_information) if !global_information[:ps_terreno].nil?
      general_data << department_general(global_information) if !global_information[:pp_terrace].nil?


      pstatus = Project.projects_group_by_count('project_statuses', filters, false)
      ptypes = Project.projects_group_by_count('project_types', filters, true)
      pmixes = Project.projects_group_by_mix('mix', filters)
      avai = Project.projects_sum_by_stock(filters)
      uf_values = Project.projects_by_uf(filters)
      uf_m2_values = Project.projects_by_uf_m2(filters)
      uarea = Project.projects_by_usable_area(filters)
      garea = Project.projects_by_ground_area('ground_area', filters)

      sbim = Project.projects_count_by_period('sale_bimester', filters)
      cfloor = Project.projects_by_ranges('floors', filters)
      uf_ranges = Project.projects_by_ranges('uf_avg_percent', filters)

      agencies = Project.projects_group_by_count('agencies', filters, false)

      result =[]
      data =[]
      #GENERAL
      general_data.each do |item|
        data.push("name": item[:label], "count":("%.1f" % item[:value]).to_f)
      end

    result.push({"title":"Información General", "data": data})

      ##ESTADO PROYECTO

      data =[]
      pstatus.each do |item|
        data.push("name": item.name.capitalize, "count": item.value.to_i, "id":item.id)
      end
      result.push({"title":"Estado del Proyecto", "series":[{"data": data}]})

      ##TIPO PROYECTO
      data =[]

      ptypes.each do |item|
        data.push("name": item.name.capitalize, "count": item.value.to_i, "id":item.id)
      end
      result.push({"title":"Tipo de Propiedad", "series":[{"data": data}]})

      ##MIX
      data =[]

      stock_units =[]
      sold_units =[]
      categories=[]
      pmixes.each do |item|
        stock_units.push("name":item.mix_type, "count": item[:stock_units], "id":item.id)
        sold_units.push("name":item.mix_type, "count": item[:sold_units], "id":item.id)
      end
      categories.push({"label":"Venta Total", "data": sold_units});
      categories.push({"label":"Disponibilidad", "data": stock_units});
      result.push({"title":"Total Distribución por Mix", "series":categories})

      ##OFERTA, VENTA
      total_units=[]
      sold_units=[]
      stock_units=[]
      categories=[]
      avai.each do |item|
        total_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:total_units].to_i)
        sold_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:sold_units].to_i)
        stock_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:stock_units].to_i)
      end
      categories.push({"label":"Oferta", "data": total_units});
      categories.push({"label":"Venta", "data": sold_units});
      categories.push({"label":"Disponibilidad", "data": stock_units});
      result.push({"title":"Oferta, Venta y Disponibilidad por Bimestre", "series":categories})

      ##VALOR UF BIMESTRE
      #result[:data] << [""]
      min =[]
      max =[]
      avg =[]
      categories=[]
      uf_values.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end

      categories.push({"label":"Mínimo", "data": min});
      categories.push({"label":"Máximo", "data": max});
      categories.push({"label":"Promedio", "data": avg});

      result.push({"title":"Valor UF por Bimestre", "series":categories})

      ##VALOR UF/M2 BIMESTRE
      min =[]
      max =[]
      avg =[]
      categories=[]
      uf_m2_values.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end
      categories.push({"label":"Mínimo", "data": min});
      categories.push({"label":"Máximo", "data": max});
      categories.push({"label":"Promedio", "data": avg});

      result.push({"title":"UF/m2 por Bimestre", "series":categories})

      ##SUP UTIL BIMESTRE
      min =[]
      max =[]
      avg =[]
      categories=[]
      uarea.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end
      categories.push({"label":"Mínimo", "data": min});
      categories.push({"label":"Máximo", "data": max});
      categories.push({"label":"Promedio", "data": avg});

      result.push({"title":"Superficie Útil (m2) por Bimestre", "series":categories})

      ##SUP TERR BIMESTRE
      min =[]
      max =[]
      avg =[]
      categories=[]
      #result[:data] << [""]
      #result[:data] << ["Superficie Terreno/Terraza(m2) por Bimestre"]
      #result[:data] << ["Bimestre", "Mínimo", "Máximo", "Promedio"]

      garea.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end
      categories.push({"label":"Mínimo", "data": min});
      categories.push({"label":"Máximo", "data": max});
      categories.push({"label":"Promedio", "data": avg});

      result.push({"title":"Superficie Terreno/Terraza (m2) por Bimestre", "series":categories})

      ##CANT PROYECTOS BIMESTER
      data =[]

      sbim.each do |item|
        data.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:value].to_i)
      end
      result.push({"title":"Cantidad de Proyectos por Bimestre", "series":[{"data": data}]})

      ##CANT PISOS
      data =[]

      cfloor.each do |item|
        data.push("name": (item.min_value.to_i.to_s + " - " + item.max_value.to_i.to_s), "count": item.value.to_i)
      end
      result.push({"title":"Cantidad de Pisos", "series":[{"data": data}]})

      ##UNIDADES POR RANGO UF
      data =[]

      uf_ranges.each do |item|
        data.push("name": (item.min_value.to_i.to_s + " - " + item.max_value.to_i.to_s), "count": item.value.to_i)
      end
      result.push({"title":"Unidades Proyecto por Rango UF", "series":[{"data": data}]})

      data =[]
      agencies.each do |agency|
        data.push("name": agency.name, "id":agency.id)
      end
    result.push({"title": "Inmobiliarias", "data":data})


    rescue
      #result[:data] = ["Sin datos"]
    end
  end

  def self.reports filters
  @project_departments = ProjectDepartmentReport.where(county_id: filters[:county_id], year: filters[:to_year], bimester: filters[:to_period]).limit(11)
  @project_homes = ProjectHomeReport.where(county_id: filters[:county_id], year: filters[:to_year], bimester: filters[:to_period]).limit(11)
    return @project_homes, @project_departments
  end

  def self.list_projects filters
    select = "projects.code, "
    select = "projects.name, "
    select += "projects.address, "
    select += "sum (project_instance_mixes.total_units) as total_units, "
    select += "sum(project_instance_mixes.stock_units) as stock_units, "
    select += "(sum(project_instance_mixes.total_units) - sum(project_instance_mixes.stock_units)) as  sold_units, "
    select += "sum (CASE masud(project_instance_mixes.total_units, project_instance_mixes.stock_units, cadastre, projects.sale_date) "
    select += "WHEN 0 THEN 0::real "
    select += "ELSE vhmu(project_instance_mixes.total_units, project_instance_mixes.stock_units, cadastre, projects.sale_date) "
    select += "END) AS vhmud, "
    select += "project_types.name as project_types_name "

    data = Project.joins(:project_type, project_instances:[:project_status, :project_instance_mixes]).
                     where(county_id: 50, project_type_id: 2).
                     select(select).
                     group(:code, :name, :address, :project_types_name ).
                     limit(10)
    data 
  end

  def self.information_general_department filters

    select = "COUNT(DISTINCT(project_id)) as project_count, "
    select += "Min(vhmud) as min_selling_speed1, "
    select += "Max(vhmud) as max_selling_speed1, "
    select += "avg(vhmud) as avg_selling_speed1, "
    select += "SUM(total_units) as total_units1, "
    select += "SUM(project_instance_mix_views.stock_units) as total_stock1, "
    select += "(SUM(total_units) - SUM(project_instance_mix_views.stock_units)) as total_sold, "
    select += "round((CASE SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END) WHEN 0 THEN SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 "
    select += "END) ELSE SUM(project_instance_mix_views.stock_units)/SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END) END),1) AS spend_stock_months1, "
    select += "MIN(uf_min_percent) as min_uf1, "
    select += "MAX(uf_max_percent) as max_uf1, "
    select += "round((CASE SUM(project_instance_mix_views.total_m2) WHEN 0 THEN 0 ELSE SUM(project_instance_mix_views.total_m2 * project_instance_mix_views.uf_avg_percent)/SUM(project_instance_mix_views.total_m2)  END),1) AS  avg_uf1,"
    select += "ROUND(MIN(project_instance_mix_views.uf_m2),2) as min_uf_m21, "
    select += "ROUND(MAX(project_instance_mix_views.uf_m2),2) as max_uf_m21, "
    select += "CASE SUM(project_instance_mix_views.total_m2) WHEN 0 THEN 0 else "
    select += "round(SUM(project_instance_mix_views.total_m2 * uf_avg_percent) / (SUM(project_instance_mix_views.total_m2 * (mix_usable_square_meters + 0.5 * mix_terrace_square_meters))),1) end as avg_uf_m2,"
    select += "round(MIN(project_instance_mix_views.mix_usable_square_meters),1) as min_usable_square_m21, "
    select += "MAX(mix_usable_square_meters) as max_usable_square_m21, "
    select += "round((CASE SUM(project_instance_mix_views.total_units) WHEN 0 THEN 0 ELSE SUM(project_instance_mix_views.mix_usable_square_meters * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units)END),1) AS avg_usable_square_m21, "
    select += "MIN(mix_terrace_square_meters) as min_terrace_square_m21, "
    select += "MAX(mix_terrace_square_meters) as max_terrace_square_m21, "
    select += "round(CASE SUM(project_instance_mix_views.total_units) WHEN 0 THEN 0 ELSE SUM(project_instance_mix_views.mix_terrace_square_meters * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units) END, 1) AS avg_terrace_square_m21, "
    select += "MIN(project_instance_mix_views.uf_m2) as min_m2_field1, "
    select += "MAX(project_instance_mix_views.uf_m2) as max_m2_field1, "
    select += "(SUM(total_units * project_instance_mix_views.uf_m2) / SUM(total_units)) as avg_m2_field1, "
    select += "MIN(total_m2) as min_m2_built1, "
    select += "MAX(total_m2) as max_m2_built1, "
    select += "(SUM(total_units * total_m2) / SUM(total_units)) as avg_m2_built1 "

    data = ProjectInstanceMixView.
                     where(county_id: 50, project_type_id: 2).
                     select(select).
                     limit(10)
    data 

  end


  def self.information_general_house filters

    select = "COUNT(DISTINCT(project_id)) as project_count, "
    select += "Min(vhmud) as min_selling_speed, "
    select += "Max(vhmud) as max_selling_speed, "
    select += "avg(vhmud) as avg_selling_speed, "
    select += "SUM(total_units) as total_units, "
    select += "SUM(project_instance_mix_views.stock_units) as total_stock, "
    select += "(SUM(total_units) - SUM(project_instance_mix_views.stock_units)) as total_sold, "
    select += "CASE SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END) WHEN 0 THEN SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END) "
    select += "ELSE SUM(project_instance_mix_views.stock_units)/SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END) END AS spend_stock_months1, "
    select += "MIN(uf_min_percent) as min_uf, "
    select += "MAX(uf_max_percent) as max_uf, "
    select += "ROUND(sum(uf_avg_percent * total_m2 )/ sum(total_m2),2) as avg_uf, "
    select += "ROUND((MIN(project_instance_mix_views.uf_m2_home))::numeric,2) as min_uf_m2, "
    select += "ROUND((MAX(project_instance_mix_views.uf_m2_home))::numeric ,2) as max_uf_m2, "
    select += "CASE SUM(project_instance_mix_views.ps_terreno) WHEN 0 THEN 0 "
    select += "ELSE (SUM(project_instance_mix_views.total_m2 * uf_avg_percent) / (SUM(project_instance_mix_views.total_m2 * (mix_usable_square_meters + 0.25 * ps_terreno))))  END AS avg_uf_m2, "
    select += "MIN(mix_usable_square_meters) as min_usable_square_m2, "
    select += "MAX(mix_usable_square_meters) as max_usable_square_m2, "
    select += "CASE SUM(project_instance_mix_views.total_units) WHEN 0 THEN 0 "
    select += "ELSE SUM(project_instance_mix_views.mix_usable_square_meters * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units)END AS avg_m2_util, "
    select += "MIN(mix_terrace_square_meters) as min_terrace_square_m2, "
    select += "MAX(mix_terrace_square_meters) as max_terrace_square_m2, "
    select += "(SUM(total_units * mix_terrace_square_meters) / SUM(total_units)) as avg_terrace_square_m2, "
    select += "MIN(project_instance_mix_views.uf_m2_home) as min_m2_field, "
    select += "MAX(project_instance_mix_views.uf_m2_home) as max_m2_field, "
    select += "SUM((project_instance_mix_views.t_min + project_instance_mix_views.t_max)/2 * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units) as avg_m2_field, "
    select += "MIN(total_m2) as min_m2_built, "
    select += "MAX(total_m2) as max_m2_built, "
    select += "(SUM(total_units * total_m2) / SUM(total_units)) as avg_m2_built"
     

    data = ProjectInstanceMixView.
                     where(county_id: 50, project_type_id: 1).
                     select(select).
                     limit(10)
    data 
  end

  def self.reports_pdf filters

      result =[]
      list_project = list_projects filters
      pmixes = Project.projects_group_by_mix('mix', filters)
      avai = Project.projects_sum_by_stock(filters)
      uf_values = Project.projects_by_uf(filters)
      uf_m2_values = Project.projects_by_uf_m2(filters)
      pstatus = Project.projects_group_by_count('project_statuses', filters, false)
      info_department = Project.information_general_department filters
      info_house = Project.information_general_house filters

      result.push({"list_projet":list_project})
      
      result.push({"info_department": info_department})
      result.push({"info_house": info_house})
      
      data =[]
      stock_units =[]
      sold_units =[]
      categories=[]
      pmixes.each do |item|
        stock_units.push("name":item.mix_type, "count": item[:stock_units], "id":item.id)
        sold_units.push("name":item.mix_type, "count": item[:sold_units], "id":item.id)
      end
      categories.push({"label":"Vendidas", "data": sold_units});
      categories.push({"label":"Disponibles", "data": stock_units});
      result.push({"title":"Mix de Unidades", "series":categories})

      ##OFERTA, VENTA
      total_units=[]
      sold_units=[]
      stock_units=[]
      categories=[]
      avai.each do |item|
        total_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:total_units].to_i)
        sold_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:sold_units].to_i)
        stock_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:stock_units].to_i)
      end
      categories.push({"label":"Oferta Total", "data": total_units});
      categories.push({"label":"Ventas Total", "data": sold_units});
      categories.push({"label":"Disponibilidad Total", "data": stock_units});
      result.push({"title":"Evolución Stock Total, Venta y Disponibilidad", "series":categories})

      ##VALOR UF BIMESTRE
      #result[:data] << [""]
      min =[]
      max =[]
      avg =[]
      categories=[]
      uf_values.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end

      categories.push({"label":"UF Mínimo", "data": min});
      categories.push({"label":"UF Máximo", "data": max});
      categories.push({"label":"UF Promedio", "data": avg});

      result.push({"title":"Evolución Precio en UF", "series":categories})

      min =[]
      max =[]
      avg =[]
      categories=[]
      uf_m2_values.each do |item|
        min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
        max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
        avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
      end
      categories.push({"label":"UF Mínimo", "data": min});
      categories.push({"label":"UF Máximo", "data": max});
      categories.push({"label":"UF Promedio", "data": avg});

      result.push({"title":"Evolución Precio en UF/m2", "series":categories})

      ##ESTADO PROYECTO

      data =[]
      pstatus.each do |item|
        data.push("name": item.name.capitalize, "count": item.value.to_i, "id":item.id)
      end
      result.push({"title":"Estado de los Proyectos", "series":[{"data": data}]})

    result
  end
  def self.interval_graduated_points(params)
@pp = params
    if !params[:county_id].nil?
      conditions = "county_id = #{params[:county_id]}"
    elsif !params[:wkt].nil?
      conditions = WhereBuilder.build_within_condition(params[:wkt])
    else
      conditions = WhereBuilder.build_within_condition_radius(params[:centerpt], params[:radius] )
      end
    
    period_current = Period.get_period_current
    bimester = period_current.bimester
    year = period_current.year
    values = ProjectInstanceMixView.select("COUNT(*) as counter, ROUND(stock_units / 10) as value").
      where(bimester: bimester, year: year).where(conditions).where("stock_units > 0").
      group("ROUND(stock_units / 10)").
      order("counter desc").first

    result = Array.new
    unless values.nil?
      seed = (values["value"].to_i * 10)
      1.upto(Util::INTERVALS_QUANTITY) do
        result << seed
        seed += (values["value"].to_i * 10)
      end
    end
    return result
  end
end
