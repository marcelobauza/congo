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

    // Crea el mapa
    map = L.map('map',{
      fadeAnimation: true,
      markerZoomAnimation: false,
      zoom: 11,
      center: [-33.4372, -70.6506],
      zoomControl: false,
      zoomAnimation: true,
      layers: [streets]
    });

    // Agrega el ícono de capas al mapa
    baseMaps = {
      "Calles": streets,
      "Satelital": satellite,
      "Claro": grayscale,
      "Oscuro": dark
    };
    var overlays =  {
    };
    layerControl = L.control.layers(baseMaps, overlays, {
      position: 'topleft',
      collapsed: true
    }).addTo(map);

    countiesEnabled();
    editableLayers = new L.FeatureGroup();

    // Agrega el toolbar de selección al mapa
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
    // Establece los nombres de las leyendas del toolbar
    L.drawLocal = {
      draw: {
        toolbar: {
          actions: {
            title: 'Cancel drawing',
            text: 'Cancelar'
          },
          finish: {
            title: 'Finish drawing',
            text: 'Finalizar'
          },
          undo: {
            title: 'Delete last point drawn',
            text: 'Eliminar el último punto'
          },
          buttons: {
            marker: 'Punto',
            polygon: 'Polígono',
            circle: 'Radio',
          }
        },
        handlers: {
          circle: {
            tooltip: {
              start: 'Haga click en el mapa y arrastre para dibujar un círculo.'
            },
            radius: 'Radio'
          },
          circlemarker: {
            tooltip: {
              start: 'Click map to place circle marker.'
            }
          },
          marker: {
            tooltip: {
              start: 'Haga click en el mapa para seleccionar la comuna.'
            }
          },
          polygon: {
            tooltip: {
              start: 'Haga click para comenzar a dibujar el polígono.',
              cont: 'Haga click para continuar dibujando el polígono.',
              end: 'Haga click en el primer punto para cerrar este polígono.'
            }
          },
          polyline: {
            error: '<strong>Error:</strong> los bordes del polígono no pueden cruzarse.',
            tooltip: {
              start: 'Click to start drawing line.',
              cont: 'Click to continue drawing line.',
              end: 'Click last point to finish line.'
            }
          },
          rectangle: {
            tooltip: {
              start: 'Click and drag to draw rectangle.'
            }
          },
          simpleshape: {
            tooltip: {
              end: 'Suelte el mouse para terminar de dibujar.'
            }
          }
        }
      },
      edit: {
        toolbar: {
          actions: {
            save: {
              title: 'Save changes',
              text: 'Guardar'
            },
            cancel: {
              title: 'Cancel editing, discards all changes',
              text: 'Cancelar'
            },
            clearAll: {
              title: 'Clear all layers',
              text: 'Limpiar todo'
            }
          },
          buttons: {
            edit: 'Editar',
            editDisabled: 'Nada para editar',
          }
        },
        handlers: {
          edit: {
            tooltip: {
              text: 'Drag handles or markers to edit features.',
              subtext: 'Click cancel to undo changes.'
            }
          }
        }
      }
    };
    map.addControl(drawControl);

    // Agrega el ícono de búsqueda al mapa
    map.addControl(new L.Control.Search({
      url: 'https://nominatim.openstreetmap.org/search?format=json&q={s}&countrycodes=cl',
      jsonpParam: 'json_callback',
      propertyName: 'display_name',
      markerLocation: true,
      propertyLoc: ['lat', 'lon'],
      marker: L.circleMarker([0, 0], {
        radius: 30
      }),
      autoCollapse: true,
      autoType: false,
      minLength: 2
    }));

    // Agrega la escala al mapa
    L.control.scale({
      imperial: false,
      position: 'bottomleft',
    }).addTo(map);

    // Agrega el ícono de zoom al mapa
    var zoomControl = L.control.zoom({
      zoomInTitle: 'Acercar',
      zoomOutTitle: 'Alejar',
      position: 'topleft'
    });
    map.addControl(zoomControl);

    // Agregamos el spinner de carga
    var loadingControl = L.Control.loading({
      position: 'topleft',
      zoomControl: zoomControl
    });
    map.addControl(loadingControl);

    map.on(L.Draw.Event.CREATED, function (event) {
      var typeGeometry = event.layerType;
      size_box = [];

      if(typeof(editableLayers)!=='undefined'){
        editableLayers.eachLayer(function (layer) {
          map.removeLayer(layer);
        });
      editableLayers = new L.FeatureGroup();
      }
      layer = event.layer;
      if (typeGeometry == 'polygon'){
        Congo.dashboards.config.county_id = [];
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

        Congo.dashboards.config.county_id = [];
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
      map.fitBounds(editableLayers.getBounds());
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

  var build_image_map = function(){
    leafletImage(map, function(err, canvas) {
      //      now you have canvas
      // example thing to do with that canvas:
      var img = document.createElement('img');
      var dimensions = map.getSize();
      img.width = dimensions.x;
      img.height = dimensions.y;
      img.src = canvas.toDataURL();
      console.log(img);
    });

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
    var env = Congo.dashboards.config.env;
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
        layerControl.removeLayer(groupLayer);
        layerControl.removeLayer(sourcePois);
        layerControl.removeLayer(sourceLots);
        groupLayer.removeLayer(layer);

      });
    }

    if (sourcePois !=undefined){
      map.removeLayer(sourcePois);
    }
    layer_type = Congo.dashboards.config.layer_type;
    switch(layer_type) {
      case 'demography_info':

        census_source_id = Congo.demography.config.census_source;
        filter_layer =  "census_source_id =" + census_source_id;
        Congo.demography.action_dashboards.indicator_demography();
        legends = Congo.demography.config.legends;
        remove_legend();
        legend_points(legends);
        break;
      case 'transactions_info':
      case 'transactions_heatmap_amount':
        year = Congo.dashboards.config.year;
        bimester = Congo.dashboards.config.bimester;
        Congo.transactions.action_dashboards.indicator_transactions();
        property_type_ids = Congo.transactions.config.property_type_ids
        seller_type_ids = Congo.transactions.config.seller_type_ids
        boost = Congo.dashboards.config.boost;
        widget =  Congo.dashboards.config.widget;
        legends = Congo.transactions.config.legends;

        if (widget == 'heat_cbr_amout'){
          layer_type = 'transactions_heatmap_amount';
        }

        if (boost == false){
          filter_layer = filter_layer +  " AND ( ";
          for(i=6; i > 0; i--){
              filter_layer = filter_layer + " (bimester='"+ bimester +"' AND year='"+ year+"')";
              bimester = bimester - 1;
              if (bimester == 0 ){
                    bimester = 6;
                    year = year - 1;
                    }
          if (i > 1){
          filter_layer = filter_layer +  " OR ";
          }

          }
          filter_layer = filter_layer +  " ) ";
        }
        if (property_type_ids.length > 0 ){
          filter_layer = filter_layer + " AND property_type_id IN ("+ property_type_ids + ")";
        }

        if (seller_type_ids.length > 0){
          filter_layer = filter_layer + " AND seller_type_id IN ("+ seller_type_ids + ")";
        }

        remove_legend();
        legend_points(legends);

        break;
      case 'future_projects_info':
        year = Congo.dashboards.config.year;
        bimester = Congo.dashboards.config.bimester;
        Congo.future_projects.action_dashboards.indicator_future_projects();
        filter_future_project_type_ids = Congo.future_projects.config.future_project_type_ids;
        filter_project_type_ids = Congo.future_projects.config.project_type_ids;
        boost = Congo.dashboards.config.boost;
        periods = Congo.future_projects.config.periods;
        years = Congo.future_projects.config.years;
        if (boost == false){
          filter_layer = filter_layer + "AND ((bimester='"+ bimester +"' AND year='"+ year+"')";
        if (periods.length > 0 ){
          $.each(periods, function(i,v){
            filter_layer = filter_layer + "OR (bimester='"+ v +"' AND year='"+ years[i]+"')";
          })
        }
            filter_layer = filter_layer +")";
        }
        if (filter_future_project_type_ids.length > 0) {
          filter_layer = filter_layer + " AND future_project_type_id IN (" + filter_future_project_type_ids +")";
        }
        if(filter_project_type_ids.length > 0){
          filter_layer = filter_layer + " AND project_type_id IN (" + filter_project_type_ids +")";
        }
        style_graduated = Congo.dashboards.config.style_layer;
        if (style_graduated == 'future_projects_normal_point'){
          $.ajax({
            async: false,
            type: 'GET',
            url: '/future_project_types/legend_points.json',
            datatype: 'json',
            data: {future_project_type_ids: future_project_type_ids },
            success: function(data){
              Congo.future_projects.config.legends = [];
              Congo.future_projects.config.legends = data;
            },
            error: function (jqXHR, textStatus, errorThrown) { console.log("algo malo paso"); }

          });
        }
        legends = Congo.future_projects.config.legends;
        remove_legend();
        legend_points(legends);

        break;
      case 'projects_feature_info':
        year = Congo.dashboards.config.year;
        bimester = Congo.dashboards.config.bimester;
        Congo.projects.action_dashboards.indicator_projects();
        from_floors = Congo.projects.config.from_floor;
        to_floors = Congo.projects.config.to_floor;
        project_status_ids = Congo.projects.config.project_status_ids;
        project_type_ids = Congo.projects.config.project_type_ids;
        agency_ids = Congo.projects.config.project_agency_ids;
        legends = Congo.projects.config.legends;
        filter_layer = filter_layer + "AND (bimester='"+ bimester +"' AND year='"+ year+"')";

        if(from_floors.length >0 && to_floors.length > 0 ){
          filter_layer = filter_layer + " AND floors >= " + from_floors + " and floors <= " + to_floors ;
        }

        if (project_status_ids.length > 0){
          filter_layer = filter_layer + " AND project_status_id IN (" + project_status_ids + ")";
        }

        if (project_type_ids.length > 0){
          filter_layer = filter_layer + " AND project_type_id IN (" + project_type_ids + ")";
        }
        if (agency_ids.length > 0){
          filter_layer = filter_layer + " AND agency_id IN (" + agency_ids + ")";
        }


        widget =  Congo.dashboards.config.widget;
        switch (widget) {
          case 'prv_sold_units':
          case 'prv_uf_avg_percent':
          case 'prv_uf_m2_u':
            layer_type = 'project_instance_mix_views'
            break;
        }

        remove_legend();
        legend_points(legends);
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
        legends = Congo.building_regulations.config.legends;
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
          filter_layer = filter_layer + "AND aminciti between " + from_max_height + " AND "+ to_max_height ;
        }

        if ((from_inh_hectare !='' || typeof(from_inh_hectare)=== 'undefined')  && (to_inh_hectare != '' || typeof(to_inh_hectarea)==='undefined') ){
          filter_layer = filter_layer + "AND max_density between " + from_inh_hectare + " AND "+ to_inh_hectare ;
        }

        remove_legend();
        legend_points(legends);

        break;
    }

    var coord_geoserver = [];
    var polygon_size;
    typeGeometry = Congo.dashboards.config.typeGeometry;
    switch(typeGeometry) {
      case 'circle':
        centerpt = Congo.dashboards.config.centerpt;
        radius = Congo.dashboards.config.radius ;

        if (layer_type == 'demography_info'){
          Congo.dashboards.config.style_layer = 'census_voronoi_clip';
          geometry = centerpt.split(' ');
          var center = [geometry[0],geometry[1]];
          var radius = radius;
          var options = {steps: 50, units: 'meters', properties: {foo: 'bar'}};
          var circle = turf.circle(center, radius, options);
          var pol = circle['geometry']['coordinates'];
          $.each(pol, function(a, b){
            $.each(b, function(c,d){
              coord_geoserver = coord_geoserver.concat(d[0]+" "+ d[1]);
            })
          });
          env = "polygon: Polygon(("+coord_geoserver+"))";
          cql_filter = "1=1" ;
          if (census_source_id == '1'){
            layer_type = 'demography_info_census_2017'
          }else{

            layer_type = 'demography_info_census_2012'
          }
        }else{

          if (layer_type == 'building_regulations_info'){

          widget =  Congo.dashboards.config.widget;
          switch (widget) {
            case 'building_regulations_max_density':
                Congo.dashboards.config.style_layer= 'building_regulations_max_density_clip';
            break;
            case 'building_regulations_floors':
              Congo.dashboards.config.style_layer = 'building_regulations_floors_clip';
            break;
            default:
                Congo.dashboards.config.style_layer= 'building_regulations_max_density_clip';
            break;
            }
            geometry = centerpt.split(' ');
            var center = [geometry[0],geometry[1]];
            var radius = radius;
            var options = {steps: 50, units: 'meters', properties: {foo: 'bar'}};
            var circle = turf.circle(center, radius, options);
            var pol = circle['geometry']['coordinates'];
            $.each(pol, function(a, b){
              $.each(b, function(c,d){
                coord_geoserver = coord_geoserver.concat(d[0]+" "+ d[1]);
              })
            });

            cql_filter = "1 =1";
            env = "polygon: Polygon(("+coord_geoserver+"))";
          }


          cql_filter ="DWITHIN(the_geom,Point("+centerpt+"),"+radius+",meters)"+ filter_layer;
          cql_filter_pois ="DWITHIN(the_geom,Point("+centerpt+"),"+radius+",meters)";
        }
        break;
      case 'polygon':
        polygon_size = Congo.dashboards.config.size_box;
        $.each(polygon_size[0], function(a, b){
          $.each(b, function(c,d){
            coord_geoserver = coord_geoserver.concat(d[0]+" "+ d[1]);
          })
        });

        if (layer_type == 'building_regulations_info'){
          cql_filter = "1=1";
          filter_layer = ''

          widget =  Congo.dashboards.config.widget;
          switch (widget) {
            case 'building_regulations_max_density':
                Congo.dashboards.config.style_layer= 'building_regulations_max_density_clip';
            break;
            case 'building_regulations_floors':
              Congo.dashboards.config.style_layer = 'building_regulations_floors_clip';
            break;
            default:
                Congo.dashboards.config.style_layer= 'building_regulations_max_density_clip';
            break;

            }
          env = "polygon: Polygon(("+coord_geoserver+"))";
        }else{
          if (layer_type == 'demography_info'){
            cql_filter = "1=1";
            filter_layer = ''
            Congo.dashboards.config.style_layer = 'census_voronoi_clip';
          if (census_source_id == '1'){
            layer_type = 'demography_info_census_2017'
          }else{
            layer_type = 'demography_info_census_2012'
          }

            env = "polygon: Polygon(("+coord_geoserver+"))";
          }else{
            cql_filter ="WITHIN(the_geom,  Polygon(("+coord_geoserver+"))) "+ filter_layer;
          }}

        cql_filter_pois ="WITHIN(the_geom, Polygon(("+coord_geoserver+"))) ";
        break;
      case 'marker':
        county_id = Congo.dashboards.config.county_id;

        if (layer_type == 'demography_info'){
          filter_layer  = " AND 1=1";
          if (census_source_id == '1'){
            layer_type = 'demography_info_census_2017'
          }else{

            layer_type = 'demography_info_census_2012'
          }
          Congo.dashboards.config.style_layer = 'census_voronoi_gse_zn';
        }
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
        if (layer_type == 'demography_info'){
          filter_layer  = " AND 1=1";
          if (census_source_id == '1'){
            layer_type = 'demography_info_census_2017'
          }else{

            layer_type = 'demography_info_census_2012'
          }
          Congo.dashboards.config.style_layer = 'census_voronoi_gse_zn';
        }
        cql_filter = "county_id IN ("+ county_id +") "+ filter_layer;
        cql_filter_pois = "county_id IN ("+ county_id + ")";
        break;
    }
    groupLayer = L.layerGroup();
    style_layer = Congo.dashboards.config.style_layer;
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

    layerControl.addOverlay(sourcePois, "Puntos de Interés");

    //Lots
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
    layerControl.addOverlay(sourceLots, "Plancheta Predial");

    if(county_id != ''){
      search_county(county_id);
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

  function remove_legend(){
    if(typeof(htmlLegend)!=='undefined'){
      map.removeControl(htmlLegend);
    }
  }

  function legend_points(params){
    var options = [];
    $.each(params, function(a,value){
      color = value['color']
      color = color.replace('#','');
      options.push({
        name: value['name'],
        elements: [{
          html: '',
          style: {
            'background-color': '#'+color,
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

  function draw_geometry(type_geometry){

      if(typeof(editableLayers)!=='undefined'){
        editableLayers.eachLayer(function (layer) {
          map.removeLayer(layer);
        });
      editableLayers = new L.FeatureGroup();
      }
    switch(type_geometry) {
      case 'circle':
        centerpt = Congo.dashboards.config.centerpt;
        radius = Congo.dashboards.config.radius ;
        geometry = centerpt.split(' ');
        circle = L.circle([geometry[1], geometry[0]], radius * 1 );
        editableLayers.addLayer(circle).addTo(map);
        map.fitBounds(editableLayers.getBounds());
      break;
      case 'polygon':
        size_box = Congo.dashboards.config.size_box;
        polygon = []
        $.each(size_box[0], function(idx,arr){
          point = []
          $.each(arr, function(i, coord){
          point.push([coord[1], coord[0]]);
          })
          polygon.push(point);
        })
        polygon = L.polygon(polygon, {color: '#2ECCFA'}).addTo(map);
        editableLayers.addLayer(polygon).addTo(map);
        map.fitBounds(editableLayers.getBounds());
      break;
  }
  }

  function search_county(county_id){

      var owsrootUrl = "http://"+url+":8080/geoserver/ows";
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

  function countiesEnabled(){
    var va = document.querySelector('#downloads');
    Congo.dashboards.config.user_id= va.dataset.uid
    user_id = Congo.dashboards.config.user_id;
      var owsrootUrl = "http://"+url+":8080/geoserver/ows";
      var defaultParameters = {
        service: 'WFS',
        version: '1.0.0',
        request: 'GetFeature',
        typeName: 'inciti_v2:counties_enabled_by_users',
        outputFormat: 'application/json',
        CQL_FILTER: "user_id IN("+ user_id + ")"
      }

    var geojsonMarkerOptions = {
          radius: 8,
          fillColor: "#ff7800",
          color: "#000",
          weight: 1,
          opacity: 0.4,
          fillOpacity: 0.4
    };


    var parameters = L.Util.extend(defaultParameters);
      var URL = owsrootUrl + L.Util.getParamString(parameters);
      $.ajax({
        url: URL,
        success: function (data) {
          var geojson = new L.geoJson(data, {
                pointToLayer: function (feature, latlng) {
                          return L.circleMarker(latlng, geojsonMarkerOptions);
                      }
          }).addTo(map);
          map.fitBounds(geojson.getBounds());
          map.addLayer(geojson);
        }
      });
  }

  return{
    init:init,
    counties: counties,
    legend_points: legend_points,
    draw_geometry: draw_geometry
  }
}();
