load_pois = function(url){

  let options_info = {
    layers: "inciti_v2:pois_infos",//nombre de la capa (ver get capabilities)
    format: 'image/png',
    transparent: 'true',
    opacity: 1,
    version: '1.0.0',//wms version (ver get capabilities)
    tiled: true,
    styles: 'pois_info',
    INFO_FORMAT: 'application/json',
    format_options: 'callback:getJson'
  };

  return new L.tileLayer.betterWms("https://"+url+"/geoserver/inciti/wms", options_info);
}
