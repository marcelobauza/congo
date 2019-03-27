Congo.namespace('map_utils');

Congo.map_utils = function(){
  var url, map;
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
      zoomControl: false,
      layers: [streets]
    }) ;
  }
 
  function BoundingBox(){
       var bounds = mymap.getBounds().getSouthWest().lng + "," + mymap.getBounds().getSouthWest().lat + "," + mymap.getBounds().getNorthEast().lng + "," + mymap.getBounds().getNorthEast().lat;
       return bounds;
     }

  counties = function(){
    
        name_layer = Congo.dashboards.config.name_layer;
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
             CQL_FILTER: "name='"+ name_layer + "'"
           };
            source = new L.tileLayer.betterWms("http://"+url+":8080/geoserver/wms", options);
            source.addTo(map);

        
//var sw = map.options.crs.source(map.getBounds().getSouthWest());
      console.log(map.options.crs);
    // map.fitBounds(source.getBounds());
  
  }
  return{
    init:init,
    counties: counties
  }
}();