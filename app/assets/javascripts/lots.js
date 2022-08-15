const load_lots = function(url){

  let options_lots = {
    layers: "inciti_v2:view_lots",//nombre de la capa (ver get capabilities)
    format: 'image/png',
    transparent: 'true',
    opacity: 1,
    version: '1.0.0',//wms version (ver get capabilities)
    tiled: true,
    styles: 'lots',
    INFO_FORMAT: 'application/json',
    format_options: 'callback:getJson'
  };

  return  new L.tileLayer.betterWms("https://"+url+"/geoserver/inciti_v2/wms", options_lots);
}
