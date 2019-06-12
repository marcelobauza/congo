class FutureProject < ApplicationRecord
  belongs_to :project_type
  belongs_to :future_project_type
  belongs_to :county

  before_validation :build_geom

  include WhereBuilder
  include Util

  validates_presence_of :address,
    :county_id,
    :project_type_id,
    :future_project_type_id,
    :longitude,
    :latitude,
    :code,
    :file_date

  #validate :point_is_located_within_the_specified_county, :unless => "county.nil?"

  # validates_numericality_of :floors, :only_integer => true, :greater_than_or_equal_to => 0, :unless => "floors.blank?"
  # validates_numericality_of :undergrounds, :only_integer => true, :greater_than_or_equal_to => 0, :unless => "undergrounds.blank?"
  # validates_numericality_of :total_units, :only_integer => true, :greater_than_or_equal_to => 0, :unless => "total_units.blank?"
  # validates_numericality_of :total_parking, :only_integer => true, :greater_than_or_equal_to => 0, :unless => "total_parking.blank?"
  # validates_numericality_of :total_commercials, :only_integer => true, :greater_than_or_equal_to => 0, :unless => "total_commercials.blank?"
  # validates_numericality_of :m2_approved, :greater_than_or_equal_to => 0, :unless => "m2_approved.blank?"
  # validates_numericality_of :m2_built, :greater_than_or_equal_to => 0, :unless => 'm2_built.blank?'
  # validates_numericality_of :m2_field, :greater_than_or_equal_to => 0, :unless => 'm2_field.blank?'

  # named_scope :by_project, lambda { |t| {:conditions => {:project_type_id => t}} unless t.blank? }
  #  named_scope :by_future_project_type, lambda { |t| {:conditions => {:future_project_type_id => t}} unless t.blank? }

  BIMESTER_QUANTITY = 6

  def project_type_name
    self.project_type.try(:name)
  end

  def future_project_type_name
    self.future_project_type.try(:name)
  end

  def county_name
    self.county.try(:name)
  end

  def file_date=(val)

    self[:file_date] = val
    #self.bimester = val.to_date.bimester
    #self.year = val.to_date.year
  end

  def save_future_project_data(geom, data, year, bimester, future_type)
    ic = Iconv.new('UTF-8', 'ISO-8859-1')
    p_type = ProjectType.get_project_type_by_first_letter(data["TIPO"])

    county = County.find_by_code(data["COD_COM"].to_i.to_s)
    number_next_project = county.number_last_project_future + 1
    self.code = county.code.to_s + "-EM-"+ number_next_project.to_s
    self.address = ic.iconv(data["DIRECCION"].gsub("'","''")).to_s
    self.name = ic.iconv(data["NOMBRE"]).to_s
    self.role_number = ic.iconv(data["N_ROL"]).to_s

    self.file_number = data["N_PE"].to_i.to_s
    self.file_date = data["F_PE"]

    self.owner = ic.iconv(data["PROP"]).to_s
    self.legal_agent = ic.iconv(data["REP_LEGAL"]).to_s
    self.architect = ic.iconv(data["ARQUITECTO"]).to_s

    self.floors = data["N_PISOS"].to_i unless data["N_PISOS"] == -1
    self.undergrounds = data["SUBT"].to_i unless data["SUBT"] == -1
    self.total_units = data["T_UNID"].to_i unless data["T_UNID"] == -1
    self.total_parking = data["T_EST"].to_i unless data["T_EST"] == -1
    self.total_commercials = data["T_LOC"].to_i unless data["T_LOC"] == -1
    self.m2_approved = data["M2_APROB"] unless data["M2_APROB"] == -1
    self.m2_built = data["M2_EDIF"]
    self.m2_field = data["M2_TERR"] unless data["M2_TERR"] == -1
    self.t_ofi = data["T_OFI"] unless data["T_OFI"] == -1

    self.cadastral_date = data["F_CATASTRO"].to_date unless data["F_CATASTRO"].nil?
    self.comments = ic.iconv(data["OBSERVACIO"]).to_s
    self.year = year
    self.bimester = bimester

    self.active = true

    self.cadastre = data["CATASTRO"]
    self.future_project_type_id = future_type.id
    self.project_type_id = p_type.id

    self.county_id = county.id unless county.nil?
    self.the_geom = geom

    if self.save
      County.update(county.id, :future_project_data => true, :number_last_project_future => number_next_project) unless county.nil?
      return true
    end
    false
  end

  def latitude
    @latitude ||= self.the_geom.y if self.the_geom
    return @latitude ? @latitude : ""
  end

  def longitude
    @longitude ||= self.the_geom.x if self.the_geom
    return @longitude ? @longitude : ""
  end

  def self.find_globals(filters)
    select = "COUNT(*) as count_project, (COUNT(*)/ CAST(COUNT(DISTINCT (year,bimester)) AS FLOAT) ) as avg_project_bim, "
    select += "SUM(future_projects.m2_built) as total_surface, ROUND(AVG(future_projects.m2_built), 2) as avg_surface, future_project_types.name"

    periods = Period.get_periods(filters[:to_period].to_i, filters[:to_year].to_i, BIMESTER_QUANTITY, 1)
    cond_query = build_period_condition(periods) + Util.and
      cond_query = conditions(filters, nil)

    joins = build_joins.join(" ")

    totals = FutureProject.select(select).
      joins(joins).
      where(cond_query).
      group("future_project_types.name").
      order("future_project_types.name")

    draft = FutureProject.joins(joins).
      where(cond_query + Util.and + "future_project_types.name = 'ANTEPROYECTO'").count

    perm = FutureProject.joins(joins).
      where(cond_query + Util.and + "future_project_types.name = 'PERMISO DE EDIFICACION'").count

    recept = FutureProject.joins(joins).
      where(cond_query + Util.and + "future_project_types.name = 'RECEPCION MUNICIPAL'").count

    draft.to_f == 0 ? perm_rate = 0 : perm_rate = (perm.to_f / draft.to_f).round(2)
    perm.to_f == 0 ? recept_rate = 0: recept_rate = (recept.to_f / perm.to_f).round(2)

    rates = {:permission_draft_rate => perm_rate, :reception_permission_rate => recept_rate}
    return rates, totals
  end

  def self.group_by_project_type(widget, filters)
    cond_query = conditions(filters, widget)
    FutureProject.joins(build_joins.join(" ")).where(cond_query).group(:future_project_type_id).count(:id)
  end

  def self.future_projects_by_period(agrup_function, widget, filters)
    select = ""
    case agrup_function
    when "COUNT"
      select = "COUNT(future_projects.id) as y_value"
    when "SUM"
      select = "SUM(future_projects.m2_built) as y_value"
    end

    future_projects_group_by_period(select, widget, filters)
  end

  def self.future_projects_group_by_period(y_value, widget, filters)
    bimesters = get_bimesters(filters)
    result = []

    select = "#{y_value}, future_project_types.name as y_label, future_project_types.color as y_color"
    cond = conditions(filters, widget)

    fut_types = FutureProject.select("DISTINCT future_project_types.name").
      joins(build_joins.join(" ")).
      where(cond).
      order('future_project_types.name').map { |typ| typ.name }

    bimesters.each do |bimester|
      cond_query = get_periods_query(bimester[:period], bimester[:year]) + Util.and + cond

      projects = FutureProject.select(select).
        joins(build_joins.join(" ")).
        where(cond_query).
        group('future_project_types.name, future_project_types.color').
        order('future_project_types.name')

      result << {:values => projects.to_a, :bimester => bimester[:period], :year => bimester[:year]} unless projects.nil?
    end
    return fut_types, result.reverse
  end

  def self.units_by_project_type(filters)
    result = []
    select = "COUNT(*) as value"
    cond = conditions(filters)

     ProjectType.all.each do |typ|
       data = []
       FutureProjectType.all.each do |fpt|
       future = FutureProject.
         joins(build_joins.join(" ")).
         where(cond + Util.and + "project_type_id = #{typ.id}"+ Util.and +  "future_project_type_id = #{fpt.id}").count
        data.push({name: fpt.name, count: future})
    end
      result << {:type => typ.name, values: data }
    end
    result
  end

  def self.projects_by_destination_project_type(filters, widget)
    projects = FutureProject.select("COUNT(*) as value, project_types.name as project_type_name, project_types.id as project_id").
      joins(build_joins.join(" ")).
      where(conditions(filters, widget)).
      group("project_types.name, project_types.id").
      order("project_types.name")
    projects
  end

  def self.future_project_rates(widget, filters)
    bimesters = get_bimesters(filters)
    result = []

    select = "COUNT(future_projects.id) as y_value, future_project_types.name as y_label"
    cond = conditions(filters, widget)

    bimesters.each do |bimester|
      cond_query = get_periods_query(bimester[:period], bimester[:year]) + Util.and + cond

      projects = FutureProject.select(select).
        joins(build_joins.join(" ")).
        where(cond_query).
        group('future_project_types.name')

      perm_rate = 0
      recept_rate = 0

      ant = projects.select {|p| p["y_label"] == "ANTEPROYECTO" }.first
      perm = projects.select {|p| p["y_label"] == "PERMISO DE EDIFICACION" }.first
      recep = projects.select {|p| p["y_label"] == "RECEPCION MUNICIPAL" }.first

      perm_rate = (perm["y_value"].to_f / ant["y_value"].to_f).round(2) unless perm.nil? or ant.nil?
      recept_rate = (recep["y_value"].to_f / perm["y_value"].to_f).round(2) unless recep.nil? or perm.nil?

      result << {:perm_rate => perm_rate, :recept_rate => recept_rate, :bimester => bimester[:period], :year => bimester[:year]}
    end

    result.reverse
  end

  # def self.get_bench_values(ids)
  #   projects= FutureProject.all(:joins => :future_project_type,
  #                               :include => :future_project_type,
  #                               :conditions => "future_projects.id IN (#{ids.join(',')})")

  #   return projects
  # end

  private

  def build_geom
    self.the_geom = "POINT(#{self.longitude.to_f} #{self.latitude.to_f})" if self.latitude and self.longitude
  end

  def self.build_joins
    joins = []
    joins << "INNER JOIN future_project_types ON future_project_types.id = future_projects.future_project_type_id"
    joins << "INNER JOIN project_types ON project_types.id = future_projects.project_type_id"
    joins
  end

  def point_is_located_within_the_specified_county
    return if self.latitude.blank?
    point_county = County.find_by_lon_lat(self.longitude, self.latitude)
    errors.add(
      :county_id,
      :not_within_county,
      :point_county => point_county.name,
      :selected_county => self.county.name) unless point_county.id == self.county_id
  end

  # def self.values_by_period(widget, select, filters, bimesters)
  #   result = []
  #   cond = conditions(filters, widget)

  #   bimesters.each do |bimester|
  #     cond_query = get_periods_query(bimester[:period], bimester[:year]) + Util.and
  #       cond_query += cond

  #     project = FutureProject.find(:first,
  #                                  :select => select,
  #                                  :joins => build_joins.join(" "),
  #                                  :conditions => cond_query,
  #                                  :group => 'future_projects.year, future_projects.bimester',
  #                                  :order => 'future_projects.year, future_projects.bimester')

  #     if project.nil?
  #       result << {:value => "null", :bimester => bimester[:period], :year => bimester[:year]}
  #     else
  #       result << {:value => project[:value], :bimester => bimester[:period], :year => bimester[:year]}
  #     end
  #   end

  #   result.reverse
  # end

  def self.conditions(filters, self_not_filter=nil)

    if !filters[:county_id].nil?
      conditions = "county_id = #{filters[:county_id]}" + Util.and
    elsif !filters[:wkt].nil?
      conditions = WhereBuilder.build_within_condition(filters[:wkt]) + Util.and
    else
      conditions = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] ) + Util.and
      end

    conditions += "active = true #{Util.and}"

    unless filters.has_key? :boost
      conditions += WhereBuilder.build_range_periods_by_bimester(filters[:to_period], filters[:to_year], BIMESTER_QUANTITY) if filters.has_key? :to_period
      conditions += bimester_condition(filters, self_not_filter)
    end
    conditions += ids_conditions(filters, self_not_filter)

    #conditions += "future_projects.county_id IN(#{User.current.county_ids.join(",")})#{Util.and}" if User.current.county_ids.length > 0
    conditions.chomp!(Util.and)
    conditions
  end

  def self.bimester_condition(filters, self_not_filter)
    conditions = ""

    if filters.has_key? :periods and (self_not_filter == 'project_types' or self_not_filter.nil?)
      conditions += WhereBuilder.build_bimesters_condition(filters[:periods], filters[:years])
    end

    conditions
  end

  def self.build_period_condition(bimesters)
    conditions = "("

    bimesters.each do |bimester|
      conditions += get_periods_query(bimester[:period], bimester[:year]) + Util.or
    end

    conditions.chomp!(Util.or)
    conditions + ")"
  end

  def self.get_periods_query(period, year)
    conditions = "("
    conditions += WhereBuilder.build_equal_condition('future_projects.bimester', period)
    conditions += Util.and
      conditions += WhereBuilder.build_equal_condition('future_projects.year', year)
    conditions += ")"
    conditions
  end

  def self.ids_conditions(filters, self_not_filter)
    conditions = ""

    #PROJECT TYPES
    if filters.has_key? :project_type_ids and self_not_filter != 'project_types'
      conditions += WhereBuilder.build_in_condition("project_type_id", filters[:project_type_ids]) + Util.and
    end

    #FUTURE PROJECT TYPES
    if filters.has_key? :future_project_type_ids and self_not_filter != 'future_project_types'
      conditions += WhereBuilder.build_in_condition("future_project_type_id", filters[:future_project_type_ids]) + Util.and
    end

    conditions
  end

  def self.get_last_period
    period = FutureProject.select("future_projects.year, future_projects.bimester").
                           joins(build_joins.join(" ")).
                           where("active = true").
                           group("bimester, year").
                           order("year desc, bimester desc").first

    return nil if period.nil?
    Period.get_periods(period.bimester, period.year, BIMESTER_QUANTITY, 1)
  end

  def self.get_first_bimester_with_future_projects
    period = FutureProject.select("future_projects.year, future_projects.bimester").
                           joins(build_joins.join(" ")).
                           where("active = true").
                           group("year, bimester").
                           order("year, bimester").first

    return nil if period.nil?
    return {:period => period.bimester, :year => period.year}
  end

  def self.is_periods_distance_allowed?(from_period, to_period, distance)
    f_period = from_period[:period]
    f_year = from_period[:year]
    t_period = to_period[:period]
    t_year = to_period[:year]

    if Period.get_distance_between_periods(f_period, f_year, t_period, t_year, 1) < distance
      return false
    end

    return true
  end

  def self.get_bimesters filters, bimesters_quantity = BIMESTER_QUANTITY
    bimesters = []

    if filters[:to_period].nil?
      first = FutureProject.select("bimester, year").
                            where("active = true"). 
                            group("year, bimester").
                            order("year, bimester").first

      last = FutureProject.select("bimester, year").
                           where("active = true").
                           group("year, bimester").
                           order("year desc, bimester desc").first

      bimesters = Period.get_between_periods(first.bimester.to_i, first.year.to_i, last.bimester.to_i, last.year.to_i, 1)
    else
      bimesters = Period.get_periods(filters[:to_period].to_i, filters[:to_year].to_i, bimesters_quantity, 1)
    end

    bimesters
  end

  ########New Functions##################
  def self.interval_graduated_points(params)


    period_current = Period.get_period_current
    bimester = period_current.bimester
    year = period_current.year
    county_id = params['county_id']
    values = FutureProject.select("COUNT(*) as counter, ROUND(m2_built / 100) as value").
      where(bimester: bimester, year: year, county_id: county_id).where("m2_built > ?", 1).
      group("ROUND(m2_built / 100)").
      order("counter desc").first
    result = Array.new
    unless values.nil?
      seed = (values["value"].to_i * 100)
      1.upto(Util::INTERVALS_QUANTITY) do
        result << seed
        seed += (values["value"].to_i * 100)
      end
    end
    return result
  end

  def self.reports(filters)
  @bb = filters
    cond_query = conditions(filters, nil)
    @future_projects = FutureProject.where(cond_query)
    @future_projects
  end


  def self.summary f

    filters  = JSON.parse(f.to_json, {:symbolize_names=> true})
    begin
      general_data = FutureProject.general_info(filters)
      types = FutureProject.future_project_type(filters)
      desttypes =FutureProject.destination_project_type(filters)
      dtypes = FutureProject.destination_type(filters)
      ubimester = FutureProject.unit_bimester(filters)
      m2bimester = FutureProject.m2_built_bimester(filters)
      rates = FutureProject.future_project_rates_1(filters)
      #GENERAL

      data =[]
      result=[]
      general_data.each do |item|
        data.push("name": item[:label], "count":item[:value].to_i)
      end
      result.push({"title":"Información General", "data": data})

      #TIPO DE EXPEDIENTE
      data =[]
      types.each_pair do |key, value|
        type_future_projects = FutureProjectType.find(key)
        data.push("name": type_future_projects.name.capitalize, "count":value.to_i, "id":type_future_projects.id)
      end
      result.push({"title":"Tipo de Expendiente", "series":[{"data": data}]})

      #TIPO DE DESTINO PIE
      data =[]
      desttypes.each do |item|
        data.push("name": item["project_type_name"], "count": item["value"].to_i, "id":item["project_id"])
      end
      result.push({"title":"Tipo de Destino",  "series": [{"data": data}]})
      ##TIPO DE DESTINO BAR
      categories = []
      series = []
      count = 0
      dtypes.each do |item|
        label = item[:type]
        data =[]

        item[:values].each do |itm|
          data.push("name": itm[:name].capitalize, "count": itm[:count].to_i)
        end
        categories.push({"label": label, "data": data} )
        count = count + 1
      end
      result.push({"title": "Tipo de Destino", "series":categories})

      #UNIDADES NUEVAS POR BIMESTRE
      categories = []
      a = []
      p = []
      r = []
      ubimester.last.each do |item|
        @item = item
        item[:values].each do |itm|

          if itm["y_label"] == 'ANTEPROYECTO'
            a.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )

          end
          if itm["y_label"] == 'PERMISO DE EDIFICACION'
            p.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )

          end

          if itm["y_label"] == 'RECEPCION MUNICIPAL'
            r.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )

          end
        end
      end
      categories.push({"label": "Anteproyecto", "data": a})
      categories.push({"label": "Permiso Edif.", "data": p})
      categories.push({"label": "Recep. Munic.", "data": r})
      result.push({"title": "Cantidad de Nuevas Unidades / Bimestre", "series": categories})

      #SUPERFICIE EDIFICADA POR EXPEDIENTE

      categories = []
      a = []
      p = []
      r = []
      m2bimester.last.each do |item|

        item[:values].each do |itm|

          if itm["y_label"] == 'ANTEPROYECTO'
            a.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )
          end
          if itm["y_label"] == 'PERMISO DE EDIFICACION'
            p.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )
          end

          if itm["y_label"] == 'RECEPCION MUNICIPAL'
            r.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":itm["y_value"] )
          end
        end
      end
      categories.push({"label": "Anteproyecto", "data": a})
      categories.push({"label": "Permiso Edif.", "data": p})
      categories.push({"label": "Recep. Munic.", "data": r})
      result.push({"title": "Superficie Edificada Por Expediente", "series": categories })

      #TASAS
      categories=[]
      p = []
      r = []
      rates.each do |item|
        p.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":item[:perm_rate] )
        r.push("name": (item[:bimester].to_s + "/" + item[:year].to_s[2,3]), "count":item[:recept_rate] )
      end
      categories.push({"label": "Tasa Permiso / Anteproyecto", "data": p})
      categories.push({"label": "Tasa Recepciones / Permisos", "data": r})
      result.push({"title": "Tasas", "series":categories})

    rescue
      result[:data] = ["Sin datos"]
    end

  end

  def self.general_info params
