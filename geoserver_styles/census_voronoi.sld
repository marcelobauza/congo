<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gml="http://www.opengis.net/gml"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>USA states population</Name>
    <UserStyle>
      <Name>population</Name>
      <Title>Population in the United States</Title>
      <Abstract>A sample filter that filters the United States into three
        categories of population, drawn in different colors</Abstract>
      <FeatureTypeStyle>
        <Rule>
          <Title>2</Title>
          <ogc:Filter>
            <ogc:PropertyIsLessThan>
             <ogc:PropertyName>homes_total</ogc:PropertyName>
             <ogc:Literal>10</ogc:Literal>
            </ogc:PropertyIsLessThan>
          </ogc:Filter>
          <PolygonSymbolizer>
             <Fill>
                <!-- CssParameters allowed are fill (the color) and fill-opacity -->
                <CssParameter name="fill">#ffff00</CssParameter>
                <CssParameter name="fill-opacity">0.7</CssParameter>
             </Fill>     
          </PolygonSymbolizer>
        </Rule>
         <Rule>
          <Title>3</Title>
          <ogc:Filter>
            <ogc:And>
            <ogc:PropertyIsLessThanOrEqualTo>
             <ogc:PropertyName>homes_total</ogc:PropertyName>
             <ogc:Literal>11</ogc:Literal>
            </ogc:PropertyIsLessThanOrEqualTo>
              <ogc:PropertyIsLessThan>
             <ogc:PropertyName>homes_total</ogc:PropertyName>
             <ogc:Literal>50</ogc:Literal>
            </ogc:PropertyIsLessThan>
         </ogc:And>
          </ogc:Filter>
          <PolygonSymbolizer>
             <Fill>
                <!-- CssParameters allowed are fill (the color) and fill-opacity -->
                <CssParameter name="fill">#FF0000</CssParameter>
                <CssParameter name="fill-opacity">0.7</CssParameter>
             </Fill>     
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Title>3</Title>
          <ogc:Filter>
            <ogc:And>
            <ogc:PropertyIsLessThanOrEqualTo>
             <ogc:PropertyName>homes_total</ogc:PropertyName>
             <ogc:Literal>51</ogc:Literal>
            </ogc:PropertyIsLessThanOrEqualTo>
              <ogc:PropertyIsLessThan>
             <ogc:PropertyName>homes_total</ogc:PropertyName>
             <ogc:Literal>100</ogc:Literal>
            </ogc:PropertyIsLessThan>
         </ogc:And>
          </ogc:Filter>
          <PolygonSymbolizer>
             <Fill>
                <!-- CssParameters allowed are fill (the color) and fill-opacity -->
                <CssParameter name="fill">#F8F32B</CssParameter>
                <CssParameter name="fill-opacity">0.7</CssParameter>
             </Fill>     
          </PolygonSymbolizer>
        </Rule>
         <Rule>
          <Title>6</Title>
          <ogc:Filter>
            <ogc:PropertyIsLessThanOrEqualTo>
             <ogc:PropertyName>homes_total</ogc:PropertyName>
             <ogc:Literal>101</ogc:Literal>
            </ogc:PropertyIsLessThanOrEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
             <Fill>
                <!-- CssParameters allowed are fill (the color) and fill-opacity -->
                <CssParameter name="fill">#4169E1</CssParameter>
                <CssParameter name="fill-opacity">0.7</CssParameter>
             </Fill>     
          </PolygonSymbolizer>
        </Rule>
        
     </FeatureTypeStyle>
    </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>