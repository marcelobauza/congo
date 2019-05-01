CREATE OR REPLACE FUNCTION public.masud(
  total_units integer,
  stock_units integer,
  cadastre character varying,
  sale_date character varying)
RETURNS real AS
$BODY$
DECLARE m int;
BEGIN
  m = months2(cadastre, sale_date);
  RETURN ( SELECT CASE (total_units - stock_units) WHEN 0 THEN 0 
  ELSE CASE m WHEN 0 THEN null
  ELSE (stock_units / ((total_units - stock_units)::double precision /m)) END
                                                END) as masud;

                                            END;
                                            $BODY$
                                            LANGUAGE plpgsql VOLATILE
                                            COST 100;
