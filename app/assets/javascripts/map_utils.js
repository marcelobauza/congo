Congo.namespace('map_utils');

Congo.map_utils.config={
  cql_filter: '',
}

Congo.map_utils = function(){
  var url, map, groupLayer, editableLayers, HandlerGeometry, typeGeometry , layerControl, sourcePois, overlays, htmlLegend;
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

    var satellite = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
      attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
    });

    var dark = L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
      subdomains: 'abcd',
      maxZoom: 19
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
      url: 'https://nominatim.openstreetmap.org/search?format=json&q={s}&countrycodes=cl',
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
      "Satelital": satellite,
      "Night": dark
    };
    var overlays =  {
    };
    layerControl = L.control.layers(baseMaps, overlays, {position: 'topleft'}).addTo(map);


    editableLayers = new L.FeatureGroup();
    var drawControl = new L.Control.Draw({
      draw:{
        polyline: false, 
        rectangle: false,
        circlemarker: false,
      },
      edit: {
        featureGroup: editableLayers,
        edit: true,
        remove: false,
        marker: false
      }
    });
    map.addControl(drawControl);
    map.on(L.Draw.Event.CREATED, function (event) {
      var typeGeometry = event.layerType;
      size_box = [];

      if(typeof(editableLayers)!=='undefined'){
        editableLayers.eachLayer(function (layer) {
          map.removeLayer(layer);
        });
      }

      layer = event.layer;
      if (typeGeometry == 'polygon'){ 
        Congo.dashboards.config.county_id = '';
        Congo.dashboards.config.size_box = [];
        Congo.dashboards.config.centerpt = '';
        Congo.dashboards.config.radius = '';
        map.doubleClickZoom.disable();
        Congo.dashboards.config.typeGeometry = typeGeometry;
        var arr1 = []

        polygon = layer.getLatLngs();
        arr1 = LatLngsToCoords(polygon[0]);
        arr1.push(arr1[0])
        size_box.push(arr1);

        let area = L.GeometryUtil.geodesicArea(layer.getLatLngs()[0]);
        Congo.dashboards.config.area = area;
        Congo.dashboards.config.size_box.push(size_box)
      }

      if (typeGeometry == 'circle'){

        Congo.dashboards.config.county_id = '';
        Congo.dashboards.config.size_box = [];
        var centerpt = layer.getLatLng();
        var radius = layer.getRadius();
        Congo.dashboards.config.radius = (radius);
        center = centerpt.lng +" " + centerpt.lat;
        Congo.dashboards.config.typeGeometry = typeGeometry;
        Congo.dashboards.config.centerpt = center;
      }

      if (typeGeometry == 'marker'){

        Congo.dashboards.config.centerpt = '';
        Congo.dashboards.config.radius = '';
        Congo.dashboards.config.county_id = [];
        Congo.dashboards.config.size_box = [];

        centerpt = layer.getLatLng();
        center = centerpt.lng +" " + centerpt.lat;
        Congo.dashboards.config.typeGeometry = typeGeometry;
        Congo.dashboards.config.centerpt = center;

        $.ajax({
          async: false,
          type: 'get',
          url: '/dashboards/filter_county_for_lon_lat.json',
          datatype: 'json',
          data: {lon: centerpt.lng, lat: centerpt.lat },
          success: function(data){
            Congo.dashboards.config.county_id.push([data['county_id']]);
            Congo.dashboards.config.county_name = data['county_name'];
          },
          error: function (jqxhr, textstatus, errorthrown) { console.log("algo malo paso"); }
        })
      }
      editableLayers.addLayer(layer).addTo(map);
      counties();
    });

    map.on(L.Draw.Event.EDITED, function (event) { 

      layer = event.layers;
      if (typeGeometry == 'polygon'){
        size_box = [];
        arr1 = []
        Congo.dashboards.config.size_box=[];

        layer.eachLayer(function (layer) {
          polygon = layer.getLatLngs();
        });
        arr1 = LatLngsToCoords(polygon[0]);
        arr1.push(arr1[0])
        size_box.push(arr1);
        let area = L.GeometryUtil.geodesicArea(polygon[0]);
        Congo.dashboards.config.area = area;
        Congo.dashboards.config.size_box.push(size_box)
      }
      if (typeGeometry == 'circle'){
        layer.eachLayer(function (layer) {
          centerpt = layer.getLatLng();
          radius = layer.getRadius();
        });
        Congo.dashboards.config.radius = (radius);
        center = centerpt.lng +" " + centerpt.lat;
      }
      counties();

    })
  }

  var LatLngToCoords = function (LatLng, reverse) { // (LatLng, Boolean) -> Array
    coord =[]
    var lat = parseFloat(LatLng.lat),
      lng = parseFloat(LatLng.lng);
    //coord = lat +" "+ lng;
    coord.push(lng);
    coord.push(lat);
    return coord;
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

  function BoundingBox(){
    var bounds = map.getBounds().getSouthWest().lng + "," + map.getBounds().getSouthWest().lat + "," + map.getBounds().getNorthEast().lng + "," + map.getBounds().getNorthEast().lat;
    return bounds;
  }

  counties = function(){

    var bimester, year, filter_for_layer;
    var filter_layer = "AND 1 = 1 ";

    $.ajax({
      async: false,
      type: 'GET',
      url: '/counties/counties_users.json',
      datatype: 'json',
      success: function(data){
        if (data.length > 0 ){
          filter_layer = "AND county_id IN(" +data +")";
        }
      },
      error: function (jqXHR, textStatus, errorThrown) { console.log("algo malo paso"); }
    })

    if (typeof HandlerGeometry != 'undefined'){
      HandlerGeometry.disable();
    }

    if (groupLayer !=undefined){
      groupLayer.eachLayer(function(layer) {
        groupLayer.removeLayer(layer);
      });
    }

    if (sourcePois !=undefined){
      map.removeLayer(sourcePois);
    }
    map.removeControl(layerControl);
    layerControl = L.control.layers(baseMaps, overlays, {position: 'topleft'}).addTo(map);
    layer_type = Congo.dashboards.config.layer_type;
    switch(layer_type) {
      case 'census_voronoi':
        filter_layer = filter_layer +  "AND 1=1";
        break;
      case 'transactions_info':
        year = Congo.dashboards.config.year;
        bimester = Congo.dashboards.config.bimester;
        Congo.transactions.action_dashboards.indicator_transactions();
        property_type_ids = Congo.transactions.config.property_type_ids
        seller_type_ids = Congo.transactions.config.seller_type_ids
        boost = Congo.dashboards.config.boost;

        if (boost == false){
          filter_layer = filter_layer + "AND (bimester='"+ bimester +"' AND year='"+ year+"')";
        }
        if (property_type_ids.length > 0 ){
          filter_layer = filter_layer + " AND property_type_id IN ("+ property_type_ids + ")";
        }

        if (seller_type_ids.length > 0){
          filter_layer = filter_layer + " AND seller_type_id IN ("+ seller_type_ids + ")";
        }

        remove_legend();

        break;
      case 'future_projects_info':
        year = Congo.dashboards.config.year;
        bimester = Congo.dashboards.config.bimester;
        Congo.future_projects.action_dashboards.indicator_future_projects();
        filter_future_project_type_ids = Congo.future_projects.config.future_project_type_ids;
        filter_project_type_ids = Congo.future_projects.config.project_type_ids;
        boost = Congo.dashboards.config.boost;
        if (boost == false){
          filter_layer = filter_layer + "AND (bimester='"+ bimester +"' AND year='"+ year+"')";
        }        
        if (filter_future_project_type_ids.length > 0) {
          filter_layer = filter_layer + " AND future_project_type_id IN (" + filter_future_project_type_ids +")";
        }
        if(filter_project_type_ids.length > 0){
          filter_layer = filter_layer + " AND project_type_id IN (" + filter_project_type_ids +")";
        }

        $.ajax({
          async: false,
          type: 'GET',
          url: '/future_project_types/legend_points.json',
          datatype: 'json',
          data: {future_project_type_ids: filter_future_project_type_ids },
          success: function(data){
            legend = data;
          },
          error: function (jqXHR, textStatus, errorThrown) { console.log("algo malo paso"); }

        })

        remove_legend();
        legend_points(legend);

        break;
      case 'projects_feature_info':
        year = Congo.dashboards.config.year;
        bimester = Congo.dashboards.config.bimester;
        Congo.projects.action_dashboards.indicator_projects();

        project_status_ids = Congo.projects.config.project_status_ids; 
        project_type_ids = Congo.projects.config.project_type_ids;
        agency_ids = Congo.projects.config.project_agency_ids;
        filter_layer = filter_layer + "AND (bimester='"+ bimester +"' AND year='"+ year+"')";
        if (project_status_ids.length > 0){
          filter_layer = filter_layer + " AND project_status_id IN (" + project_status_ids + ")";
        } 

        if (project_type_ids.length > 0){
          filter_layer = filter_layer + " AND project_type_id IN (" + project_type_ids + ")";
        }
        if (agency_ids.length > 0){
          filter_layer = filter_layer + " AND agency_id IN (" + agency_ids + ")";
        }
        remove_legend();
        break;
      case 'building_regulations_info':
        Congo.building_regulations.action_dashboards.indicator_building_regulations();
        from_construct = Congo.building_regulations.config.from_construct;
        to_construct = Congo.building_regulations.config.to_construct;
        from_land_ocupation =   Congo.building_regulations.config.from_land_ocupation;
        to_land_ocupation =   Congo.building_regulations.config.to_land_ocupation;
        from_max_height = Congo.building_regulations.config.from_max_height;
        to_max_height = Congo.building_regulations.config.to_max_height;
        from_inh_hectare = Congo.building_regulations.config.from_inhabitants_hectare;
        to_inh_hectare = Congo.building_regulations.config.to_inhabitants_hectare;
        allowed_use_ids = Congo.building_regulations.config.allowed_use_ids;

        filter_layer = '';
        if (allowed_use_ids.length > 0 ){
          filter_layer = filter_layer + " AND land_use_type_id IN ("+ allowed_use_ids + ")";
        }


        if (from_construct != '' && to_construct != '' ){
          filter_layer = filter_layer + "AND construct between " + from_construct + " AND "+ to_construct ;
        }
        if (from_land_ocupation != '' && to_land_ocupation != ''){
          filter_layer = filter_layer + "AND land_ocupation between " + from_land_ocupation + " AND "+ to_land_ocupation ;
        }

        if (from_max_height !='' && to_max_height != ''){
          filter_layer = filter_layer + "AND am_cc between " + from_max_height + " AND "+ to_max_height ;
        }

        if ((from_inh_hectare !='' || typeof(from_inh_hectare)=== 'undefined')  && (to_inh_hectare != '' || typeof(to_inh_hectarea)==='undefined') ){
          filter_layer = filter_layer + "AND max_density between " + from_inh_hectare + " AND "+ to_inh_hectare ;
        }

        remove_legend();
        break;
    }

    var coord_geoserver = [];
    var polygon_size;
    typeGeometry = Congo.dashboards.config.typeGeometry;
    switch(typeGeometry) {
      case 'circle':
        centerpt = Congo.dashboards.config.centerpt;
        radius = Congo.dashboards.config.radius ;

        cql_filter ="DWITHIN(the_geom,Point("+centerpt+"),"+radius+",meters)"+ filter_layer;
        cql_filter_pois ="DWITHIN(the_geom,Point("+centerpt+"),"+radius+",meters)";
        break;
      case 'polygon':
        polygon_size = Congo.dashboards.config.size_box;
        $.each(polygon_size[0], function(a, b){
          $.each(b, function(c,d){
            coord_geoserver = coord_geoserver.concat(d[0]+" "+ d[1]);
          })
        });

        cql_filter ="WITHIN(the_geom,  Polygon(("+coord_geoserver+"))) "+ filter_layer;
        cql_filter_pois ="WITHIN(the_geom, Polygon(("+coord_geoserver+"))) ";
        break;
      case 'marker':
        county_id = Congo.dashboards.config.county_id;
        cql_filter = "county_id='"+ county_id + "'"+   filter_layer;
        cql_filter_pois = "county_id='"+ county_id + "'";
        break;
      default:
        if(typeof(editableLayers)!=='undefined'){
          editableLayers.eachLayer(function (layer) {
            map.removeLayer(layer);
          });
        }
        Congo.dashboards.config.centerpt = '';
        Congo.dashboards.config.radius = 0;
        Congo.dashboards.config.size_box = [];
        county_id = Congo.dashboards.config.county_id;
        console.log(county_id);
        cql_filter = "county_id IN ("+ county_id +") "+ filter_layer;
        cql_filter_pois = "county_id IN ("+ county_id + ")";
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

    layerControl.addOverlay(sourcePois, "Equipamientos y Servicios");

    //Lots
    var options_lots = {
      layers: "inciti_v2:lots",//nombre de la capa (ver get capabilities)
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
    layerControl.addOverlay(sourceLots, "Predial");

    if(county_id != ''){
      var owsrootUrl = 'http://localhost:8080/geoserver/ows';
      var defaultParameters = {
        service: 'WFS',
        version: '1.0.0',
        request: 'GetFeature',
        typeName: 'inciti_v2:counties_info',
        outputFormat: 'application/json',
        CQL_FILTER: "county_id IN("+ county_id + ")"
      }
      var parameters = L.Util.extend(defaultParameters);
      var URL = owsrootUrl + L.Util.getParamString(parameters);
      $.ajax({
        url: URL,
        success: function (data) {
          var geojson = new L.geoJson(data, {
            style: {"color":"#2ECCFA","weight":2, "fillOpacity": 0},
            zIndex:1
          }
          );

          map.fitBounds(geojson.getBounds());
          groupLayer.addLayer(geojson);

          ;
        }
      });

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
      CQL_FILTER: cql_filter,
      clickable: 'false',
      zIndex: 99};
    source_layers = new L.tileLayer.betterWms("http://"+url+":8080/geoserver/wms", options_layers);

    groupLayer.addLayer(source_layers);
    layerControl.addOverlay(groupLayer, "Datos");
    groupLayer.addTo(map);
    return;
    }
  //}
  function remove_legend(){
    if(typeof(htmlLegend)!=='undefined'){
      map.removeControl(htmlLegend);
    }
  }


  function legend_points(params){
    var options = [];
    $.each(params, function(a,value){
      options.push({
        name: value['name'],
        elements: [{
          html: '',
          style: {
            'background-color': value['color'],
            'width': '10px',
            'height': '10px'
          }
        }]
      }
      )
    })
    htmlLegend = L.control.htmllegend({
      position: 'bottomleft',
      legends: options,
      collapseSimple: true,
      detectStretched: true,
      collapsedOnInit: true,
      defaultOpacity: 1,
      visibleIcon: 'icon icon-eye',
      hiddenIcon: 'icon icon-eye-slash'
    })

    map.addControl(htmlLegend)
  }

  return{
    init:init,
    counties: counties,
    legend_points: legend_points
  }
}();
