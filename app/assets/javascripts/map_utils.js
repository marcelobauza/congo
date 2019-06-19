Congo.namespace('map_utils');

Congo.map_utils.config={
  radius: 0,
  centerpt: '',
  cql_filter: '',
  typeGeometry: '',
  size_box: ''
}

Congo.map_utils = function(){
  var url, map, groupLayer, editableLayers, HandlerGeometry, typeGeometry , layerControl, sourcePois, overlays;
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
      "Grayscale": grayscale,
      "Streets": streets,
    };
var overlays =  {
      };
    layerControl = L.control.layers(baseMaps, overlays, {position: 'topleft'}).addTo(map);



    $('#select_circle').on('click', function(event) {
      typeGeometry='circle';
      if(typeof(editableLayers)!=='undefined'){
        editableLayers.eachLayer(function (layer) {
          map.removeLayer(layer);
        });
      }

      Congo.dashboards.config.county_id = '';
      Congo.map_utils.size_box = '';
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
      Congo.dashboards.config.county_id = '';
      Congo.map_utils.centerpt = '';
      Congo.map_utils.radius = '';
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
      Congo.map_utils.centerpt = '';
      Congo.map_utils.radius = '';
      Congo.map_utils.size_box = '';
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
    let bimester, year, filter_for_layer;
    if (groupLayer !=undefined){
      groupLayer.eachLayer(function(layer) {
        groupLayer.removeLayer(layer);});
      //map.removeLayer(groupLayer);
    }

    if (sourcePois !=undefined){
      map.removeLayer(sourcePois);

    }
    map.removeControl(layerControl);
    layerControl = L.control.layers(baseMaps, overlays, {position: 'topleft'}).addTo(map);
    layer_type = Congo.dashboards.config.layer_type;

    switch(layer_type) {
      case 'transactions_info':
        $.ajax({
          async: false,
          type: 'GET',
          url: '/transactions/period.json',
          datatype: 'json',
          success: function(data){
            Congo.dashboards.config.year = data['data'][0]['year'];
            Congo.dashboards.config.bimester = data['data'][0]['period'];
          }
        });
        year = Congo.dashboards.config.year;
        bimester = Congo.dashboards.config.bimester;
        Congo.transactions.action_dashboards.indicator_transactions();
        filter_layer = "AND (bimester='"+ bimester +"' AND year='"+ year+"')";
        break;
      case 'future_projects_info':
        $.ajax({
          async: false,
          type: 'GET',
          url: '/future_projects/period.json',
          datatype: 'json',
          success: function(data){
            Congo.dashboards.config.year = data['data'][0]['year'];
            Congo.dashboards.config.bimester = data['data'][0]['period'];
          }
        });
        year = Congo.dashboards.config.year;
        bimester = Congo.dashboards.config.bimester;
        Congo.future_projects.action_dashboards.indicator_future_projects();
        filter_layer = "AND (bimester='"+ bimester +"' AND year='"+ year+"')";
        break;
      case 'projects_feature_info':
        Congo.projects.action_dashboards.indicator_projects();
        filter_layer = "AND (bimester='"+ bimester +"' AND year='"+ year+"')";
        break;
      case 'building_regulations_info':
        Congo.building_regulations.action_dashboards.indicator_building_regulations();
        filter_layer = '';
        break;
    }

    typeGeometry = Congo.map_utils.typeGeometry;
    switch(typeGeometry) {
      case 'circle':
        centerpt = Congo.map_utils.centerpt;
        radius = Congo.map_utils.radius;
        cql_filter ="DWITHIN(the_geom,Point("+center+"),"+radius+",kilometers)"+ filter_layer;
        cql_filter_pois ="DWITHIN(the_geom,Point("+center+"),"+radius+",kilometers)";
        break;
      case 'polygon':
        polygon_size = Congo.map_utils.size_box;
        cql_filter ="WITHIN(the_geom, Polygon(("+polygon_size+"))) "+ filter_layer;
        cql_filter_pois ="WITHIN(the_geom, Polygon(("+polygon_size+"))) ";
        break;
      case 'point':
        county_id = Congo.dashboards.config.county_id;
        cql_filter = "county_id='"+ county_id + "'"+   filter_layer;
        cql_filter_pois = "county_id='"+ county_id + "'";
        break;
      default:
        Congo.map_utils.centerpt = '';
        Congo.map_utils.radius = '';
        Congo.map_utils.size_box = '';
        county_id = Congo.dashboards.config.county_id;
        cql_filter = "county_id='"+ county_id +"'"+ filter_layer;
        cql_filter_pois = "county_id='"+ county_id + "'";
        break;
    }

    groupLayer = L.layerGroup();

    style_layer = Congo.dashboards.config.style_layer;
    env = Congo.dashboards.config.env;
    //POIS
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

    layerControl.addOverlay(sourcePois, "Puntos Interes");

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
    layerControl.addOverlay(groupLayer, "Datos");
    groupLayer.addTo(map);

    var htmlLegend = L.control.htmllegend({
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
      },{
        name: "ver name1",
        layer: source_layers ,
        elements: [{
          label: '',
          html: '',
          style: {
            'background-color': 'blue',
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
    map.addControl(htmlLegend)
    groupLayer.addTo(map);
    return;
  }

  return{
    init:init,
    counties: counties
  }
}();