@pp = params

rates, global_information = FutureProject.find_globals(params)
    @general = []
    return if global_information.nil?
    global_information.each do |typ|
      @general << {:label => I18n.t(:TOTAL_PERMISSIONS) + " " + typ["name"].titleize, :value => typ["count_project"]}
    end
    global_information.each do |typ|
      @general << {:label => I18n.t(:AVG_PERMISSIONS) + " " + typ["name"].titleize, :value => typ["avg_project_bim"]}
    end
    global_information.each do |typ|
      @general << {:label =>I18n.t(:M2_BUILT_PERMISSIONS) + " " + typ["name"].titleize, :value => typ["total_surface"]}
    end
    global_information.each do |typ|
      @general << {:label => I18n.t(:AVG_M2_BUILT_PERMISSIONS) + " " + typ["name"].titleize, :value => typ["avg_surface"]}
    end
    @general << {:label => I18n.t(:PERMISSION_DRAFT_RATE), :value => rates[:permission_draft_rate]}
    @general << {:label => I18n.t(:RECEPTION_PERMISSION_RATE), :value => rates[:reception_permission_rate]}

  end


  def self.future_project_type params
    @types = FutureProject.group_by_project_type('future_project_types', params)
  end

  def self.destination_type params
    @types = FutureProject.units_by_project_type(params)
  end

  def self.destination_project_type params
    @types = FutureProject.projects_by_destination_project_type(params, 'project_types')
  end

  def self.unit_bimester params
    @fut_types, @projects = FutureProject.future_projects_by_period("COUNT", "unit_bimester", params)
  end

  def self.m2_built_bimester params
    @fut_types, @projects = FutureProject.future_projects_by_period("SUM", "m2_built_bimester", params)
  end

  def self.future_project_rates_1 params
    @projects = FutureProject.future_project_rates("future_project_rates", params)
  end

  def self.benchmarking_list params
    @bench_projects = FutureProjectResult.get_benchmarking_project_list(params[:result_id], params[:project_id])
    @current_project = FutureProject.find(params[:project_id])
  end

  def self.benchmarking params
    @projects = FutureProject.get_bench_values(params[:project_ids])
  end


  def self.suggest params
    @suggests = FutureProjectResult.get_search_suggests(params)
  end

  def self.search params
    @updated = FutureProjectResult.search(params)
  end

  def self.around_pois params
    pois = Poi.get_around_pois(params[:id], "future_projects", params[:wkt])
    render :xml => pois.to_xml(:skip_instruct => true, :skip_types => true, :dasherize => false)
  end

  #Review

  # def digitizer_name
  #   return self.digitizer.complete_name unless self.digitizer.nil?
  #   I18n.translate :unknown
  # end

  # def self.get_points_count_by_filters(filters, column)
  #   FutureProject.count(:joins => build_joins.join(" "), :conditions => "#{conditions(filters)} AND #{column} >= 1")
  # end

  # def self.get_heat_map_points_count_by_filters(filters)
  #   FutureProject.count(:joins => build_joins.join(" "), :conditions => conditions(filters))
  # end

  # def self.get_query_for_results(filters, result_id)
  #   sub_query = "SELECT #{result_id} as result_id, future_projects.id as future_project_id, future_projects.the_geom, "
  #   sub_query += "future_projects.m2_built, #{MapUtil::HEATMAP_VALUE} as heatmap_value, "
  #   sub_query += "future_project_types.color as marker_color FROM future_projects " + build_joins.join(" ") + " "
  #   sub_query += "WHERE #{conditions(filters)}"
  #   sub_query
  # end
end
