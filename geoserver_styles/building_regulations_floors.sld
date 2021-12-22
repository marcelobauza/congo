<?xml version="1.0" encoding="UTF-8"?>
<sld:StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:sld="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml" version="1.0.0">
  <sld:NamedLayer>
    <sld:Name>graduated_points_stock_units</sld:Name>
    <sld:UserStyle>
      <sld:Name>graduated_points_stock_units</sld:Name>
      <sld:Title>Point with variable color and size</sld:Title>
      <sld:FeatureTypeStyle>
        <sld:Name>name</sld:Name>
        <sld:Rule>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>freezed</ogc:PropertyName>
              <ogc:Literal>true</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
         <PolygonSymbolizer>
            <Fill>
              <sld:CssParameter name="fill">#FF00FF</sld:CssParameter>
              <sld:CssParameter name="fill-opacity">1</sld:CssParameter>
            </Fill>
            <Stroke>
              <CssParameter name="stroke">#ffffff</CssParameter>
              <CssParameter name="stroke-width">0.8</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <ogc:Filter>
            <ogc:PropertyIsLess>
              <ogc:PropertyName>floors</ogc:PropertyName>
              <ogc:Literal>4</ogc:Literal>
            </ogc:PropertyIsLess>
          </ogc:Filter>
         
          <PolygonSymbolizer>
            <Fill>
              <sld:CssParameter name="fill">#d73027</sld:CssParameter>
              <sld:CssParameter name="fill-opacity">1</sld:CssParameter>
            </Fill>
            <Stroke>
              <CssParameter name="stroke">#ffffff</CssParameter>
              <CssParameter name="stroke-width">0.5</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
        </sld:Rule>

        <sld:Rule>
          <ogc:Filter>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>floors</ogc:PropertyName>
                <ogc:Literal>4</ogc:Literal>
              </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <sld:CssParameter name="fill">#fc8d59</sld:CssParameter>
              <sld:CssParameter name="fill-opacity">1</sld:CssParameter>
            </Fill>
            <Stroke>
              <CssParameter name="stroke">#ffffff</CssParameter>
              <CssParameter name="stroke-width">0.5</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
        </sld:Rule>

        <sld:Rule>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>floors</ogc:PropertyName>
                <ogc:Literal>5</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>floors</ogc:PropertyName>
                <ogc:Literal>9</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
          <TextSymbolizer>
            <Label>
              <ogc:PropertyName>building_zone</ogc:PropertyName>
            </Label>
            <Font>
              <CssParameter name="font-family">Helvetica</CssParameter>
              <CssParameter name="font-size">8</CssParameter>
              <CssParameter name="font-style">normal</CssParameter>
            </Font>
            <LabelPlacement>
              <PointPlacement><AnchorPoint>
                <AnchorPointX>0.5</AnchorPointX>
                <AnchorPointY>0.0</AnchorPointY>
                </AnchorPoint>
              </PointPlacement>
            </LabelPlacement>
            <Fill>
              <CssParameter name="fill">#000000</CssParameter>
            </Fill>
            <VendorOption name="autoWrap">100</VendorOption>
            <VendorOption name="maxDisplacement">50</VendorOption>
            <VendorOption name="repeat">0</VendorOption>
          </TextSymbolizer>
          <PolygonSymbolizer>
            <Fill>
              <sld:CssParameter name="fill">#fee090</sld:CssParameter>
              <sld:CssParameter name="fill-opacity">1</sld:CssParameter>
            </Fill>
            <Stroke>
              <CssParameter name="stroke">#ffffff</CssParameter>
              <CssParameter name="stroke-width">0.5</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
        </sld:Rule>

        <sld:Rule>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>floors</ogc:PropertyName>
                <ogc:Literal>9</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>floors</ogc:PropertyName>
                <ogc:Literal>16</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
          <TextSymbolizer>
            <Label>
              <ogc:PropertyName>building_zone</ogc:PropertyName>
            </Label>
            <Font>
              <CssParameter name="font-family">Helvetica</CssParameter>
              <CssParameter name="font-size">8</CssParameter>
              <CssParameter name="font-style">normal</CssParameter>
            </Font>
            <LabelPlacement>
              <PointPlacement><AnchorPoint>
                <AnchorPointX>0.5</AnchorPointX>
                <AnchorPointY>0.0</AnchorPointY>
                </AnchorPoint>
              </PointPlacement>
            </LabelPlacement>
            <Fill>
              <CssParameter name="fill">#000000</CssParameter>
            </Fill>
            <VendorOption name="autoWrap">100</VendorOption>
            <VendorOption name="maxDisplacement">50</VendorOption>
            <VendorOption name="repeat">0</VendorOption>
          </TextSymbolizer>
          <PolygonSymbolizer>
            <Fill>
              <sld:CssParameter name="fill">#e0f3f</sld:CssParameter>
              <sld:CssParameter name="fill-opacity">1</sld:CssParameter>
            </Fill>
            <Stroke>
              <CssParameter name="stroke">#ffffff</CssParameter>
              <CssParameter name="stroke-width">0.5</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
        </sld:Rule>


        <sld:Rule>
          <ogc:Filter>
            <ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyName>floors</ogc:PropertyName>
              <ogc:Literal>16</ogc:Literal>
            </ogc:PropertyIsGreaterThanOrEqualTo>
          </ogc:Filter>
          <TextSymbolizer>
            <Label>
              <ogc:PropertyName>building_zone</ogc:PropertyName>
            </Label>
            <Font>
              <CssParameter name="font-family">Helvetica</CssParameter>
              <CssParameter name="font-size">8</CssParameter>
              <CssParameter name="font-style">normal</CssParameter>             
            </Font>
            <LabelPlacement>
              <PointPlacement><AnchorPoint>
                <AnchorPointX>0.5</AnchorPointX>
                <AnchorPointY>0.0</AnchorPointY>
                </AnchorPoint>
              </PointPlacement>
            </LabelPlacement>
            <Fill>
              <CssParameter name="fill">#000000</CssParameter>
            </Fill>
            <VendorOption name="autoWrap">100</VendorOption>
            <VendorOption name="maxDisplacement">50</VendorOption>
            <VendorOption name="repeat">0</VendorOption>
          </TextSymbolizer>
          <PolygonSymbolizer>
            <Fill>
              <sld:CssParameter name="fill">#FFFF00</sld:CssParameter>
              <sld:CssParameter name="fill-opacity">0.8</sld:CssParameter>
            </Fill>
            <Stroke>
              <CssParameter name="stroke">#ffffff</CssParameter>
              <CssParameter name="stroke-width">0.5</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>