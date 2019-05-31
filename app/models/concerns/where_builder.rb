module WhereBuilder
  extend ActiveSupport::Concern

  def self.build_within_condition(wkt)
    "ST_Within(the_geom, ST_GeomFromText('#{wkt}', #{Util::WGS84_SRID}))"
  end

  def self.build_within_condition_radius(center_pt, radius)
    "ST_DWithin(the_geom, ST_GeomFromText('POINT(#{center_pt})', #{Util::WGS84_SRID}), #{radius})"
  end

  def self.build_intersection_condition(wkt)
    "ST_Intersection(the_geom, ST_GeomFromText('#{wkt}', #{Util::WGS84_SRID}))"
  end

  def self.build_intersects_condition(wkt)
    "ST_Intersects(the_geom, ST_GeomFromText('#{wkt}', #{Util::WGS84_SRID}))"
  end

  def self.build_equal_condition(column, value)
    query = ""

    if Util.numeric?(value)
      query = column.to_s + " = " + value.to_s
    else
      query = column.to_s + " = '" + value + "'"
    end

    query
  end

  def self.build_in_condition(column, values)
    "#{column} IN(#{values.join(",")})"
  end

  def self.build_like_condition(column, value)
    "#{column} LIKE '%#{value}%'"
  end

  def self.build_between_condition(column, value_from, value_to)
    query = ""

    if Util.numeric?(value_from)
      query = "#{column} BETWEEN #{value_from.to_s} AND #{value_to.to_s}"
    else
      query = "#{column} BETWEEN '#{value_from.to_s}' AND '#{value_to.to_s}'"
    end

    query
  end

  #RANGES CONDITIONS --------------------------------------------------------

  def self.build_range_periods_by_quarter(to_period, to_year, quantity)
    query = "("
    quarters = Period.get_periods(to_period.to_i, to_year.to_i, quantity, 2)

    quarters.each do |q|
      query += "(quarter = #{q[:period]} and year = #{q[:year]})#{Util.or}"
    end

    query = query.chomp(Util.or) + ")#{Util.and}"
  end

  def self.build_range_periods_by_bimester(to_period, to_year, quantity, useView = false)
    query = "(" 
    bimesters = Period.get_periods(to_period.to_i, to_year.to_i, quantity, 1)

    if(!useView)
      bimesters.each do |b| 
        query += "(bimester = #{b[:period]} and year = #{b[:year]})#{Util.or}"
      end 
    else
      bimesters.each do |b| 
        query += "(project_instance_views.bimester = #{b[:period]} and project_instance_views.year = #{b[:year]})#{Util.or}"
      end 
    end 

    query = query.chomp(Util.or) + ")#{Util.and}"
  end 

def self.build_range_periods_by_bimester(to_period, to_year, quantity, useView = false)
  query = "("
  bimesters = Period.get_periods(to_period.to_i, to_year.to_i, quantity, 1)
  if(!useView)
     bimesters.each do |b|
    query += "(bimester = #{b[:period]} and year = #{b[:year]})#{Util.or}"
     end
  else
    bimesters.each do |b|
      query += "(project_instance_views.bimester = #{b[:period]} and project_instance_views.year = #{b[:year]})#{Util.or}"
    end
  end

  query = query.chomp(Util.or) + ")#{Util.and}"
end

def self.build_quarters_condition(periods, years)
  query = "("

  0.upto(periods.count - 1) do |i|
    query += "(quarter = #{periods[i]} AND year = #{years[i]})#{Util.or}"
  end

  query = query.chomp(Util.or) + ")#{Util.and}"
end

def self.build_bimesters_condition(periods, years, useView = false)
  query = "("

  if(!useView)
    0.upto(periods.count - 1) do |i|
      query += "(bimester = #{periods[i]} AND year = #{years[i]})#{Util.or}"
    end
  else
    0.upto(periods.count - 1) do |i|
      query += "(project_instance_views.bimester = #{periods[i]} AND project_instance_views.year = #{years[i]})#{Util.or}"
    end
  end

  query = query.chomp(Util.or) + ")#{Util.and}"
end

end
