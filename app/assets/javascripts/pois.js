load_pois = function(layerControl, cql_filter_pois, url){
  var options_info = {
    layers: "inciti_v2:pois_infos",//nombre de la capa (ver get capabilities)
    format: 'image/png',
    transparent: 'true',
    opacity: 1,
    version: '1.0.0',//wms version (ver get capabilities)
    tiled: true,
    styles: 'pois_info',
    INFO_FORMAT: 'application/json',
    format_options: 'callback:getJson',
    CQL_FILTER: cql_filter_pois
  };
  sourcePois = new L.tileLayer.betterWms("http://"+url+":8080/geoserver/wms", options_info);
  Congo.dashboards.config.sourcePois = sourcePois
  layerControl.addOverlay(sourcePois, "Puntos de Interés");
}
