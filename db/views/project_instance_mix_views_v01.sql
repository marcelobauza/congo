SELECT 
  pim.project_instance_id,
  pim.uf_min * (1::numeric - pim.percentage / 100::numeric) AS uf_min_percent,
  pim.uf_max * (1::numeric - pim.percentage / 100::numeric) AS uf_max_percent,
  (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric AS uf_avg_percent,
  pim.mix_usable_square_meters * pim.total_units::numeric AS total_m2,
  pim.mix_usable_square_meters + pim.mix_terrace_square_meters * 0.5 AS u_half_terrace,
  (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric / (pim.mix_usable_square_meters + pim.mix_terrace_square_meters * 0.5) AS uf_m2,
  ((pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric)::double precision / (pim.mix_usable_square_meters::double precision + (pim.t_min + pim.t_max) / 2::double precision * 0.25::double precision) AS uf_m2_home,
  (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric / pim.mix_usable_square_meters AS uf_m2_u,
  vhmu(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date)::numeric AS vhmu,
  pim.stock_units::numeric * pim.mix_usable_square_meters AS dis_m2,
  masud(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date) AS masud,
  CASE 
      masud(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date)
  WHEN 0 
  THEN 0::real
  ELSE 
    vhmu(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date)
  END AS vhmud,
  pim.total_units - pim.stock_units AS sold_units,
  pim.id,
  (pim.t_min + pim.t_max) / 2::double precision AS ps_terreno,
  pim.stock_units,
  pim.total_units,
  pim.mix_terrace_square_meters,
  pim.mix_usable_square_meters,
  pim.t_min,
  pim.t_max,
  p.county_id,
  p.id AS project_id,
  p.the_geom,
  pi.year,
  pi.bimester,
  pi.project_status_id,
  p.project_type_id,
  pim.mix_id,
  p.name,
  pp_utiles(pi.id) AS pp_utiles,
  p.floors,
  p.agency_id
FROM project_instance_mixes pim
JOIN project_instances pi ON pim.project_instance_id = pi.id
JOIN projects p ON pi.project_id = p.id;

