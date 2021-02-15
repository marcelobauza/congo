
const load_lots = function(map, layerControl, url){
  var options_lots = {
    layers: "inciti_v2:view_lots",//nombre de la capa (ver get capabilities)
    format: 'image/png',
    transparent: 'true',
    opacity: 1,
    version: '1.0.0',//wms version (ver get capabilities)
    tiled: true,
    styles: 'lots',
    INFO_FORMAT: 'application/json',
    format_options: 'callback:getJson',
    CQL_FILTER: cql_filter_pois
  };
  sourceLots = new L.tileLayer.betterWms("http://"+url+":8080/geoserver/wms", options_lots);
  Congo.dashboards.config.sourceLots = sourceLots,
  layerControl.addOverlay(sourceLots, "Plancheta Predial");
}
