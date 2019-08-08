json.extract! @data, :address, :build_date, :sale_date, :transfer_date, :floors, :bimester, :year, :name, :total_units, :stock_units, :sold_units, :uf_m2, :agency_name

json.project_status do 
  json.name @data.project_status.name
end

json.offer_mix @offer_mix
json.sale_mix @sale_mix

