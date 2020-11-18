json.extract! @data, :address, :build_date, :sale_date, :transfer_date, :floors, :bimester, :year, :name, :total_units, :stock_units, :sold_units, :uf_m2, :agency_name, :mix_terrace_square_meters, :mix_usable_square_meters, :pp_uf, :pp_uf_m2, :vhmu, :percentage_sold, :project_type_id, :ps_terreno
json.project_id @project_id
json.project_status do
  json.name @data.project_status.name
end
json.charts do
json.offer_mix @offer_mix
json.sale_mix @sale_mix
end
