SELECT
project_instances.bimester,
project_instances.year,
projects.code,
projects.name as project_name,
projects.address,
county_name(projects.county_id::integer),
projects.county_id,
(select name from agencies a inner join agency_rols ar on a.id = ar.agency_id where ar.project_id = projects.id and rol = 'INMOBILIARIA' )  as agency_name,
pim.model as model,
projects.floors,
pim.t_min,
pim.t_max,
pim.mix_usable_square_meters,
(select round((sum(((t_min + t_max) / 2 ) * total_units) / sum(total_units))::numeric,1) from project_instance_mixes where project_instance_id = project_instances.id) as pp_terreno,
pp_utiles(project_instances.id) AS pp_utiles,
project_mixes.bedroom,
project_mixes.bathroom,
pim.living_room,
pim.service_room,
pim.h_office,
pim.discount,
round(pim.uf_min * (1::numeric - pim.percentage / 100::numeric),0) AS uf_min_percent,
round(pim.uf_max * (1::numeric - pim.percentage / 100::numeric),0) AS uf_max_percent,
round((pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric,0) AS uf_avg_percent,
pp_uf(project_instances.id) AS pp_uf,
round(pim.uf_parking,0) as uf_parking,
round(pim.uf_cellar,0) as uf_cellar,
round((pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric / (pim.mix_usable_square_meters + ((t_min + t_max)/2) * 0.25)::numeric,1) AS uf_m2_ut,
(select round(sum((mix_usable_square_meters * total_units) * round((uf_min * (1::numeric - percentage / 100::numeric) + uf_max * (1::numeric - percentage / 100::numeric)) / 2::numeric / (mix_usable_square_meters + ((t_min + t_max)/2) * 0.25)::numeric,1)) / sum(mix_usable_square_meters * total_units), 2)  from project_instance_mixes where project_instance_id = project_instances.id ) as pp_UFm2ut,
round((pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric / pim.mix_usable_square_meters,1) AS uf_m2_u,
(select round(sum((mix_usable_square_meters * total_units) * round((uf_min * (1::numeric - percentage / 100::numeric) + uf_max * (1::numeric - percentage / 100::numeric)) / 2::numeric / mix_usable_square_meters,1) ) / sum(mix_usable_square_meters * total_units),1)  from project_instance_mixes where project_instance_id = project_instances.id ) as pp_UFm2u,
pim.total_units as total_units,

pim.stock_units,
pim.total_units - pim.stock_units AS sold_units,
months(project_instances.id) AS months,
round(vhmu(pim.total_units, pim.stock_units, project_instances.cadastre, projects.sale_date)::numeric,1) AS vhmu,
round(pxq(project_instances.id)::numeric,1) AS pxq,
round((vhmd(pim.project_instance_id) * pp_uf_dis(pim.project_instance_id) / 1000::double precision)::numeric,1) AS pxq_d,
project_statuses.name as status,
projects.build_date,
projects.sale_date,
projects.transfer_date,
project_instances.cadastre,
case when (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric   between 0 and 440 then '0 a 440'
     when (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric   between 441 and 929 then '441 a 929'
         when (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric   between 930 and 1549 then '930 a 1549'
             when (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric   between 1550 and 3399 then '1550 a 3399'
                 when (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric   between 3400 and 5390 then '3400 a 5390'
                     when (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric   between 5391 and 7950 then '5391 a 7950'
                         when (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric   between 7951 and 11500 then '7951 a 11500'
                             when (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric   between 11501 and 15600 then '11501 a 15600'
                                 when (pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric   between 156001 and 500000 then '156010 a 500000'
                                    end as range_uf,

                                    case when pim.mix_usable_square_meters between 0 and 30.99  then '< 30'
                                        when pim.mix_usable_square_meters between 31 and 45.99  then '31 a 45'
                                            when pim.mix_usable_square_meters between 46 and 60.99  then '46 a 60'
                                                when pim.mix_usable_square_meters between 61 and 80.99  then '61 a 80'
                                                    when pim.mix_usable_square_meters between 81 and 100.99  then '81 a 100'
                                                        when pim.mix_usable_square_meters between 101 and 120.99  then '101 a 120'
                                                            when pim.mix_usable_square_meters between 121 and 140.99  then '121 a 140'
                                                                when pim.mix_usable_square_meters between 141 and 160.99  then '141 a 160'
                                                                    when pim.mix_usable_square_meters between 161 and 180.99  then '161 a 180'
                                                                        when pim.mix_usable_square_meters between 181 and 200.99  then '181 a 200'
                                                                            when pim.mix_usable_square_meters > 200 then '>200'
                                    end as Range_util,
                                    project_types.name as project_type_name,
                                    pim.home_type,
                                    round(((pim.uf_min * (1::numeric - pim.percentage / 100::numeric) + pim.uf_max * (1::numeric - pim.percentage / 100::numeric)) / 2::numeric)) AS mix_uf_value,
                                    pim.mix_m2_field,
                                    pim.mix_m2_built,
                                    round((round((pim.total_units - pim.stock_units),2) / pim.total_units),2 ) as percentage_sold,
                                    projects.pilot_opening_date,
                                    round(masd(project_instances.id)::numeric,1) as vhmud,
                                    the_geom,
                                    st_x(the_geom) as x,
                                    st_y(the_geom) as y,
    projects.project_type_id,
    project_instances.project_status_id,
    pim.mix_id,
    pim.id as pim_id
                                    FROM projects
                                    INNER JOIN project_instances ON project_instances.project_id = projects.id
                                    INNER JOIN project_instance_mixes pim ON project_instances.id = pim.project_instance_id
                                    INNER JOIN project_mixes ON pim.mix_id = project_mixes.id
                                    INNER JOIN project_types ON project_types.id = projects.project_type_id
                                    INNER JOIN project_statuses ON project_statuses.id = project_instances.project_status_id
                                    WHERE   project_type_id =1
