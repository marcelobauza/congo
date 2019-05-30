Congo.namespace('map_utils');

Congo.map_utils.config={
  radius: 0,
  centerpt: '',
  cql_filter: '',
  typeGeometry: '',
  size_box: ''
}

Congo.map_utils = function(){
  var url, map, groupLayer, editableLayers, HandlerGeometry, typeGeometry ;
  var init = function(){
    url = window.location.hostname;
    var streets = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      updateWhenIdle: false,
      reuseTiles: true
    });

    var grayscale =L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
      attribution: '',
      id: 'mapbox.light',
      accessToken: 'pk.eyJ1IjoiZmxhdmlhYXJpYXMiLCJhIjoiY2ppY2NzMm55MTN6OTNsczZrcGFkNHpoOSJ9.cL-mifEoJa6szBQUGnLmrA',
      updateWhenIdle: true,
      reuseTiles: true
    });

    map = L.map('map',{
      fadeAnimation: false,
      markerZoomAnimation: false,
      zoom: 11,
      center: [-33.4372, -70.6506],
      zoomControl: true,
      zoomAnimation: false,
      layers: [streets],
      loadingControl: true,
    }) ;

    map.addControl( new L.Control.Search({
      url: 'https://nominatim.openstreetmap.org/search?format=json&q={s}',
      jsonpParam: 'json_callback',
      propertyName: 'display_name',
      markerLocation: true,
      propertyLoc: ['lat','lon'],
      marker: L.circleMarker([0,0],{radius:30}),
      autoCollapse: true,
      autoType: false,
      minLength: 2
    }) );

    baseMaps = {
      //"Grayscale": grayscale,
      "Streets": streets,
    };

    layerControl = L.control.layers(baseMaps, '', {position: 'topleft'}).addTo(map);

    $('#select_circle').on('click', function(event) {
      typeGeometry='circle';
      if(typeof(editableLayers)!=='undefined'){
        editableLayers.eachLayer(function (layer) {
          map.removeLayer(layer);
        });
      }
      editableLayers = new L.FeatureGroup();
      map.addLayer(editableLayers);
      poly(typeGeometry);

    });

    $('#select_polygon').on('click', function(event) {
      typeGeometry='polygon';
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
    });

    $('#select_point').on('click', function(event) {
      typeGeometry='point';
      if(typeof(editableLayers)!=='undefined'){
        editableLayers.eachLayer(function (layer) {
          map.removeLayer(layer);
        });
      }
      editableLayers = new L.FeatureGroup();
      map.addLayer(editableLayers);
      poly(typeGeometry);

    });

    map.on('draw:created', function(e) {

      if(typeGeometry == 'circle'){

        layer = e.layer

        var centerPt = layer.getLatLng();
        var radius = layer.getRadius();
        Congo.map_utils.radius = (radius/1000);
        center = centerPt.lng +" " + centerPt.lat; 
        Congo.map_utils.typeGeometry = typeGeometry; 
        Congo.map_utils.centerpt = center;
        editableLayers.addLayer(layer);
      }
      if(typeGeometry == 'polygon'){
        var arr1 = []
        var type = e.layerType,
          layer = e.layer;
        polygon = layer.getLatLngs();
        editableLayers.addLayer(layer);
        arr1 = LatLngsToCoords(polygon[0]);
        arr1.push(arr1[0])
        size_box.push(arr1);
        Congo.map_utils.size_box= size_box;
      }
      if(typeGeometry == 'point'){

        layer = e.layer
        var centerPt = layer.getLatLng();
        center = centerPt.lng +" " + centerPt.lat; 
        Congo.map_utils.typeGeometry = typeGeometry; 
        Congo.map_utils.centerpt = center;

        $.ajax({
          async: false,
          type: 'GET',
          url: '/dashboards/filter_county_for_lon_lat.json',
          datatype: 'json',
          data: {lon: centerPt.lng, lat: centerPt.lat },
          success: function(data){
            Congo.dashboards.config.county_id = data['county_id'];
          }
        })
      }
      counties();
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
        break;
      case 'point':
        HandlerGeometry = new L.Draw.Marker(map, optionsDraw);
        break;

    }
    HandlerGeometry.enable();       

  }  

  function BoundingBox(){
    var bounds = map.getBounds().getSouthWest().lng + "," + map.getBounds().getSouthWest().lat + "," + map.getBounds().getNorthEast().lng + "," + map.getBounds().getNorthEast().lat;
    return bounds;
  }

  counties = function(){
    let bimester, year;
    if (groupLayer !=undefined){
      groupLayer.eachLayer(function(layer) { 
      console.log(layer);
        groupLayer.removeLayer(layer);});
      //map.removeLayer(groupLayer);
    }

    typeGeometry = Congo.map_utils.typeGeometry;
    $.ajax({
      async: false,
      type: 'GET',
      url: '/dashboards/filter_period.json',
      datatype: 'json',
      success: function(data){
        Congo.dashboards.config.year = data['year'];
        Congo.dashboards.config.bimester = data['bimester'];
      }
    });

    year = Congo.dashboards.config.year;
    bimester = Congo.dashboards.config.bimester;
    county_id = Congo.dashboards.config.county_id;

    layer_type = Congo.dashboards.config.layer_type;
    switch(layer_type) {
      case 'transactions_info':
          Congo.transactions.action_dashboards.indicator_transactions();
      break;
      case 'future_types_info':
          Congo.future_projects.action_dashboards.indicator_future_projects();
      break;
      case 'projects_feature_info':
        Congo.projects.action_dashboards.indicator_projects();
      break;
      case 'building_regulations_info':
      break;
    }






    switch(typeGeometry) {
      case 'circle':
        centerpt = Congo.map_utils.centerpt;
        radius = Congo.map_utils.radius;
        cql_filter ="DWITHIN(the_geom,Point("+center+"),"+radius+",kilometers) AND (bimester='"+ bimester +"' AND year='"+ year+"')";
        break;
      case 'polygon':
        polygon_size = Congo.map_utils.size_box;
        cql_filter ="WITHIN(the_geom, Polygon(("+polygon_size+"))) AND (bimester='"+ bimester +"' AND year='"+ year+"')";
        break;
      case 'point':
        cql_filter = "county_id='"+ county_id + "' AND (bimester='"+ bimester +"' AND year='"+ year+"')";
        break;
      default:
        cql_filter = "county_id='"+ county_id + "' AND bimester='"+ bimester +"' AND year='"+ year+"'";
        break;
    }

    groupLayer = L.layerGroup();

    style_layer = Congo.dashboards.config.style_layer;
    env = Congo.dashboards.config.env;

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
      styles: style_layer,
      INFO_FORMAT: 'application/json',
      format_options: 'callback:getJson',
      env: env,
      CQL_FILTER: cql_filter  };
    source_layers = new L.tileLayer.betterWms("http://"+url+":8080/geoserver/wms", options_layers);
    groupLayer.addLayer(source_layers);
    groupLayer.addTo(map);




    var htmlLegend1and2 = L.control.htmllegend({
      position: 'bottomleft',
      legends: [{
        name: "ver name",
        layer: source_layers ,
        elements: [{
          label: '',
          html: '',
          style: {
            'background-color': 'red',
            'width': '10px',
            'height': '10px'
          }
        }]
      }],
      collapseSimple: true,
      detectStretched: true,
      collapsedOnInit: true,
      defaultOpacity: 1,
      visibleIcon: 'icon icon-eye',
      hiddenIcon: 'icon icon-eye-slash'
    })
    map.addControl(htmlLegend1and2)
    groupLayer.addTo(map);
    return;
  }

  return{
    init:init,
    counties: counties
  }
}();
