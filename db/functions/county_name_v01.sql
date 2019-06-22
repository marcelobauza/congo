-- Function: public.country_name(integer)

-- DROP FUNCTION public.country_name(integer);

CREATE OR REPLACE FUNCTION public.county_name(county_id integer)
  RETURNS character varying AS
  $BODY$BEGIN
    RETURN(Select name from counties where id = county_id);
  END;$BODY$
    LANGUAGE plpgsql VOLATILE
      COST 100;
