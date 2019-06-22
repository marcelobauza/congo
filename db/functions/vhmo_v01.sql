-- Function: public.vhmo(integer)

-- DROP FUNCTION public.vhmo(integer);

CREATE OR REPLACE FUNCTION public.vhmo(proj_instance_id bigint)
  RETURNS real AS
  $BODY$
  BEGIN
      
      RETURN (select sum(vhmu) from project_instance_mix_views where project_instance_id = proj_instance_id) as vhmo;

    END;
    $BODY$
      LANGUAGE plpgsql VOLATILE
        COST 100;
        ALTER FUNCTION public.vhmo(bigint)
          OWNER TO postgres;
