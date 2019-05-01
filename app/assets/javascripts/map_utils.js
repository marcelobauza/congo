Congo.namespace('map_utils');

Congo.map_utils = function(){
  var url, map, groupLayer;
  var init = function(){
    url = window.location.hostname;
    var streets = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      updateWhenIdle: true,
      reuseTiles: true
    });

    map = L.map('map',{
      zoom: 9,
      center: [-33.113399134183744, -69.69339599609376],
      zoomControl: true,
      layers: [streets]
    }) ;
  }

  function BoundingBox(){
    var bounds = mymap.getBounds().getSouthWest().lng + "," + mymap.getBounds().getSouthWest().lat + "," + mymap.getBounds().getNorthEast().lng + "," + mymap.getBounds().getNorthEast().lat;
    return bounds;
  }

  counties = function(){
    if (groupLayer !=undefined){
      map.removeLayer(groupLayer);
    }

    groupLayer = L.layerGroup();
    county_id = Congo.dashboards.config.county_id;
    layer_type = Congo.dashboards.config.layer_type;
    var options = {

      layers: "inciti_v2:counties_info",//nombre de la capa (ver get capabilities)
      format: 'image/png',
      transparent: 'true',
      opacity: 1,
      version: '1.0.0',//wms version (ver get capabilities)
      tiled: true,
      styles: 'polygon',
      INFO_FORMAT: 'application/json',
      format_options: 'callback:getJson',
      CQL_FILTER: "id='"+ county_id + "'"
    };
    source = new L.tileLayer.betterWms("http://"+url+":8080/geoserver/wms", options);

    groupLayer.addLayer(source);
    var options_layers = {

      layers: "inciti_v2:"+ layer_type,//nombre de la capa (ver get capabilities)
      format: 'image/png',
      transparent: 'true',
      opacity: 1,
      version: '1.0.0',//wms version (ver get capabilities)
      tiled: true,
      styles: 'poi_new',
      INFO_FORMAT: 'application/json',
      format_options: 'callback:getJson',
      CQL_FILTER: "county_id='"+ county_id + "'"
    };
    source_layers = new L.tileLayer.betterWms("http://"+url+":8080/geoserver/wms", options_layers);
    groupLayer.addLayer(source_layers);
    groupLayer.addTo(map); 
  }
  return{
    init:init,
    counties: counties
  }
}();
