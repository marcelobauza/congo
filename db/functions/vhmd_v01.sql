-- Function: public.vhmd(integer)

-- DROP FUNCTION public.vhmd(integer);

CREATE OR REPLACE FUNCTION public.vhmd(proj_instance_id bigint)
RETURNS real AS
$BODY$
declare
mixes RECORD;
result REAL;
BEGIN
  result = 0.0;

  for mixes in select project_instance_id, vhmu, masud from project_instance_mix_views where project_instance_id = proj_instance_id loop
    if mixes.masud > 0 then
      result = result + mixes.vhmu;
    end if;
  end loop;

  RETURN result;

                              END;
                              $BODY$
                              LANGUAGE plpgsql VOLATILE
                              COST 100;
                              ALTER FUNCTION public.vhmd(bigint)
                              OWNER TO postgres;

