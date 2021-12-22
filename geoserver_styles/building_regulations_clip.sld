<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
                       xmlns:ogc="http://www.opengis.net/ows"
                       xmlns:gml="http://www.opengis.net/gml">
    <NamedLayer>
        <Name>inciti_v2:building_regulations_info</Name>
        <UserStyle>
            <FeatureTypeStyle>
                <Transformation>
                    <Function name="gs:Clip">
                        <Function name="parameter">
                            <Literal>features</Literal>
                        </Function>
                        <Function name="parameter">
                            <Literal>clip</Literal>
                            <ogc:Function name="env">
                        <ogc:Literal>polygon</ogc:Literal>
                      </ogc:Function>
                        </Function>
                    </Function>
                </Transformation>
               <Rule>
          <Name>rule1</Name>
                
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
              #<ogc:PropertyName>color</ogc:PropertyName>
              </CssParameter>
              <CssParameter name="fill-opacity">0.5</CssParameter>
            </Fill>
            <Stroke>
              <CssParameter name="stroke">#ffffff</CssParameter>
              <CssParameter name="stroke-width">0.5</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
        </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer> 

</StyledLayerDescriptor>