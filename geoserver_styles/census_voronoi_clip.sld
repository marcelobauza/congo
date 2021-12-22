<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
                       xmlns:ogc="http://www.opengis.net/ows"
                       xmlns:gml="http://www.opengis.net/gml">
  <NamedLayer>
    <Name>inciti_v2:demography_info</Name>
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
          <Title>ABC1</Title>
          <ogc:Filter>
          <ogc:PropertyIsEqualTo>
          <ogc:PropertyName>gse_zn</ogc:PropertyName>
          <ogc:Literal>ABC1</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <!-- CssParameters allowed are fill (the color) and fill-opacity -->
              <CssParameter name="fill">#004b99</CssParameter>
              <CssParameter name="fill-opacity">0.5</CssParameter>
            </Fill>     
            <Stroke>
              <CssParameter name="stroke">#004b99</CssParameter>
              <CssParameter name="stroke-width">1</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
           </Rule>
               <Rule>
          <Title>C2</Title>
          <ogc:Filter>
          <ogc:PropertyIsEqualTo>
          <ogc:PropertyName>gse_zn</ogc:PropertyName>
          <ogc:Literal>C2</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <!-- CssParameters allowed are fill (the color) and fill-opacity -->
              <CssParameter name="fill">#3b8ea5</CssParameter>
              <CssParameter name="fill-opacity">0.5</CssParameter>
            </Fill>     
            <Stroke>
              <CssParameter name="stroke">#3b8ea5</CssParameter>
              <CssParameter name="stroke-width">1</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
           </Rule>
                <Rule>
          <Title>C3</Title>
          <ogc:Filter>
          <ogc:PropertyIsEqualTo>
          <ogc:PropertyName>gse_zn</ogc:PropertyName>
          <ogc:Literal>C3</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <!-- CssParameters allowed are fill (the color) and fill-opacity -->
              <CssParameter name="fill">#f5ee9e</CssParameter>
              <CssParameter name="fill-opacity">0.5</CssParameter>
            </Fill>     
            <Stroke>
              <CssParameter name="stroke">#f5ee9e</CssParameter>
              <CssParameter name="stroke-width">1</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
           </Rule>
                <Rule>
          <Title>D</Title>
          <ogc:Filter>
          <ogc:PropertyIsEqualTo>
          <ogc:PropertyName>gse_zn</ogc:PropertyName>
          <ogc:Literal>D</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <!-- CssParameters allowed are fill (the color) and fill-opacity -->
              <CssParameter name="fill">#f49e4c</CssParameter>
              <CssParameter name="fill-opacity">0.5</CssParameter>
            </Fill>     
            <Stroke>
              <CssParameter name="stroke">#f49e4c</CssParameter>
              <CssParameter name="stroke-width">1</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
           </Rule>
                <Rule>
          <Title>E</Title>
          <ogc:Filter>
          <ogc:PropertyIsEqualTo>
          <ogc:PropertyName>gse_zn</ogc:PropertyName>
          <ogc:Literal>E</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <!-- CssParameters allowed are fill (the color) and fill-opacity -->
              <CssParameter name="fill">#ab3428</CssParameter>
              <CssParameter name="fill-opacity">0.5</CssParameter>
            </Fill>     
            <Stroke>
              <CssParameter name="stroke">#ab3428</CssParameter>
              <CssParameter name="stroke-width">1</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
           </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer> 

</StyledLayerDescriptor>