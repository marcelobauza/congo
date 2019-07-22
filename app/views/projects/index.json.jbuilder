json.extract! @data, :address, :build_date, :sale_date, :transfer_date, :floors, :bimester, :year, :name, :total_units, :stock_units, :sold_units, :uf_m2

json.project_status do 
  json.name @data.project_status.name
end
