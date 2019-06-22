-- Function: public.pxq(integer)

-- DROP FUNCTION public.pxq(integer);

CREATE OR REPLACE FUNCTION public.pxq(proj_instance_id bigint)
  RETURNS real AS
  $BODY$
  declare ppuf real;
  BEGIN
      ppuf = (select pp_uf(proj_instance_id));

        if (ppuf = 0) then
              return 0;
                else
                      RETURN (select vhmo(proj_instance_id) * ppuf / 1000) as pxq;
                        end if;

                      END;
                      $BODY$
                        LANGUAGE plpgsql VOLATILE
                          COST 100;
                          ALTER FUNCTION public.pxq(bigint)
                            OWNER TO postgres;

