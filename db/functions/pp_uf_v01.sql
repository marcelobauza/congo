CREATE OR REPLACE FUNCTION public.pp_uf(proj_instance_id bigint)
RETURNS real AS
$BODY$
declare t_m2 real;
BEGIN
  t_m2 = (select sum(total_m2) from project_instance_mix_views
    where project_instance_id = proj_instance_id);

  if (t_m2 = 0) then
    return 0;
  else
    RETURN (select (sum(total_m2 * uf_avg_percent)/t_m2)
      as pp_uf
      from project_instance_mix_views
      where project_instance_id = proj_instance_id);
  end if;
                                      END;
                                      $BODY$
                                      LANGUAGE plpgsql VOLATILE
                                      COST 100;
                                      ALTER FUNCTION public.pp_uf(bigint)
                                      OWNER TO postgres;
