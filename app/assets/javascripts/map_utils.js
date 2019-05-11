Congo.namespace('map_utils');

Congo.map_utils.config={
  radius: 0,
  centerpt: '',
  cql_filter: '',
  typeGeometry: '',
  size_box: ''
}


Congo.map_utils = function(){
  var url, map, groupLayer, editableLayers;
  var init = function(){
    url = window.location.hostname;
    var streets = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      updateWhenIdle: true,
      reuseTiles: true
    });

    map = L.map('map',{
      fadeAnimation: false,
      markerZoomAnimation: false,
      zoom: 9,
      center: [-33.113399134183744, -69.69339599609376],
      zoomControl: true,
      zoomAnimation: false,
      layers: [streets]
    }) ;

    $('#select_circle').on('click', function(event) {
      checked = $('#select_circle').hasClass('active');
      let typeGeometry='circle';
      if (checked){
        // editableLayers.eachLayer(function (layer) {
        //             mymap.removeLayer(layer);
        //           });

      }else{
        if(typeof(editableLayers)!=='undefined'){
          editableLayers.eachLayer(function (layer) {
            map.removeLayer(layer);
          });

        }
        editableLayers = new L.FeatureGroup();
        map.addLayer(editableLayers);
        poly(typeGeometry);
        map.on('draw:created', function(e) {
          layer = e.layer
          var centerPt = layer.getLatLng();
          var radius = layer.getRadius();
          Congo.map_utils.radius = (radius/1000);
          center = centerPt.lng +" " + centerPt.lat; 
          Congo.map_utils.typeGeometry = typeGeometry; 
          Congo.map_utils.centerpt = center;
          editableLayers.addLayer(layer);
          $('#select_circle').removeClass('active');
          counties();
        });
      }});
    $('#select_polygon').on('click', function(event) {
      let typeGeometry='polygon';
      size_box = [];

      if(typeof(editableLayers)!=='undefined'){
        editableLayers.eachLayer(function (layer) {
          map.removeLayer(layer);
        });
      }
      map.doubleClickZoom.disable();
      editableLayers = new L.FeatureGroup();
      map.addLayer(editableLayers);
      Congo.map_utils.typeGeometry = typeGeometry; 
      poly(typeGeometry);
      map.on('draw:created', function(e) {
        var arr1 = []
        var type = e.layerType,
          layer = e.layer;
        polygon = layer.getLatLngs();
        editableLayers.addLayer(layer);
        arr1 = LatLngsToCoords(polygon[0]);
        arr1.push(arr1[0])
        size_box.push(arr1);
        Congo.map_utils.size_box= size_box;
        counties();
      });
    });
  }

  var LatLngToCoords = function (LatLng, reverse) { // (LatLng, Boolean) -> Array
    var lat = parseFloat(LatLng.lat),
      lng = parseFloat(LatLng.lng);
    coord = lng +" "+ lat;
    return [coord];
  }

  var LatLngsToCoords = function (LatLngs, levelsDeep, reverse) { // (LatLngs, Number, Boolean) -> Array

    var i, len;
    var coords=[];

    for (i = 0, len = LatLngs.length; i < len; i++) {
      coord =  LatLngToCoords(LatLngs[i]);
      coords.push(coord);
    }
    return coords;
  }

  function poly(type){

    switch(type) {
      case 'circle':
        HandlerGeometry = new L.Draw.Circle(map);

        break;
      case 'polygon':
        var optionsDraw={
          shapeOptions: {
            color: '#d3d800',
          }
        }
        HandlerGeometry = new L.Draw.Polygon(map, optionsDraw);
        HandlerGeometry.enable();
        break;
    }
    HandlerGeometry.enable();       

  }  

  function BoundingBox(){
    var bounds = mymap.getBounds().getSouthWest().lng + "," + mymap.getBounds().getSouthWest().lat + "," + mymap.getBounds().getNorthEast().lng + "," + mymap.getBounds().getNorthEast().lat;
    return bounds;
  }

  counties = function(){
    if (groupLayer !=undefined){
      map.removeLayer(groupLayer);
    }

    typeGeometry = Congo.map_utils.typeGeometry;

    county_id = Congo.dashboards.config.county_id;
    switch(typeGeometry) {
      case 'circle':
        centerpt = Congo.map_utils.centerpt;
        radius = Congo.map_utils.radius;
        cql_filter ="DWITHIN(the_geom,Point("+center+"),"+radius+",kilometers)";
        break;
      case 'polygon':
        polygon_size = Congo.map_utils.size_box;
        cql_filter ="WITHIN(the_geom, Polygon(("+polygon_size+")))";

        break;
      default:
        cql_filter = "county_id='"+ county_id + "'";
        break;

    }
    groupLayer = L.layerGroup();
    layer_type = Congo.dashboards.config.layer_type;
    if(county_id != ''){
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
    }
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
      CQL_FILTER: cql_filter  };
    source_layers = new L.tileLayer.betterWms("http://"+url+":8080/geoserver/wms", options_layers);
    groupLayer.addLayer(source_layers);
    groupLayer.addTo(map);

  }

  return{
    init:init,
    counties: counties
  }
}();
