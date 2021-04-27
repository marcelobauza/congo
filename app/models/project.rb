class Project < ApplicationRecord
  # acts_as_indexed :fields => [:name, :address, :code]
  include Projects::Validations
  include WhereBuilder
  include Util
  include Ranges
  include Projects::Exports
  include Projects::Periods
  include Projects::Scopes

  has_many :project_instances, :dependent => :destroy
  has_many :project_instance_mixes, :through => :project_instances
  has_many :project_statuses, :through => :project_instances
  has_many :agency_rols
  has_many :agencies, :through => :agency_rols
  belongs_to :project_type
  belongs_to :county

  accepts_nested_attributes_for :project_instances, :project_instance_mixes

  delegate :name, :to => :county, :prefix => true, :allow_nil => true
  delegate :name, :to => :get_agency, :prefix => true, :allow_nil => true
  delegate :id, :to => :get_agency, :prefix => true, :allow_nil => true
  delegate :name, :to => :get_constructor, :prefix => true, :allow_nil => true
  delegate :id, :to => :get_constructor, :prefix => true, :allow_nil => true
  delegate :name, :to => :get_seller, :prefix => true, :allow_nil => true
  delegate :id, :to => :get_seller, :prefix => true, :allow_nil => true



  attr_accessor :latitude, :longitude

  before_validation :build_geom
  before_create  :generate_code

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
    selects += " vhmd(project_instance_mix_views.project_instance_id)::numeric as vhmu, "
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

  def self.kpi(county_id, year_from, year_to, bimester, project_type_id, polygon_id )
    if  ((county_id.empty? || polygon_id.empty?) && year_from.empty? && year_to.empty? && bimester.empty? && project_type_id.empty?)
      return;
    end

    if !county_id.empty?
      county      = County.where(id: county_id).first
      county_code = county.code.to_i
    end

    bim_from, bim_to = 1, 6

    if bimester != "0"
      bim_from, bim_to = bimester, bimester
    end

    if !county_id.empty?
      result = ("select inciti_kpi_generate_primary_data(#{county_code}, #{year_from}, #{year_to}, #{bim_from}, #{bim_to}, #{project_type_id})")
    else
      @polygon = ApplicationStatus.find(polygon_id)
      if @polygon.filters['type_geometry'] == 'circle'
        result = ("select kpi__circle_generate_primary_data(#{polygon_id}, #{year_from}, #{year_to}, #{bim_from}, #{bim_to}, #{project_type_id})")
      end
      if @polygon.filters['type_geometry'] == 'polygon'
        result = ("select kpi__polygon_generate_primary_data(#{polygon_id}, #{year_from}, #{year_to}, #{bim_from}, #{bim_to}, #{project_type_id})")
      end
    end
    kpi = Util.execute(result)
  end

  def self.getPrimaryEvolution
    Util.execute("select p.area_name, ppd.* from project_primary_data ppd
                  inner join parcels p on p.id = ppd.parcel_id order by year, bimester")
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

  def self.find_globals(filters, range)

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

    @a = ProjectInstanceMixView.method_selection(filters).
      where(build_conditions_new(filters, nil, true, range)).
      select(select).first
  end

  def self.house_general_information(filters, range)
    select = "CASE SUM(project_instance_mix_views.total_units) WHEN 0 THEN 0 "
    select += "ELSE SUM((project_instance_mix_views.t_min + project_instance_mix_views.t_max)/2 * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units)END AS ps_terreno, "
    select += "CASE SUM(project_instance_mix_views.ps_terreno) WHEN 0 THEN 0 "
    select += "ELSE (SUM(project_instance_mix_views.total_m2 * uf_avg_percent) / (SUM(project_instance_mix_views.total_m2 * (mix_usable_square_meters + 0.25 * ps_terreno))))  END AS pp_uf_dis_home "

    @a = ProjectInstanceMixView.method_selection(filters).
      where(build_conditions_new(filters, nil, true, range)).
      where(project_type_id: 1).
      select(select).first
  end

  #FIND PROJECTS BY WIDGETS. COUNT
  def self.projects_group_by_count(widget, filters, has_color, range)
    case widget
    when 'agencies'
      joins = [:project_instances, [agency_rols: :agency]]
      select = "agencies.name, agencies.id"
      count = "agencies.name"
    when 'project_types'
      joins =  [:project_type, :project_instances]
      select = "#{widget}.id, #{widget}.name"
      select += ", #{widget}.color" if has_color
      count = "#{widget}.name"
    when 'project_statuses'
      joins = [project_instances: :project_status]
      select = "#{widget}.id, #{widget}.name"
      select += ", #{widget}.color" if has_color
      count = "#{widget}.name"
    end

    Project.select( "#{select}, COUNT(#{count}) as value").
      joins(joins).
      where(build_conditions_new(filters, widget, false, range)).
      method_selection(filters).
      group(select).
      order("#{count}")
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

    query_condition = " year = #{filters[:to_year]}  "
    query_condition += " and bimester = #{filters[:to_period]} "
    query_condition += " and " +  WhereBuilder.build_in_condition("project_type_id", filters[:project_type_ids]) if filters.has_key? :project_type_ids
    values = get_valid_min_max_limits(widget, filters)
    ranges = get_valid_ranges(values, widget)
    total_ranges = ranges.count - 1

    result = Array.new

    0.upto(total_ranges) do |i|
      if (widget == 'floors')
        select = "count(distinct(project_id)) as value, #{ranges[i]["min"].to_i} as min_value, #{ranges[i]["max"].to_i} as max_value"
      else
        select = "sum(total_units) as value, #{ranges[i]["min"].to_i} as min_value, #{ranges[i]["max"].to_i} as max_value"
      end
      cond = "#{query_condition} AND " + WhereBuilder.build_between_condition("ROUND(#{widget})", ranges[i]["min"].to_i, ranges[i]["max"].to_i)

      proj = ProjectInstanceMixView.select(select).method_selection(filters).
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

    condition = Util.and + build_conditions_new(filters, widget, true)
    bimesters = get_bimesters filters

    bimesters.each do |bimester|
      cond_query = get_periods_query_new(bimester[:period], bimester[:year]) + condition
      project = ProjectInstanceMixView.select(select).
        where(cond_query).
        method_selection(filters).
        group('year, bimester').
        order('year, bimester').first

      proc.call result, project, bimester
    end
    result.reverse
  end


  def self.projects_by_ground_area(widget, filters)
    projects = Project.joins(:project_instances).method_selection(filters).
      where(build_conditions_new(filters, nil, true, range=false))

    houses, departments = projects.partition {|project| project.project_type_id == 1}

    return nil if houses.present? && departments.present?

    if houses.any?
        select = "min(ps_terreno) as min, "
        select += "max(ps_terreno) as max,"
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
  def self.projects_group_by_mix(widget, filters, range)
    @joins = Array.new
    #BUILD JOINS
    joins_by_widget(widget)

    select = "sum(project_instance_mix_views.stock_units) as stock_units,
              sum(project_instance_mix_views.total_units - project_instance_mix_views.stock_units) as sold_units, "
    select += "project_mixes.mix_type, project_mixes.id"

    if filters.has_key? :mix_ids
      query = " mix_id = #{filters[:mix_ids].join(',')} and "
      query += build_conditions_new(filters, widget, false, range)
    else
      query = build_conditions_new(filters, widget, false, range)
    end

    ProjectInstanceMixView.select(select).
      joins(@joins.uniq.join(" ")).
      where( query).
      method_selection(filters).
      group("project_mixes.mix_type, project_mixes.id").
      order("project_mixes.mix_type")
  end

  def save_project_data(data, project_type, geom)
    ic                                 = Iconv.new('UTF-8', 'ISO-8859-1')
    type                               = ProjectType.find_by_name(project_type)
    county                             = County.find_by(code: data["COMUNA"])
    agency                             = Agency.where(name: data["INMOBILIAR"]).first_or_create!
    agency_rols                        = AgencyRol.find_or_create_by(
      project_id: self.id,
      agency_id: agency.id,
      rol: 'INMOBILIARIA'
    )
    self.code                          = data["COD_PROY"]
    self.address                       = ic.iconv(data["DIRECCION"].gsub("'","''"))
    self.name                          = ic.iconv(data["NOMBRE"])
    self.floors                        = data["N_PISOS"].to_i
    self.agency_id                     = agency.id
    self.project_type_id               = type.id
    self.county_id                     = county.id
    self.the_geom                      = geom
    self.build_date                    = data['INI_CONST']
    self.sale_date                     = data['INI_VTAS']
    self.transfer_date                 = data['ENTREGA']
    self.pilot_opening_date            = data['ESTRENO']
    self.elevators                     = data['ASC']
    self.quantity_department_for_floor = data["DPTO_PISO"]

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

  def build_geom
    self.the_geom = "POINT(#{self.longitude.to_f}  #{self.latitude.to_f})" if self.latitude and self.longitude
  end

  def self.build_conditions_new(filters, self_not_filter=nil, useView = false, range=true, agencies_not_filter=false)
    @conditions = ''
    if filters.has_key? :to_period and range == true
      @conditions += WhereBuilder.build_range_periods_by_bimester_projects(filters[:to_period], filters[:to_year], BIMESTER_QUANTITY, useView)
    else
      @conditions += "bimester = #{filters[:to_period]} AND year = #{filters[:to_year]}" + Util.and
    end
    if range == true
      @conditions += bimesters_condition(filters, self_not_filter, useView)
    end
    @conditions += between_condition_new(filters, self_not_filter)
    @conditions += ids_conditions_new(filters, self_not_filter, useView) if agencies_not_filter == false

    @conditions += "county_id IN(#{CountiesUser.where(user_id: filters[:user_id]).pluck(:county_id).join(",")})#{Util.and}" if CountiesUser.where(user_id: filters[:user_id]).count > 0
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

  def self.between_condition_new(filters, self_not_filter)
    conditions = ""

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

  def self.ids_conditions_new(filters, self_not_filter, useView = false)
    conditions = ""
    #PROJECT STATUSES
    if filters.has_key? :project_status_ids and self_not_filter != 'project_statuses'
      query_field = useView ? "project_status_id" : "project_status_id"
      conditions += WhereBuilder.build_in_condition(query_field, filters[:project_status_ids])
      conditions += Util.and
    end

    #PROJECT TYPES
    if filters.has_key? :project_type_ids
      query_field = useView ? "project_type_id" : "project_type_id"
      conditions += WhereBuilder.build_in_condition("project_type_id", filters[:project_type_ids])
      conditions += Util.and
    end

    #MIXES funciona
    if filters.has_key? :mix_ids and self_not_filter != 'mix'
      query_field = useView ? "project_instance_mix_views.project_instance_id":  "project_instances.id"
      conditions += "#{query_field}  IN (SELECT project_instance_id "
      conditions += "FROM project_instance_mixes WHERE mix_id IN(#{filters[:mix_ids].join(",")}))"
      conditions += Util.and
    end
    #terminar condicion con la relacion de las agencias
    #AGENCIES
    if filters.has_key? :project_agency_ids and self_not_filter != 'agencies'
      conditions += " agency_id IN (#{filters[:project_agency_ids].join(",")}) "
      conditions += Util.and
    end
    conditions

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
      @joins << "INNER JOIN project_statuses ON project_statuses.id = project_instance_mix_views.project_status_id "
    when 'mix'
      #@joins << "INNER JOIN project_instances ON project_instances.project_id = projects.id "
      #@joins << "INNER JOIN project_instance_mixes ON project_instances.id = project_instance_mixes.project_instance_id "
      @joins << "INNER JOIN project_mixes ON project_instance_mix_views.mix_id = project_mixes.id "

    when 'stock', 'usable_area', 'uf', 'uf_m2', 'ground_area', 'sale_bimester', 'floors', 'uf_value'
      @joins << "INNER JOIN project_instances ON project_instances.project_id = projects.id "
      @joins << "INNER JOIN project_instance_mixes ON project_instances.id = project_instance_mixes.project_instance_id "

    end
  end

  def self.get_valid_min_max_limits(column, filters, useView = true)

    ProjectInstanceMixView.method_selection(filters).
      where(build_conditions_new(filters, column, useView)).
      where("#{column} > 1" ).
      select("ROUND(MIN(#{column})) as MIN, ROUND(MAX(#{column})) AS MAX")
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

  def self.periods bimester, year
    where(project_instances: {bimester:  bimester, year: year})
  end

  def self.method_selection filters
    if !filters[:county_id].nil?
      where(county_id: filters[:county_id])
    elsif !filters[:wkt].nil?
      where(WhereBuilder.build_within_condition(filters[:wkt]))
    else
    where(WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] ))
    end
  end

  def self.download_csv filters
    data = Project.joins(:project_instances).select("st_x(the_geom) as longitude, st_y(the_geom) as latitude",:name).
      method_selection(filters).
      periods(filters[:to_period], filters[:to_year])
    data
  end

  def self.to_csv(options = {})
    desired_column = ['latitude','longitude', 'name']
    header_names = ['Latitud', 'Longitud', 'Nombre']

    CSV.generate(options) do |csv|
      csv << header_names
      all.each do |product|
        csv << product.attributes.values_at(*desired_column)
      end
    end
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
    code = Project.where(county_id: self.county.id).order(id: :desc).first
    code = result[0]['code'].split('-')[1]
    code_number = code.gsub(/[^1-9]/, '').to_i + 1
    type = self.project_type.name[0, 1]
    self.code = self.county.code.to_s + "-" + type + "%04d" % code_number.to_i
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
        general_data =  {label: I18n.t(:AVG_M2_FIELD), value: global_information[:ps_terreno]}
