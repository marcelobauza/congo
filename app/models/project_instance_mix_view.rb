class ProjectInstanceMixView < ApplicationRecord

  belongs_to :project_status

  def self.data_popup project_id, bimester, year

    select = "bimester, year, address, project_status_id, build_date, sale_date, transfer_date, floors, name, project_instance_id, mix_usable_square_meters, mix_terrace_square_meters,  "
    select += "sum(total_m2) as total_m2, agency_name, " 
    select += "sum(total_units) as total_units, " 
    select += "sum(stock_units) as stock_units, " 
    select += "sum(sold_units) as sold_units, "
    select += "sum(uf_m2) as uf_m2, "
    select += "sum(vhmu) as vhmu, "
    select += "round((1::numeric - sum(stock_units)::numeric / sum(total_units::numeric)) * 100::numeric, 1) AS percentage_sold, "
    select += "pp_uf(project_instance_id) as pp_uf, "
    select += "pp_uf_m2(project_instance_id) as pp_uf_m2 "
    group = %w[ bimester year project_status_id build_date sale_date transfer_date floors address project_status_id agency_name name project_instance_id mix_usable_square_meters mix_terrace_square_meters  ]

    @data = ProjectInstanceMixView.where(project_id: project_id, bimester: bimester, year: year).group(group).select(select).first
  end



end
