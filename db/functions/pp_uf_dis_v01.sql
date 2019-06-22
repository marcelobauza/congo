-- Function: public.pp_uf_dis(integer)

-- DROP FUNCTION public.pp_uf_dis(integer);

CREATE OR REPLACE FUNCTION public.pp_uf_dis(proj_instance_id bigint)
RETURNS real AS
$BODY$
declare sum_dis_m2 real;
BEGIN
  sum_dis_m2 = (select sum(dis_m2) from project_instance_mix_views where project_instance_id = proj_instance_id);

  if (sum_dis_m2 = 0) then
    return 0;
  else
    RETURN (select sum(dis_m2 * uf_avg_percent) / sum(dis_m2::real)
      from project_instance_mix_views
      where project_instance_id = proj_instance_id) as pp_uf_dis;
  end if;

                                END;
                                $BODY$
                                LANGUAGE plpgsql VOLATILE
                                COST 100;
                                ALTER FUNCTION public.pp_uf_dis(bigint)
                                OWNER TO postgres;

