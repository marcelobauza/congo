CREATE OR REPLACE FUNCTION public.cleangeometry(geometry)
RETURNS geometry AS
$BODY$DECLARE
inGeom ALIAS for $1;
outGeom geometry;
tmpLinestring geometry;

Begin

  outGeom := NULL;

  IF (GeometryType(inGeom) = 'POLYGON' OR GeometryType(inGeom) = 'MULTIPOLYGON') THEN
    if not isValid(inGeom) THEN
      tmpLinestring := st_union(st_multi(st_boundary(inGeom)),st_pointn(boundary(inGeom),1));
      outGeom = buildarea(tmpLinestring);
      IF (GeometryType(inGeom) = 'MULTIPOLYGON') THEN
        RETURN st_multi(outGeom);
      ELSE
        RETURN outGeom;
    END IF;
  else
    RETURN inGeom;
    END IF;
  ELSIF (GeometryType(inGeom) = 'LINESTRING') THEN
    outGeom := st_union(st_multi(inGeom),st_pointn(inGeom,1));
    RETURN outGeom;
  ELSIF (GeometryType(inGeom) = 'MULTILINESTRING') THEN
    outGeom := multi(st_union(st_multi(inGeom),st_pointn(inGeom,1)));
    RETURN outGeom;
  ELSE
    RAISE NOTICE 'The input type % is not supported',GeometryType(inGeom);
    RETURN inGeom;
    END IF;
    End;$BODY$
    LANGUAGE plpgsql VOLATILE
    COST 100;
    ALTER FUNCTION public.cleangeometry(geometry)
    OWNER TO postgres;
