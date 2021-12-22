<?xml version="1.0" encoding="UTF-8"?>
<sld:StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:sld="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml" version="1.0.0">
  <sld:NamedLayer>
    <sld:Name>graduated_points_uf_m2_u</sld:Name>
    <sld:UserStyle>
      <sld:Name>graduated_points_uf_m2_u</sld:Name>
      <sld:Title>Point with variable color and size</sld:Title>
      <sld:FeatureTypeStyle>
        <sld:Name>name</sld:Name>
        <sld:Rule>
          <ogc:Filter>
            <ogc:PropertyIsLess>
              <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
              <ogc:Literal>27</ogc:Literal>
            </ogc:PropertyIsLess>
          </ogc:Filter>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#b9fc30</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.8</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#FFFFFF</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>
                <ogc:Literal>12</ogc:Literal>
              </sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
         <sld:Rule>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
                  <ogc:Literal>27</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
                  <ogc:Literal>53</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
         <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#fcd930</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.8</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#FFFFFF</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>
                <ogc:Literal>16</ogc:Literal>
              </sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        
         <sld:Rule>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
                  <ogc:Literal>53</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
                  <ogc:Literal>64</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
         <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#fda821</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.8</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#FFFFFF</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>
                <ogc:Literal>16</ogc:Literal>
              </sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        
        
         <sld:Rule>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
                  <ogc:Literal>64</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
                  <ogc:Literal>83</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
         <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#fa7c16</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.8</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#FFFFFF</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>
                <ogc:Literal>20</ogc:Literal>
              </sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
    
         <sld:Rule>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
                  <ogc:Literal>83</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
                  <ogc:Literal>102</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
         <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#f94710</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.8</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#FFFFFF</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>
                <ogc:Literal>24</ogc:Literal>
              </sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
         <sld:Rule>
          <ogc:Filter>
                <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>uf_m2_u</ogc:PropertyName>
                  <ogc:Literal>102</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
          </ogc:Filter>
         <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#9d2608</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.8</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#FFFFFF</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>
                <ogc:Literal>28</ogc:Literal>
              </sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>