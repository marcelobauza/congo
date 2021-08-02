class ProjectInstanceMixView < ApplicationRecord

  belongs_to :project_status

  def self.data_popup project_id, bimester, year
    select = " bimester, year, address, name, agency_name, project_status_id, sum(total_units) as total_units, sum(stock_units) as stock_units, "
    select +=" sum(sold_units) as sold_units, floors, pp_uf(project_instance_id) as pp_uf, "
    select +=" round(sum(vhmu),1) as vhmu, round((1::numeric - sum(stock_units)::numeric / sum(total_units::numeric)) * 100::numeric, 1) AS percentage_sold, "
    select +=" build_date, sale_date, transfer_date,   project_instance_id, round((avg(mix_usable_square_meters))::numeric,1) as mix_usable_square_meters, "
    select +=" round((avg(mix_terrace_square_meters))::numeric,1) as mix_terrace_square_meters, avg(uf_m2) as uf_m2,"
    select += "CASE project_type_id WHEN 2 THEN pp_uf_m2(project_instance_id) "
    select += "ELSE (SUM(project_instance_mix_views.total_m2 * uf_avg_percent) / (SUM(project_instance_mix_views.total_m2 * (mix_usable_square_meters + 0.25 * ps_terreno))))  END AS pp_uf_m2,"
    select +=" project_type_id, avg(ps_terreno) as ps_terreno "

    group = %w[ bimester year project_status_id build_date sale_date transfer_date floors address project_status_id agency_name name project_instance_id project_type_id ]

    @data = ProjectInstanceMixView.where(project_id: project_id, bimester: bimester, year: year).group(group).select(select).first
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


end
