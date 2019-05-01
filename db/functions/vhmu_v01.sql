CREATE OR REPLACE FUNCTION public.vhmu(
  total_units integer,
  stock_units integer,
  cadastre character varying,
  sale_date character varying)
RETURNS real AS
$BODY$
DECLARE m int;
BEGIN

  m = months2(cadastre, sale_date);
  RETURN (  SELECT CASE m WHEN 0 THEN 1
  ELSE (total_units - stock_units) / m::numeric END) as vhmu;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
    COST 100;
