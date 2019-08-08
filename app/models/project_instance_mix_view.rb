class ProjectInstanceMixView < ApplicationRecord

  belongs_to :project_status

  def self.data_popup project_id, bimester, year

    select = "bimester, year, address, project_status_id, build_date, sale_date, transfer_date, floors, project_status_id, name, project_instance_id,  "
    select += "sum(total_m2) as total_m2, agency_name, " 
    select += "sum(total_units) as total_units, " 
    select += "sum(stock_units) as stock_units, " 
    select += "sum(sold_units) as sold_units, "
    select += "sum(uf_m2) as uf_m2, "
    select += "sum(vhmu) as vhmu "
    group = %w[ bimester year project_status_id build_date sale_date transfer_date floors address project_status_id agency_name name project_instance_id  ]

    @data = ProjectInstanceMixView.where(project_id: project_id, bimester: bimester, year: year).group(group).select(select).first

  end



end
