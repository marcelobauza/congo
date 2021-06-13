function create_map(){
  let streets = L.tileLayer('https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    attribution: '',
    id: 'streets-v11',
    accessToken: 'pk.eyJ1IjoiZmxhdmlhYXJpYXMiLCJhIjoiY2ppY2NzMm55MTN6OTNsczZrcGFkNHpoOSJ9.cL-mifEoJa6szBQUGnLmrA',
    updateWhenIdle: true,
    reuseTiles: true
  });

  let flexMap = L.map('map_flex', {
    fadeAnimation: true,
    markerZoomAnimation: false,
    zoom: 11,
    center: [-33.4372, -70.6506],
    zoomControl: false,
    zoomAnimation: true,
    layers: [streets]
  });

  return flexMap;
}

function add_control(flexMap, fgr){
  var drawControl = new L.Control.Draw({
    draw: {
      marker: false,
      polyline: false,
      rectangle: false,
      circlemarker: false,
    },
    edit: {
      featureGroup: fgr
    }
  }).addTo(flexMap);

}

function draw_geometry(e, fgr){
  size_box = [];
  fgr.eachLayer(function (layer) {
    fgr.removeLayer(layer);
  });

  fgr.addLayer(e.layer);

  layerType = e.layerType;

  if (layerType == 'polygon') {
    polygon = e.layer.getLatLngs();
    arr1    = []

    polygon.forEach(function (entry) {
      arr1 = Congo.map_utils.LatLngsToCoords(entry)
      arr1.push(arr1[0])
      size_box = [arr1];
    })

    let area = L.GeometryUtil.geodesicArea(e.layer.getLatLngs()[0]);

    if (area > '500000'){
      let error = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El área debe ser menor a 50000 m2.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'

      data = {error: error }
    }else{
      data = {polygon: JSON.stringify(size_box), geometryType: layerType}
    }
  } else if (layerType == 'circle') {
    let centerpt = e.layer.getLatLng();
    let radius   = e.layer.getRadius();
    let center   = centerpt.lng +" " + centerpt.lat;

    if (radius > '50000') {
      let error = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El área debe ser menor a 500 m.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'

      data = { error: error }
    }else{
      data = { radius: radius , point: center, geometryType: layerType}
    }
  }

  return data;
}

function geoserver_data(data, flexMap, fgr){
  geometryType = data['geometryType'];
  url          = window.location.hostname;

  if (geometryType == 'circle'){
    let center  = data['point'];
    let radius  = data['radius'];

    cql_filter ="DWITHIN(the_geom,Point("+center+"),"+radius+",meters)";
  }else if (geometryType == 'polygon') {
    let polygon         = JSON.parse(data['polygon']);
    let coord_geoserver = [];

    $.each(polygon, function(a, b){
      $.each(b, function(c,d){
        coord_geoserver = coord_geoserver.concat(d[0]+" "+ d[1]);
      })
    });

    cql_filter ="WITHIN(the_geom, Polygon(("+coord_geoserver+"))) ";
  }

  var options_layers = {
    layers: "inciti_v2:transactions_info",//nombre de la capa (ver get capabilities)
    format: 'image/png',
    transparent: 'true',
    opacity: 1,
    version: '1.0.0',//wms version (ver get capabilities)
    tiled: true,
    styles: 'poi_new',
    INFO_FORMAT: 'application/json',
    format_options: 'callback:getJson',
    CQL_FILTER: cql_filter,
    clickable: 'false',
    zIndex: 99};

  source_layers = new L.tileLayer.betterWms("http://"+url+":8080/geoserver/wms", options_layers);

  fgr.addLayer(source_layers);
  fgr.addTo(flexMap);
  return;
}

