-- Function: public.total_available(integer)

-- DROP FUNCTION public.total_available(integer);

CREATE OR REPLACE FUNCTION public.total_available(proj_instance_id bigint)
RETURNS integer AS
$BODY$
BEGIN

  RETURN (select sum(stock_units)
    from project_instance_mixes
    where project_instance_id = proj_instance_id) as total_available;

          END;
          $BODY$
          LANGUAGE plpgsql VOLATILE
          COST 100;
          ALTER FUNCTION public.total_available(bigint)
          OWNER TO postgres;