end
  def  self.department_general(global_information)

        general_data = {label: I18n.t(:AVG_TERRACE_AREA), value: global_information[:pp_terrace]}
end

  def self.projects_by_agencies filters
    joins = [:project_instances, [agency_rols: :agency]]
    select = "agencies.name, agencies.id"
    count = "agencies.name"

    @a = Project.select( "#{select}, COUNT(#{count}) as value").
      joins(joins).
      where(build_conditions_new(filters, 'agencies', false, false, true)).
      method_selection(filters).
      where(agency_rols: {rol: 'INMOBILIARIA'}).
      group(select).
      order("#{count}")

    if filters.has_key? :project_agency_ids
      @a = @a.filter_by_agencies(filters)
    end
    @a
  end

  def self.filter_by_agencies filters
    where("agency_rols.agency_id IN (#{filters[:project_agency_ids].join(',')})")
  end

  def self.summary f

    filters  = JSON.parse(f.to_json, {:symbolize_names=> true})

    UserPolygon.save_polygons_for_user f

    begin
      global_information = Project.find_globals(filters, false)
      house_information = Project.house_general_information(filters, false)

      general_data = [
        {label: I18n.t(:TOTAL_PROJECTS_COUNT), value: global_information[:project_count]},
        {label: I18n.t(:TOTAL_STOCK), value: global_information[:total_units]},
        {label: I18n.t(:SELLS), value: global_information[:total_sold]},
        {label: I18n.t(:AVAILABLE_STOCK), value: global_information[:total_stock]},
        {label: I18n.t(:PP_UTILES), value: global_information[:pp_utiles]},
        {label: I18n.t(:PP_UF), value: global_information[:pp_uf].to_i},
        {label: I18n.t(:PP_UF_M2), value: global_information[:pp_uf_dis_dpto]},
        {label: I18n.t(:PP_UF_M2_C), value: house_information[:pp_uf_dis_home]},
        {label: I18n.t(:VHMO), value: global_information[:vhmo]},
        {label: I18n.t(:VHMD), value: global_information[:vhmd]},
        {label: I18n.t(:MASD), value: global_information[:masd]}
      ]
      general_data << house_general(house_information) if !house_information[:ps_terreno].nil?
      general_data << department_general(global_information) if !global_information[:pp_terrace].nil?
      pstatus      = Project.projects_group_by_count('project_statuses', filters, false,false)
      ptypes       = Project.projects_group_by_count('project_types', filters, true, false)
      pmixes       = Project.projects_group_by_mix('mix', filters, false)
      avai         = Project.projects_sum_by_stock(filters)
      uf_values    = Project.projects_by_uf(filters)
      uf_m2_values = Project.projects_by_uf_m2(filters)
      uarea        = Project.projects_by_usable_area(filters)
      garea        = Project.projects_by_ground_area('ground_area', filters)
      sbim         = Project.projects_count_by_period('sale_bimester', filters)
      cfloor       = Project.projects_by_ranges('floors', filters)
      uf_ranges    = Project.projects_by_ranges('uf_avg_percent', filters)
      agencies     = projects_by_agencies filters
      result       = []
      data         = []

      #GENERAL
      general_data.each do |item|
        data.push("name": item[:label], "count": ("%.1f" % item[:value]).to_f) if !item[:value].nil?
      end
      result.push({"title":"Resumen", "data": data})
      ##ESTADO PROYECTO

      data =[]

      pstatus.each do |item|
        data.push("name": item.name.capitalize, "count": item.value.to_i, "id":item.id)
      end
      result.push({"title":"Estado Obra", "series":[{"data": data}]})

      ##TIPO PROYECTO
      data =[]

      ptypes.each do |item|
        data.push("name": item.name.capitalize, "count": item.value.to_i, "id":item.id)
      end
      result.push({"title":"Uso", "series":[{"data": data}]})

      ##MIX
      data        = []
      stock_units = []
      sold_units  = []
      categories  = []

      pmixes.each do |item|
        stock_units.push("name":item.mix_type, "count": item[:stock_units], "id":item.id)
        sold_units.push("name":item.mix_type, "count": item[:sold_units], "id":item.id)
      end
      categories.push({"label":"Venta Total", "data": sold_units});
      categories.push({"label":"Disponibilidad", "data": stock_units});
      result.push({"title":"Venta & Disponibilidad por Programa", "series":categories})

      ##OFERTA, VENTA
      total_units = []
      sold_units  = []
      stock_units = []
      categories  = []

      avai.each do |item|
        total_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:total_units].to_i)
        sold_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:sold_units].to_i)
        stock_units.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:stock_units].to_i)
      end
      categories.push({"label":"Oferta", "data": total_units});
      categories.push({"label":"Venta", "data": sold_units});
      categories.push({"label":"Disponibilidad", "data": stock_units});
      result.push({"title":"Oferta, Venta & Disponibilidad", "series":categories})

      ##VALOR UF BIMESTRE
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

      result.push({"title":"Precio | UF", "series":categories})
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

      result.push({"title":"Precio Promedio | UFm² Útil", "series":categories})

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

      result.push({"title":"Superficie Útil | m²", "series":categories})

      if garea
        ##SUP TERR BIMESTRE
        min =[]
        max =[]
        avg =[]
        categories=[]

        garea.each do |item|
          min.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:min].to_i)
          max.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:max].to_i)
          avg.push("name":(item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":  item[:avg].to_i)
        end

        categories.push({"label":"Mínimo", "data": min});
        categories.push({"label":"Máximo", "data": max});
        categories.push({"label":"Promedio", "data": avg});

        result.push({"title":"Superficie T | m²", "series":categories})
      end

      ##CANT PROYECTOS BIMESTER
      data =[]

      sbim.each do |item|
        data.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count": item[:value].to_i)
      end
      result.push({"title":"Proyectos en Venta", "series":[{"data": data}]})

      ##CANT PISOS
      data =[]

      cfloor.each do |item|
        data.push("name": (item.min_value.to_i.to_s + " - " + item.max_value.to_i.to_s), "count": item.value.to_i)
      end
      result.push({"title":"Proyectos por Altura", "series":[{"data": data}]})

      ##UNIDADES POR RANGO UF
      data =[]

      uf_ranges.each do |item|
        data.push("name": (item.min_value.to_i.to_s + " - " + item.max_value.to_i.to_s), "count": item.value.to_i)
      end
      result.push({"title":"Unidades Proyecto por Rango UF", "series":[{"data": data}]})
      #Agencias
      data =[]
      agencies.each do |agency|
        data.push("name": agency.name, "id":agency.id)
      end
      result.push({"title": "Proyectos por Inmobiliaria", "data":data})

    rescue
      #result[:data] = ["Sin datos"]
    end
    @result = result
  end

  def self.reports filters
    if !filters[:county_id].nil?
      conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id])
    elsif !filters[:wkt].nil?
      conditions = WhereBuilder.build_within_condition(filters[:wkt])
    else
      conditions = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] )
    end

    @project_departments = ProjectDepartmentReport.
      where(conditions).
      where( year: filters[:to_year], bimester: filters[:to_period]).
      filters_project_types(filters).
      filters_status_projects(filters)

    @project_homes = ProjectHomeReport.
      where(conditions).
      where(year: filters[:to_year], bimester: filters[:to_period]).
      filters_project_types(filters).
      filters_status_projects(filters)

    return @project_homes, @project_departments
  end

  def self.list_projects filters

    select = "code as code, "
    select += "projects.name, "
    select += "projects.address, "
    select += "sum (project_instance_mixes.total_units) as total_units, "
    select += "sum(project_instance_mixes.stock_units) as stock_units, "
    select += "(sum(project_instance_mixes.total_units) - sum(project_instance_mixes.stock_units)) as  sold_units, "
    select += "sum (CASE masud(project_instance_mixes.total_units, project_instance_mixes.stock_units, cadastre, projects.sale_date) "
    select += "WHEN 0 THEN 0::real "
    select += "ELSE round(vhmu(project_instance_mixes.total_units, project_instance_mixes.stock_units, cadastre, projects.sale_date)::numeric,1) "
    select += "END) AS vhmud, "
    select += "project_types.name as project_types_name, "
    select += "agencies.name as agencyname"

    data = Project.
      joins(:project_type, agency_rols: :agency, project_instances:[:project_status, :project_instance_mixes]).
      method_selection(filters).where(project_instances: {year: filters[:to_year], bimester: filters[:to_period]}).
      where("agency_rols.rol = 'INMOBILIARIA'").
      select(select).
      group(:code, :name, :address, :project_types_name, 'agencies.name' ).uniq
    data
  end

  def self.information_general_department filters

    select = "COUNT(DISTINCT(project_id)) as project_count, "
    select += "round(Min(vhmud)::numeric, 1) as min_selling_speed1, "
    select += "round(Max(vhmud)::numeric, 1) as max_selling_speed1, "
    select += "round(avg(vhmud)::numeric, 1) as avg_selling_speed1, "
    select += "round(SUM(total_units),1) as total_units1, "
    select += "round(SUM(project_instance_mix_views.stock_units),1) as total_stock1, "
    select += "round((SUM(total_units) - SUM(project_instance_mix_views.stock_units)),1) as total_sold, "
    select += "round((CASE SUM(CASE WHEN masud > 0 THEN round(vhmu::numeric, 1) ELSE 0 END) WHEN 0 THEN SUM(CASE WHEN masud > 0 THEN round(vhmu::numeric, 1) ELSE 0 "
    select += "END) ELSE SUM(project_instance_mix_views.stock_units)/SUM(CASE WHEN masud > 0 THEN round(vhmu::numeric, 1) ELSE 0 END) END),1) AS spend_stock_months1, "
    select += "round(MIN(uf_min_percent),1) as min_uf1, "
    select += "round(MAX(uf_max_percent),1) as max_uf1, "
    select += "round((CASE SUM(project_instance_mix_views.total_m2) WHEN 0 THEN 0 ELSE SUM(project_instance_mix_views.total_m2 * project_instance_mix_views.uf_avg_percent)/SUM(project_instance_mix_views.total_m2)  END),1) AS  avg_uf1,"
    select += "ROUND(MIN(project_instance_mix_views.uf_m2),2) as min_uf_m21, "
    select += "ROUND(MAX(project_instance_mix_views.uf_m2),2) as max_uf_m21, "
    select += "CASE SUM(project_instance_mix_views.total_m2) WHEN 0 THEN 0 else "
    select += "round(SUM(project_instance_mix_views.total_m2 * uf_avg_percent) / (SUM(project_instance_mix_views.total_m2 * (mix_usable_square_meters + 0.5 * mix_terrace_square_meters))),1) end as avg_uf_m2,"
    select += "round(MIN(project_instance_mix_views.mix_usable_square_meters),1) as min_usable_square_m21, "
    select += "round(MAX(mix_usable_square_meters),1) as max_usable_square_m21, "
    select += "round((CASE SUM(project_instance_mix_views.total_units) WHEN 0 THEN 0 ELSE SUM(project_instance_mix_views.mix_usable_square_meters * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units)END),1) AS avg_usable_square_m21, "
    select += "round(MIN(mix_terrace_square_meters),1) as min_terrace_square_m21, "
    select += "round(MAX(mix_terrace_square_meters),1) as max_terrace_square_m21, "
    select += "round(CASE SUM(project_instance_mix_views.total_units) WHEN 0 THEN 0 ELSE SUM(project_instance_mix_views.mix_terrace_square_meters * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units) END, 1) AS avg_terrace_square_m21, "
    select += "round(MIN(project_instance_mix_views.uf_m2),1) as min_m2_field1, "
    select += "round(MAX(project_instance_mix_views.uf_m2),1) as max_m2_field1, "
    select += "round((SUM(total_units * project_instance_mix_views.uf_m2) / SUM(total_units)),1) as avg_m2_field1, "
    select += "round(MIN(total_m2),1) as min_m2_built1, "
    select += "round(MAX(total_m2),1) as max_m2_built1, "
    select += "round(sum(vhmu),1) as vhmo, "
    select += "round(SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END),1) AS vhmdd, "
    select += "sum(vhmud) as vhmd, "
    select += "round((SUM(total_units * total_m2) / SUM(total_units)),1) as avg_m2_built1 "

    data = ProjectInstanceMixView.method_selection(filters).
      where(year: filters[:to_year], bimester: filters[:to_period], project_type_id: 2).
      select(select)
    data
  end

  def self.information_general_house filters

    select = "round(COUNT(DISTINCT(project_id)),1) as project_count, "
    select += "round(Min(vhmud)::numeric, 1) as min_selling_speed, "
    select += "round(Max(vhmud)::numeric, 1) as max_selling_speed, "
    select += "round(avg(vhmud)::numeric,1) as avg_selling_speed, "
    select += "round(SUM(total_units),1) as total_units, "
    select += "round(SUM(project_instance_mix_views.stock_units),1) as total_stock, "
    select += "round((SUM(total_units) - SUM(project_instance_mix_views.stock_units)),1) as total_sold, "
    select += "CASE SUM(CASE WHEN masud > 0 THEN round(vhmu::numeric, 1) ELSE 0 END) WHEN 0 THEN round(SUM(CASE WHEN masud > 0 THEN round(vhmu::numeric, 1) ELSE 0 END),1) "
    select += "ELSE round(SUM(project_instance_mix_views.stock_units)/SUM(CASE WHEN masud > 0 THEN round(vhmu::numeric, 1) ELSE 0 END),1) END AS spend_stock_months1, "
    select += "round(MIN(uf_min_percent),1) as min_uf, "
    select += "round(MAX(uf_max_percent),1) as max_uf, "
    select += "round(sum(uf_avg_percent * total_m2 )/ sum(total_m2),2) as avg_uf, "
    select += "round((MIN(project_instance_mix_views.uf_m2_home))::numeric,2) as min_uf_m2, "
    select += "round((MAX(project_instance_mix_views.uf_m2_home))::numeric ,2) as max_uf_m2, "
    select += "CASE SUM(project_instance_mix_views.ps_terreno) WHEN 0 THEN 0 "
    select += "ELSE round((SUM(project_instance_mix_views.total_m2 * uf_avg_percent) / (SUM(project_instance_mix_views.total_m2 * (mix_usable_square_meters + 0.25 * ps_terreno))))::numeric, 1)  END AS avg_uf_m2, "
    select += "round(MIN(mix_usable_square_meters),1) as min_usable_square_m2, "
    select += "round(MAX(mix_usable_square_meters),1)  as max_usable_square_m2, "
    select += "round(AVG(mix_usable_square_meters),1) as avg_usable_square_m2, "
    select += "CASE SUM(project_instance_mix_views.total_units) WHEN 0 THEN 0 "
    select += "ELSE SUM(project_instance_mix_views.mix_usable_square_meters * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units) END AS avg_m2_util, "
    select += "round(MIN(project_instance_mix_views.uf_m2_home)::numeric,1) as min_m2_field, "
    select += "round(MAX(project_instance_mix_views.uf_m2_home)::numeric, 1) as max_m2_field, "
    select += "round((SUM((project_instance_mix_views.t_min + project_instance_mix_views.t_max)/2 * project_instance_mix_views.total_units)/SUM(project_instance_mix_views.total_units))::numeric, 1) as avg_m2_field, "
    select += "round(MIN(total_m2),1) as min_m2_built, "
    select += "round(MAX(total_m2),1) as max_m2_built, "
    select += "round(sum(vhmu),1) as vhmo, "
    select += "round(SUM(CASE WHEN masud > 0 THEN vhmu ELSE 0 END),1) AS vhmdd, "
    select += "round(sum(vhmu),1) as vhmo, "
    select += "round((SUM(total_units * total_m2) / SUM(total_units)),1) as avg_m2_built"

    data = ProjectInstanceMixView.method_selection(filters).
      where(year: filters[:to_year], bimester: filters[:to_period], project_type_id: 1).
      select(select)
    data
  end

  def self.reports_pdf filters

    result          = []
    list_project    = list_projects filters
    pmixes          = Project.projects_group_by_mix('mix', filters, false)
    avai            = Project.projects_sum_by_stock(filters)
    uf_values       = Project.projects_by_uf(filters)
    uf_m2_values    = Project.projects_by_uf_m2(filters)
    pstatus         = Project.projects_group_by_count('project_statuses', filters, false, false)
    info_department = Project.information_general_department filters
    info_house      = Project.information_general_house filters

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
    result.push({"title":"Venta & Disponibilidad por Programa", "series":categories})

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
    result.push({"title":"Oferta, Venta & Disponibilidad", "series":categories})

    ##VALOR UF BIMESTRE
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

    result.push({"title":"Precio | UF", "series":categories})

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

    result.push({"title":"Precio Promedio | UFm² Útil", "series":categories})

    ##ESTADO PROYECTO

    data =[]
    pstatus.each do |item|
      data.push("name": item.name.capitalize, "count": item.value.to_i, "id":item.id)
    end
    result.push({"title":"Estado Obra", "series":[{"data": data}]})

    result
  end



  def self.kml_data filters

    select = "projects.name, "
    select += "sum (project_instance_mixes.total_units) as total_units, "
    select += "sum(project_instance_mixes.stock_units) as stock_units, "
    select += "the_geom "

    if !filters[:county_id].nil?
      conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id])
    elsif !filters[:wkt].nil?
      conditions = WhereBuilder.build_within_condition(filters[:wkt])
    else
      conditions = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] )
    end
    data = Project.joins(:project_type, agency_rols: :agency, project_instances:[:project_status, :project_instance_mixes]).
      method_selection(filters).where(project_instances: {year: filters[:to_year], bimester: filters[:to_period]}).where("agency_rols.rol = 'INMOBILIARIA'").
      select(select).
      group(:name, :the_geom ).uniq
    kml = KMLFile.new
    document = KML::Document.new(name: "PRV")
    data.each do |c|
      document.features << KML::Placemark.new(
        name: c.name,
        description: "Viviendas: #{c.total_units}
                        Stock: #{c.stock_units}",
                        geometry: KML::Point.new(coordinates: {
                          lat: c.the_geom.y,
                          lng: c.the_geom.x
                        })
      )
    end
    kml.objects << document
    kml.render
  end
end
