CREATE OR REPLACE FUNCTION public.months(proj_instance_id bigint)
  RETURNS real AS
  $BODY$
  BEGIN
      
      RETURN (select (date_part('year', to_date(pi.cadastre, 'DD/MM/YYYY')) - date_part('year', to_date(p.sale_date, 'DD/MM/YYYY'))) * 12 +
        (date_part('month', to_date(pi.cadastre, 'DD/MM/YYYY')) - date_part('month', to_date(p.sale_date, 'DD/MM/YYYY')))
        from project_instances pi inner join projects p
        on pi.project_id = p.id where pi.id = proj_instance_id) as months;

    END;
    $BODY$
      LANGUAGE plpgsql VOLATILE
        COST 100;
        ALTER FUNCTION public.months(bigint)
          OWNER TO postgres;
