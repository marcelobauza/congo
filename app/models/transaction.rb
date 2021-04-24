class Transaction < ApplicationRecord
  include CsvParser
  include Ranges
  include Util
  include WhereBuilder
  include Transactions::Exports
  include Transactions::Imports
  include Transactions::Periods
  include Transactions::Popup
  include Transactions::Scopes
  include Transactions::Validations
  include Transactions::Kml

  belongs_to :county
  belongs_to :property_type
  belongs_to :seller_type
  belongs_to :surveyor
  belongs_to :user

  attr_accessor :latitude, :longitude

  BIMESTER_QUANTITY = 6
  SUM_CRITERIA      = 0
  COUNT_CRITERIA    = 1
  AVG_CRITERIA      = 2
  AVG_CRITERIA_UFM2 = 3

  def  self.pois params
    @joins = " INNER JOIN property_types ON property_types.id = transactions.property_type_id "
    @joins += " INNER JOIN seller_types ON seller_types.id = transactions.seller_type_id "

    select = "transactions.*,"
    wkt = ApplicationStatus.find(:first,
                                 :select => :wkt,
                                 :conditions => "id = #{params[:polygon_id]}" )

    conditions =  "ST_Contains(ST_Transform(ST_GeomFromText('#{wkt.wkt}',4326),4326), transactions.the_geom) "
    conditions +=" and calculated_value between #{params[:from_uf]} and #{params[:to_uf]} " if !params[:from_uf].empty? && !params[:to_uf].empty?
    conditions +=" and property_type_id = #{params[:property_type_id]} "  if !params[:property_type_id].empty?
    conditions +=" and uf_m2_t between #{params[from_uf_m2_t]} and #{params[from_uf_m2_t]} " if !params[:from_uf_m2_t].empty? && !params[:from_uf_m2_t].empty?
    conditions +=" and uf_m2_u between  #{params[:from_uf_m2_u]} and #{params[:to_uf_m2_u]} " if !params[:from_uf_m2_u].empty? && !params[:to_uf_m2_u].empty?
    conditions +=" and inscription_date between '#{params[:from_inscription_date]}' and  '#{params[:to_inscription_date]}' " if !params[:from_inscription_date].empty? &&  !params[:to_inscription_date].empty?

    transaction = Transaction.find(:all,
                                   :joins => @joins,
                                   :select => select,
                                   :conditions => conditions
                                  )
    return transaction
  end

  def latitude
    @latitude ||= self.the_geom.y if self.the_geom
    return @latitude ? @latitude : ""
  end

  def longitude
    @longitude ||= self.the_geom.x if self.the_geom
    return @longitude ? @longitude : ""
  end

  def digitizer_name
    return self.user.complete_name unless self.user.nil?
    I18n.translate :unknown
  end

  def titleize_attributes
    self.buyer_name       = self.buyer_name.titleize
    self.seller_name      = self.seller_name.titleize
    self.address          = self.address.titleize
    self.village          = self.village.to_s.titleize
    self.requiring_entity = self.requiring_entity.to_s.titleize
    self.comments         = self.comments.to_s.titleize
    self.block            = self.block.to_s.upcase
    self.department       = self.department.to_s.upcase
    self.blueprint        = self.blueprint.to_s.upcase
  end

  def self.is_periods_distance_allowed? from_period, to_period, distance
    f_period = from_period[:period].to_i
    f_year   = from_period[:year].to_i
    t_period = to_period[:period].to_i
    t_year   = to_period[:year].to_i

    if Period.get_distance_between_periods(f_period, f_year, t_period, t_year, 2) < distance
      return false
    end

    return true
  end

  def self.get_points_count_by_filters(filters, column)
    Transaction.count(:joins => build_joins.join(" "), :conditions => "#{build_conditions(filters)} AND #{column} >= 1")
  end

  def self.get_heat_map_points_count_by_filters(filters)
    Transaction.count(:joins => build_joins.join(" "), :conditions => build_conditions(filters))
  end

  def self.get_query_for_results(filters, result_id, map_columns)
    sub_query = "SELECT #{result_id} as result_id, transactions.id as transaction_id, transactions.the_geom, "
    sub_query += "#{map_columns.join(',')}, #{MapUtil::HEATMAP_VALUE} as heatmap_value, "
    sub_query += "'#{Util::NORMAL_MARKER_COLOR}' as marker_color "
    sub_query += "FROM transactions " + build_joins.join(" ") + " "
    sub_query += "WHERE #{build_conditions(filters)}"
    sub_query
  end

  def self.find_globals(filters)
    result = {
      uf_min_value: 0.0,
      uf_max_value: 0.0,
      average: 0.0,
      deviation: 0.0,
      avg_trans_count: 0,
      avg_uf_volume: 0.0
    }

    select = <<-SQL
        min(transactions.calculated_value) as uf_min_value,
        max(transactions.calculated_value) as uf_max_value,
        avg(transactions.calculated_value) as average,
        stddev(transactions.calculated_value) as deviation,
        ROUND((ROUND(SUM(1 / sample_factor)) / COUNT(DISTINCT(year, bimester)))) as avg_trans_count,
        (SUM(calculated_value) / COUNT(DISTINCT(year, bimester))) as avg_uf_volume
    SQL

    global_transactions = Transaction.
      select(select).
      joins(build_joins.join(" ") ).
      where(build_conditions(filters)).
      order("uf_min_value").first

    return result if global_transactions.nil?

    result[:uf_min_value] = global_transactions[:uf_min_value] unless global_transactions[:uf_min_value].nil?
    result[:uf_max_value] = global_transactions[:uf_max_value] unless global_transactions[:uf_max_value].nil?
    result[:average] = global_transactions[:average] unless global_transactions[:average].nil?
    result[:deviation] = global_transactions[:deviation] unless global_transactions[:deviation].nil?
    result[:avg_trans_count] = global_transactions[:avg_trans_count] unless global_transactions[:avg_trans_count].nil?
    result[:avg_uf_volume] = global_transactions[:avg_uf_volume] unless global_transactions[:avg_uf_volume].nil?

    result
  end

  def self.group_transaction_criteria_by_period(filters, criteria)
    return group_by_uf(filters, criteria, get_bimesters(filters))
  end

  def self.group_transaction_bimester(filters)
    result = []
    periods = get_bimesters(filters)
    select = "bimester||'/'||year as periods,  ROUND(SUM(1 / sample_factor)) as value"

    periods.each do |per|
      trans_group = {:period => per[:period], :year => per[:year], :counties => []}

      if !filters[:county_id].nil?
        conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id]) + Util.and
      elsif !filters[:wkt].nil?
        polygon = JSON.parse(filters[:wkt])
        conditions = "ST_CONTAINS(ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"polygon\", \"coordinates\":#{polygon[0]}}'),4326), transactions.the_geom) #{Util.and}"
        else
          conditions = "ST_DWithin(transactions.the_geom, ST_GeomFromText('POINT(#{filters[:centerpt]})', #{Util::WGS84_SRID}), #{filters[:radius]}, false) and "
        end

      conditions += "active = true #{Util.and}"
      conditions += "(bimester = #{per[:period]} and year = #{per[:year]})#{Util.and}"
      conditions += build_ids_conditions(filters)
      conditions += build_calculated_value_condition(filters)
      conditions += "transactions.county_id IN(#{CountiesUser.where(user_id: filters[:user_id]).pluck(:county_id).join(",")})#{Util.and}" if CountiesUser.where(user_id: filters[:user_id]).count > 0
      conditions = conditions.chomp!(Util.and)

      joins = build_joins
      joins << "INNER JOIN counties ON counties.id = transactions.county_id"

      @trans = Transaction.where(conditions).select(select).
        joins(joins.join(" ")).
        group(' year, bimester').
        order('year, bimester')
      result << @trans
    end
    result
  end



  def self.group_transaction_county_and_bimester(filters)
    result = []
    counties = []

    periods = get_bimesters(filters)
    select = "counties.name as county, ROUND(SUM(1 / sample_factor)) as value"

    periods.each do |per|
      trans_group = {:period => per[:period], :year => per[:year], :counties => []}

      if !filters[:county_id].nil?
        conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id]) + Util.and
      elsif !filters[:wkt].nil?
        polygon = JSON.parse(filters[:wkt])
        conditions = "ST_CONTAINS(ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"polygon\", \"coordinates\":#{polygon[0]}}'),4326), transactions.the_geom) #{Util.and}"
        else
          conditions = "ST_DWithin(transactions.the_geom, ST_GeomFromText('POINT(#{filters[:centerpt]})', #{Util::WGS84_SRID}), #{filters[:radius]}, false) and "
        end

      conditions += "active = true #{Util.and}"
      conditions += "(bimester = #{per[:period]} and year = #{per[:year]})#{Util.and}"
      conditions += build_ids_conditions(filters)
      conditions += build_calculated_value_condition(filters)
      conditions += "transactions.county_id IN (#{CountiesUser.where(user_id: filters[:user_id]).pluck(:county_id).join(",")}) #{Util.and}" if CountiesUser.where(user_id: filters[:user_id]).count > 0
      conditions = conditions.chomp!(Util.and)

      joins = build_joins
      joins << "INNER JOIN counties ON counties.id = transactions.county_id"

      trans = Transaction.where(conditions).select(select).
        joins(joins.join(" ")).
        group('counties.name, year, bimester').
        order('year, bimester')
      unless trans.nil?
        trans_group[:counties] = trans
        trans.each {|t| counties << t["county"]}
      end
      result << trans_group
    end

    counties.uniq!
    values = []
    result.each do |q|
      item = {:period => q[:period], :year => q[:year], :label => q[:period].to_s + "/" + q[:year].to_s[2,3]}
      values_sum = 0
      values_sum_total = 0

      counties.each do |county|

        index = counties.index(county) + 1
        item["y#{index}_label".to_sym] = county
        item["y#{index}_value".to_sym] = "null"
        item["y0_label".to_sym] = I18n.t(:ALL_COUNTIES_LABEL)

        q[:counties].each { |c| item["y#{index}_value".to_sym] = c.value if c["county"] == county }
        values_sum += item["y#{index}_value".to_sym].to_i
        item["y0_value".to_sym] = values_sum
      end

      values << item
    end
    return values.reverse
  end

  def self.group_transactions_by_uf(filters)
    values = get_calculated_value_ranges(filters)
    result = []

    return result if values.nil?

    ranges = get_valid_ranges(values)
    ranges.each do |qua|
      trans_group = {:from => qua["min"], :to => qua["max"], :value => "0"}
      params = filters.dup
      params[:from_calculated_value] = [qua["min"]]
      params[:to_calculated_value] = [qua["max"]]

      t = Transaction.select("ROUND(SUM(1/ sample_factor)) as value").
        joins(build_joins.join(" ")).
        where(build_conditions(params)).
        order("value").first

      trans_group[:value] = t.value unless t.nil?
      result << trans_group
    end

    return result
  end

  def self.get_calculated_value_ranges(filters)
    select = "min(calculated_value) as min, max(calculated_value) as max, "
    select += "stddev(calculated_value) as dev, avg(calculated_value) as avg, "
    select += "count(*) as count"

    t = Transaction.select(select).
      joins(build_joins.join(" ")).
      where(build_conditions(filters, 'calculated_value')).
      order("max").first

    original_min = 0.0
    original_max = 1.0
    inf_limit = 0.0
    sup_limit = 0.0

    return if t.min.nil? or t.max.nil? or t.avg.nil?
    return [{:from => t.min, :to => t.max}] if t.min == t.max

    original_min = Float(t.min)
    original_max += Float(t.max)

    inf_limit = Float(t.avg) - Float(t.dev)
    inf_limit = 0.0 if inf_limit < 0.0
    sup_limit = Float(t.avg) + Float(t.dev)
    increment = (Float(sup_limit) - Float(inf_limit)) / 9.0 #5.0
    from      = inf_limit
    to        = from + increment

    ranges = []
    ranges << {:from => original_min, :to => to}

    1.upto(8) do
      from += increment
      to = from + increment
      ranges << {:from => from, :to => to}
    end

    ranges.last[:to] = original_max;

    return ranges
  end

  def self.get_valid_ranges(values)
    ranges    = Ranges.get_ranges
    min_value = values[0][:from].to_i
    max_value = values[values.count - 1][:to].to_i
    index_min = -1
    index_max = -1

    ranges.each_with_index do |r, index|
      index_min = index if min_value >= r["min"].to_i && min_value <= r["max"].to_i
      index_max = index if max_value <= r["max"].to_i && max_value >= r["min"].to_i
      index_max = index if max_value > r["max"].to_i
    end

    ranges[index_min..index_max]
  end

  def self.group_by_uf(filters, criteria, periods)
    result = []
    select = ''

    if(criteria == COUNT_CRITERIA)
      select = "bimester, year, ROUND(SUM(1 / sample_factor)) as value"
    elsif(criteria == SUM_CRITERIA)
      select = "bimester, year, sum(transactions.calculated_value) as value"
    elsif(criteria == AVG_CRITERIA)
      select = "bimester, year, avg(transactions.calculated_value) as value"
    elsif(criteria == AVG_CRITERIA_UFM2)
      select = "bimester, year, avg(transactions.uf_m2_u) as value"
    end

    periods.each do |per|
      trans_group = {:period => per[:period], :year => per[:year], :value => "null"}
      conditions  = "active = true #{Util.and}"

      if !filters[:wkt].nil?
        conditions += WhereBuilder.build_within_condition(filters[:wkt]) + Util.and
      elsif !filters[:centerpt].nil?
        conditions += WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] ) + Util.and
        else
          conditions += WhereBuilder.build_in_condition("county_id",filters[:county_id]) + Util.and
        end

      conditions += "(bimester = #{per[:period]} and year = #{per[:year]})#{Util.and}"
      conditions += build_ids_conditions(filters)
      conditions += build_calculated_value_condition(filters)
      conditions += "transactions.county_id IN(#{CountiesUser.where(user_id: filters[:user_id]).pluck(:county_id).join(",")})#{Util.and}" if CountiesUser.where(user_id: filters[:user_id]).count > 0
      conditions = conditions.chomp!(Util.and)

      t = Transaction.select(select).
        joins(build_joins.join(" ")).
        where(conditions).
        group('bimester, year').
        order('year, bimester').first
      trans_group[:value] = t.value.to_f.round(2) unless t.nil?
      result << trans_group
    end
    return result.reverse
  end

  def self.get_uf_m2_range_values(filters)
    conditions = build_conditions(filters)

    limits = Transaction.find(:all,
                              :select => "ROUND(AVG(uf_m2)) as avg, ROUND(STDDEV(uf_m2)) as stdev",
                              :joins => build_joins.join(" "),
                              :conditions => "#{conditions} AND uf_m2 IS NOT NULL")

    ranges = Period.build_ranges_by_average(limits[0]["avg"].to_f, limits[0]["stdev"].to_f)

    max = 0

    ranges.each do |r|
      value = Transaction.find(:all, :select => "COUNT(transactions.id) as value",
                               :joins => build_joins.join(" "),
                               :conditions => "#{conditions} AND uf_m2 IS NOT NULL AND (uf_m2 > #{r[:from]} AND uf_m2 <= #{r[:to]})" )

      r[:value] = value[0]["value"].to_i

      if r[:value] > max
        max = r[:value]
      end
    end

    return ranges, limits[0]["avg"], max
  end

  def self.build_conditions(filters, widget=nil)

    if !filters[:county_id].nil?
      conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id]) + Util.and
    elsif !filters[:wkt].nil?
      conditions = WhereBuilder.build_within_condition(filters[:wkt]) + Util.and
      else
        conditions = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] ) + Util.and
      end
    conditions += "active = true #{Util.and}"

    unless filters.has_key? :boost
      conditions += WhereBuilder.build_range_periods_by_bimester(filters[:to_period], filters[:to_year], BIMESTER_QUANTITY) if filters.has_key? :to_period
      conditions += WhereBuilder.build_bimesters_condition(filters[:periods], filters[:years]) if filters.has_key? :periods
    end

    conditions += build_ids_conditions(filters, widget)
    conditions += "transactions.county_id IN(#{CountiesUser.where(user_id: filters[:user_id]).pluck(:county_id).join(",")})#{Util.and}" if CountiesUser.where(user_id: filters[:user_id]).count > 0
    conditions += build_calculated_value_condition(filters, widget)
    conditions.chomp!(Util.and)
    conditions
  end

  def property_type_name
    self.property_type.name rescue ""
  end

  def seller_type_name
    self.seller_type.name rescue ""
  end

  def county_name
    self.county.try(:name)
  end

  def self.fill_grid(params, user)
    if User.current.is_admin?
      return Transaction.by_number(params[:number]).by_property_type(params[:property_type_id]).by_role(params[:role]).
        by_inscription_date(params[:inscription_date])
    else
      return Transaction.by_user(user).by_number(params[:number]).by_property_type(params[:property_type_id]).
        by_role(params[:role]).by_inscription_date(params[:inscription_date])
    end
  end

  def self.get_bench_values(result_id, seller_type_ids=nil)
    conditions = "result_id = #{result_id}"
    conditions += " AND seller_type_id IN(#{seller_type_ids.join(",")})" unless seller_type_ids.nil?

    Transaction.find(:all,
                     :joins => :transaction_results,
                     :conditions => conditions,
                     :include => [:property_type, :seller_type],
                     :order => "inscription_date")
  end

  def self.get_bench_avg_values(result_id, tran_ids, seller_type_ids=nil)
    conditions = "result_id = #{result_id}"
    conditions += " AND seller_type_id IN(#{seller_type_ids.join(",")})" unless seller_type_ids.nil?

    not_in_condition = ""
    not_in_condition = " AND transactions.id NOT IN(#{tran_ids.join(",")})" unless tran_ids.nil?

    avg = {:avg => 0, :avg_selected => 0}
    avg[:avg] = Transaction.find(:all,
                                 :select => "ROUND(AVG(transactions.calculated_value)) as avg",
                                 :joins => :transaction_results,
                                 :conditions => conditions + not_in_condition)[0]["avg"]

    unless tran_ids.nil?
      in_condition = " AND transactions.id IN(#{tran_ids.join(",")})"
      avg[:avg_selected] = Transaction.find(:all,
                                            :select => "ROUND(AVG(transactions.calculated_value)) as avg",
                                            :joins => :transaction_results,
                                            :conditions => conditions + in_condition)[0]["avg"]
    end

    return avg
  end

  def self.get_benchlist(result_id)
    Transaction.find(:all,
                     :joins => :transaction_results,
                     :conditions => "result_id=#{result_id}",
                     :include => [:property_type, :seller_type],
                     :order => :address)
  end

  def self.get_bench_trans_by_rut_ranges(result_id, seller_type_ids=nil)
    conditions = "result_id = #{result_id}"
    conditions += " AND seller_type_id IN(#{seller_type_ids.join(",")})" unless seller_type_ids.nil?

    select = "rut_ranges.id, rut_ranges.name, from_value, to_value, last_range, "
    select += "(SELECT count(*) FROM transaction_results INNER JOIN transactions ON transactions.id = transaction_results.transaction_id "
    select += "WHERE #{conditions}) as total,"
    select += "COUNT(transactions.id) as count, MIN(transactions.calculated_value) as min, MAX(transactions.calculated_value) as max, "
    select += "AVG(transactions.calculated_value) as average, STDDEV(transactions.calculated_value) as deviation"

    joins = "INNER JOIN rut_ranges ON cast(substr(transactions.buyer_rut, 0, position('-' in transactions.buyer_rut)) as int) BETWEEN from_value AND to_value "
    joins += "INNER JOIN transaction_results ON transaction_results.transaction_id = transactions.id"

    tran_by_rut = Transaction.find(:all,
                                   :select => select,
                                   :joins => joins,
                                   :conditions => conditions,
                                   :group => "rut_ranges.id, rut_ranges.name, from_value, to_value, last_range",
                                   :order => "rut_ranges.id")
  end

  private

  def self.build_joins
    joins = []
    joins << "INNER JOIN property_types ON property_types.id = transactions.property_type_id"
    joins << "INNER JOIN seller_types ON seller_types.id = transactions.seller_type_id"
    joins
  end

  def update_calculated_value
    value = CountyUf.find_by_county_id_and_property_type_id(self.county_id, self.property_type_id)

    if value.nil?
      errors.add(:calculated_value, :uf_county_not_exists)
      return false
    end

    unless (self.calculated_value >= value.uf_min and self.calculated_value <= value.uf_max)
      errors.add(:calculated_value, :not_valid_uf_value)
      return false
    end
  end

  def self.build_ids_conditions(filters, self_not_filter=nil)
    conditions = ""

    if filters.has_key? :property_type_ids and self_not_filter != 'property_type'
      conditions += WhereBuilder.build_in_condition("property_type_id", filters[:property_type_ids]) + Util.and
    end

    if filters.has_key? :seller_type_ids and self_not_filter != 'seller_type'
      conditions += WhereBuilder.build_in_condition("seller_type_id", filters[:seller_type_ids]) + Util.and
    end

    conditions
  end

  def self.build_calculated_value_condition(filters, self_not_filter=nil)
    condition = ""

    if filters.has_key? :from_calculated_value and filters.has_key? :to_calculated_value
      condition = "("

      0.upto(filters[:from_calculated_value].count - 1) do |i|
        if filters[:from_calculated_value][i] == filters[:to_calculated_value][i]
          condition += WhereBuilder.build_equal_condition('calculated_value',filters[:from_calculated_value][i]) + Util.and
        else
          condition += WhereBuilder.build_between_condition('calculated_value',filters[:from_calculated_value][i],filters[:to_calculated_value][i]) + Util.and
          end
      end

      condition = condition.chomp(Util.and) + ")#{Util.and}"
    end
    condition
  end

  def self.get_bimesters filters
    bimesters = []

    if filters[:to_period].nil?
      first = Transaction.select("bimester, year").
        where("active = true").
        group("year, bimester").
        order("year, bimester").first

      last = Transaction.select("bimester, year").
        where("active = true").
        group("year, bimester").
        order("year desc, bimester desc").first

      bimesters = Period.get_between_periods(first.bimester, first.year, last.bimester, last.year, 1)
    else
      bimesters = Period.get_periods(filters[:to_period].to_i, filters[:to_year].to_i, BIMESTER_QUANTITY, 1)
    end
    bimesters
  end

  def self.build_county_condition user_id, counties
    condition = "(counties_users.user_id = #{user_id} AND counties_users.county_id IN(#{counties.join(",")}))#{Util.and}"
  end

  def self.get_valid_ranges_interval(values)

    ranges = Project::get_ranges
    min_value = values["value"].to_i * 10

    index_min = ranges.count - 1
    index_max = ranges.count - 1
    @imn = index_min
    @imx = index_max
    @vv = values
    ranges.each_with_index do |r, index|
      index_min = index if min_value >= r["min"].to_i && min_value <= r["max"].to_i
    end

    ranges[index_min..index_max]
  end

  def self.group_avg_by_chart_pdf(filters, option)
    result = []
    counties = ["sum_counties"]

    periods = get_bimesters(filters)
    select = "transactions.bimester::text || '/' || transactions.year::text as name ,  "

    case option
    when 'avg_surface_line_build'
      select += "round(avg(total_surface_building),1) as value "
    when 'avg_uf_m2_u'
      select += " round(avg(transactions.calculated_value) / avg(total_surface_building),1) as value "
    when 'avg_land'
      select +=" round(avg(total_surface_terrain),1) as value"
    when 'avg_uf_m2_land'
      select +=" round(avg(transactions.calculated_value) / avg(total_surface_terrain),1) as value"
    end

    if !filters[:county_id].nil?
      conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id]) + Util.and
    elsif !filters[:wkt].nil?
      conditions = "ST_Within(transactions.the_geom, ST_GeomFromText('#{filters[:wkt]}', #{Util::WGS84_SRID}))#{Util.and}"
      else
        conditions = "ST_DWithin(transactions.the_geom, ST_GeomFromText('POINT(#{filters[:centerpt]})', #{Util::WGS84_SRID}), #{filters[:radius]}) and "
      end

    conditions += "active = true #{Util.and}"
    conditions += " total_surface_terrain <> 0 and "
    conditions += " total_surface_building <> 0 and "
    conditions += build_ids_conditions(filters)
    periods.each do |per|
      conditions += "(bimester = #{per[:period]} and year = #{per[:year]})#{Util.or}"
    end
    conditions = conditions.chomp(Util.or)
    conditions += "transactions.county_id IN(#{CountiesUser.where(user_id: filters[:user_id]).pluck(:county_id).join(",")})#{Util.and}" if CountiesUser.where(user_id: filters[:user_id]).count > 0

    trans = Transaction.
      where(conditions).
      group('year, bimester').
      order('year, bimester').
      pluck(select)
  end

  def self.summary params
    result =[]
    begin
      global_transactions = find_globals(params)
      general_data = [
        {:label => I18n.t(:UF_MIN_VALUE), :value => global_transactions[:uf_min_value]},
        {:label => I18n.t(:UF_MAX_VALUE), :value => global_transactions[:uf_max_value]},
        {:label => I18n.t(:UF_AVERAGE), :value => global_transactions[:average]},
        {:label => I18n.t(:UF_DEVIATION), :value => global_transactions[:deviation]},
        {:label => I18n.t(:AVG_TRANSACTIONS_BIMESTER), :value => global_transactions[:avg_trans_count]},
        {:label => I18n.t(:AVG_UF_VOLUME_BIMESTER), :value => global_transactions[:avg_uf_volume]}]


      ptypes = PropertyType.group_transactions_by_prop_types(params)
      stypes = SellerType.group_transactions_by_seller_type(params)
      transactions_by_periods = Transaction.group_transaction_county_and_bimester(params)
      uf_periods = Transaction.group_transaction_criteria_by_period(params, Transaction::SUM_CRITERIA)
      average_uf_periods = Transaction.group_transaction_criteria_by_period(params, Transaction::AVG_CRITERIA)
      average_uf_m2_util_periods = Transaction.group_transaction_criteria_by_period(params, Transaction::AVG_CRITERIA_UFM2)
      transactions_ufs = Transaction.group_transactions_by_uf(params)

      #GENERAL
      data =[]
      result=[]
      general_data.each do |item|
        data.push("name": item[:label], "count":("%.1f" % item[:value]).to_f)
      end
      result.push({"title":"Información General", "data": data})

      #USO
      data =[]

      ptypes.each do |prop|
        data.push("name": prop.name.capitalize, "count": prop.value.to_i, "id":prop.id)
      end
      result.push({"title":"Uso", "series":[{"data": data}]})

      #Vendedor

      data =[]
      stypes.each do |seller|
        data.push({"name": seller.name.capitalize, "count":seller.value.to_i, "id":seller.id})
      end

      result.push({"title":"Vendedor", "series":[{"data": data}]})

      #TRANSACCIONES POR BIMESTRE
      data =[]
      counties_count = (transactions_by_periods.first.size - 3) / 2

      0.upto(counties_count - 1).each do |idx|
        data.push([transactions_by_periods.first["y#{idx}_label".to_sym]])
      end
      transactions_by_periods.each_with_index do |tb, i|

        0.upto(counties_count -1 ).each do |idx|
          if tb["y#{idx}_value".to_sym].nil?
            data.push(tb["y#{idx}_value".to_sym], nil, tb[:period], tb[:year])
          else
            data[idx].push([tb["y#{idx}_value".to_sym], tb[:period], tb[:year]])
          end
        end
      end

      result.push({"title":"Compraventas", "series":[{"data": data}]})
      #UF PERIOD
      data =[]
      uf_periods.each do |ufp|
        data.push({"name": (ufp[:period].to_s + "/" + ufp[:year].to_s[2,3]), "count":   ufp[:value].to_i })
      end
      result.push({"title":"PxQ | UF", "series":[{"data": data}]})


      ##AVERAGE UF PERIOD

      data =[]
      average_uf_periods.each do |aup|
        data.push({"name": (aup[:period].to_s + "/" + aup[:year].to_s[2,3]), "count":   aup[:value].to_i })
      end

      result.push({"title":"Precio Promedio | UF", "series":[{"data": data}]})

      ##AVERAGE UF_M2 PERIOD
      data =[]
      average_uf_m2_util_periods.each do |aup|
        data.push({"name": (aup[:period].to_s + "/" + aup[:year].to_s[2,3]), "count":   aup[:value].to_i })
      end

      result.push({"title":"Precio Promedio | UFm² Útil", "series":[{"data": data}]})

      #TRANSACTION UF

      data =[]

      transactions_ufs.each do |aup|
        data.push({"name": NumberFormatter.format(aup[:from], false).to_s + " - " + NumberFormatter.format(aup[:to], false).to_s, "count": aup[:value].to_i})
      end

      result.push({"title":"Compraventas por Rango Precio", "series":[{"data": data}]})

    rescue
      #result = {data: ""}
    end
  end

  def self.reports(filters)
    @bb = filters
    cond_query = build_conditions(filters, nil)
    @transactions = Transaction.where(cond_query)
    @transactions
  end

  def self.reports_pdf filters

    result =[]
    info = Transaction.information_of_transactions filters
    result.push({"info": info})


    ptypes = PropertyType.group_transactions_by_prop_types(filters)
    stypes = SellerType.group_transactions_by_seller_type(filters)
    transactions_by_periods = Transaction.group_transaction_county_and_bimester(filters)
    uf_periods = Transaction.group_transaction_criteria_by_period(filters, Transaction::SUM_CRITERIA)
    average_uf_periods = Transaction.group_transaction_criteria_by_period(filters, Transaction::AVG_CRITERIA)
    avg_surface_line_build = group_avg_by_chart_pdf(filters, 'avg_surface_line_build')
    avg_uf_m2_u = group_avg_by_chart_pdf(filters, 'avg_uf_m2_u')
    avg_land = group_avg_by_chart_pdf(filters, 'avg_land')
    avg_uf_m2_land = group_avg_by_chart_pdf(filters, 'avg_uf_m2_land')

    #USO
    data =[]
    ptypes.each do |prop|
      data.push("name": prop.name.capitalize, "count": prop.value.to_i, "id":prop.id)
    end
    result.push({"title":"Uso", "series":[{"data": data}]})

    #Vendedor
    data =[]
    stypes.each do |seller|
      data.push({"name": seller.name.capitalize, "count":seller.value.to_i, "id":seller.id})
    end

    result.push({"title":"Vendedor", "series":[{"data": data}]})

    #TRANSACCIONES POR BIMESTRE
    data =[]
    counties_count = (transactions_by_periods.first.size - 3) / 2
    0.upto(counties_count).each do |idx|
      data.push([transactions_by_periods.first["y#{idx}_label".to_sym]])
    end

    transactions_by_periods.each_with_index do |tb, i|

      1.upto(counties_count ).each do |idx|
        if tb["y#{idx}_value".to_sym].nil?
          data.push(tb["y#{idx}_value".to_sym], nil, tb[:period], tb[:year])
        else
          data[idx].push([tb["y#{idx}_value".to_sym], tb[:period], tb[:year]])
        end
      end
    end

    result.push({"title":"Compraventas", "series":[{"data": data}]})

    #UF PERIOD
    data =[]
    uf_periods.each do |ufp|
      data.push({"name": (ufp[:period].to_s + "/" + ufp[:year].to_s[2,3]), "count":   ufp[:value].to_i })
    end
    result.push({"title":"PxQ | UF", "series":[{"data": data}]})

    ##AVERAGE UF PERIOD
    data =[]
    average_uf_periods.each do |aup|
      data.push({"name": (aup[:period].to_s + "/" + aup[:year].to_s[2,3]), "count":   aup[:value].to_i })
    end

    result.push({"title":"Precio Promedio | UF", "series":[{"data": data}]})

    #AVG SURFACE LINE BUILD
    data=[]
    avg_surface_line_build.each do |avg|
      data.push("name": avg[0], "count": avg[1].to_f )
    end

    result.push({"title":"Superficie Línea Construcción (útil m²) por Bimestre", "series":[{"data": data}]})

    #AVG UF M2 U
    data=[]
    avg_uf_m2_u.each do |avg|
      data.push("name": avg[0], "count": avg[1].to_f )
    end

    result.push({"title":"Precio UFm² en Base Útil por Bimestre", "series":[{"data": data}]})

    #AVG LAND
    data=[]
    avg_land.each do |avg|
      data.push("name": avg[0], "count": avg[1].to_f )
    end

    result.push({"title":"Superficie Terreno (m²) por Bimestre", "series":[{"data": data}]})

    #AVG UF M2 LAND
    data=[]
    avg_uf_m2_land.each do |avg|
      data.push("name": avg[0], "count": avg[1].to_f )
    end

    result.push({"title":"Precio UFm² en Base Terreno por Bimestre", "series":[{"data": data}]})

    result

  end

  def self.information_of_transactions filters

    cond_query = build_conditions(filters, nil)
    select = "COUNT(transactions.id) AS transactions_count, "
    select +=" round(MIN(transactions.calculated_value),1) AS uf_min_value,"
    select +=" round(MAX(transactions.calculated_value),1) AS uf_max_value,"
    select +=" round(AVG(transactions.calculated_value),1) AS average,"
    select +=" round(STDDEV(transactions.calculated_value),1) AS deviation,"
    select +=" round((avg(transactions.calculated_value) + STDDEV(transactions.calculated_value)) ,1) as LS_Uf,"
    select +=" round((avg(transactions.calculated_value) - STDDEV(transactions.calculated_value)) ,1) as LI_Uf,"
    select +=" round(avg(transactions.calculated_value),1),"
    select +=" round(STDDEV(transactions.calculated_value),1),"
    select +=" round(avg(total_surface_terrain),1) as avg_lands,"
    select +=" round(avg(total_surface_building),1) avg_surface_line_build,"
    select +=" round(avg(transactions.calculated_value) / avg(total_surface_building))as avg_uf_m2_u,"
    select +=" round(avg(transactions.calculated_value) / avg(total_surface_terrain)) as avg_uf_m2_land,"
    select +=" round(STDDEV(total_surface_terrain))  AS deviation_lands,"
    select +=" round(STDDEV(total_surface_building)) AS deviation_surface_line_build,"
    select +=" round(STDDEV(transactions.calculated_value) / avg(total_surface_building)) AS deviation_uf_m2_u,"
    select +=" round(STDDEV(transactions.calculated_value) / avg(total_surface_terrain)) AS deviation_uf_m2_land,"
    select +=" round(avg(total_surface_terrain) + coalesce(round(STDDEV(total_surface_terrain)))) AS LS_sup_land,"
    select +=" round(avg(total_surface_building) + coalesce(round(STDDEV(total_surface_building)))) as LS_surface_line_build,"
    select +=" round(avg(transactions.calculated_value) / avg(total_surface_building)) + round(STDDEV(transactions.calculated_value) / avg(total_surface_building)) as LS_uf_m2_u,"
    select +=" round(avg(transactions.calculated_value) / avg(total_surface_terrain)) + coalesce (round(STDDEV(transactions.calculated_value) / avg(total_surface_terrain))) AS LS_uf_m2_land,"
    select +=" round(avg(total_surface_terrain)) - coalesce(round(STDDEV(total_surface_terrain))) AS LI_sup_land,"
    select +=" round(avg(total_surface_building)) - round(STDDEV(total_surface_building)) as LI_surface_line_build,"
    select +=" round(avg(transactions.calculated_value) / avg(total_surface_building)) - round(STDDEV(transactions.calculated_value) / avg(total_surface_building)) as LI_uf_m2_u,"
    select +=" round(avg(transactions.calculated_value) / avg(total_surface_terrain))  - coalesce (round(STDDEV(transactions.calculated_value) / avg(total_surface_terrain)))  AS LI_uf_m2_land,"
    select +=" round(min(total_surface_terrain)) as min_lands,"
    select +=" round(min(total_surface_building))  as min_surface_line_build,"
    select +=" round(min(transactions.calculated_value) / avg(total_surface_building)) as min_uf_m2_u,"
    select +=" round(min(transactions.calculated_value) / avg(total_surface_terrain)) as min_uf_m2_land,"
    select +=" round(max(total_surface_terrain)) as max_lands, "
    select +=" round(max(total_surface_building)) as max_surface_line_build, "
    select +=" round(max(transactions.calculated_value) / avg(total_surface_building)) as max_uf_m2_u, "
    select +=" round(max(transactions.calculated_value) / avg(total_surface_terrain)) as max_uf_m2_land "


    data = Transaction.where(cond_query).select(select)
    data
  end
  def self.download_csv filters

    cond_query = build_conditions(filters, nil)
    data = Transaction.where(cond_query).
      select("st_x(the_geom) as longitude, st_y(the_geom) as latitude", :calculated_value, :address )
  end

  def self.to_csv(options = {})
    desired_column = ['latitude', 'longitude', 'calculated_value', 'address']
    header_names = ['Latitud', 'Longitud', 'Uf value', 'Direccion']
    CSV.generate(options) do |csv|
      csv << header_names
      all.each do |product|
        csv << product.attributes.values_at(*desired_column)
      end
    end
  end
end
