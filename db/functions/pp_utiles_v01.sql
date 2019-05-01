CREATE OR REPLACE FUNCTION public.pp_utiles(proj_instance_id bigint)
RETURNS real AS
$BODY$
declare disp int;
BEGIN
  disp = (select sum(pim.stock_units)
    from project_instance_mixes pim
    where pim.project_instance_id = proj_instance_id);

  if (disp = 0) then
    return 0;
  else
    RETURN (select sum(pim.mix_usable_square_meters * pim.stock_units)/disp::int 
      as pp_utiles
      from project_instance_mixes pim
      where pim.project_instance_id = proj_instance_id);
  end if;
                                    END;
                                    $BODY$
                                    LANGUAGE plpgsql VOLATILE
                                    COST 100;
