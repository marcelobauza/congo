-- Function: public.masd(integer)

-- DROP FUNCTION public.masd(integer);

CREATE OR REPLACE FUNCTION public.masd(proj_instance_id bigint)
RETURNS real AS
$BODY$
declare
result REAL;
BEGIN
  result = vhmd(proj_instance_id);

  if result > 0 then
    RETURN (select total_available(proj_instance_id) / result) as masd;
  else
    return result;
  end if;

                      END;
                      $BODY$
                      LANGUAGE plpgsql VOLATILE
                      COST 100;
                      ALTER FUNCTION public.masd(bigint)
                      OWNER TO postgres;

