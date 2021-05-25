Congo.namespace('flex_dashboards.action_index');

Congo.flex_dashboards.action_index = function(){
  var map_admin, marker, flexMap;

  var init = function() {
    var streets = L.tileLayer('https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
      attribution: '',
      id: 'streets-v11',
      accessToken: 'pk.eyJ1IjoiZmxhdmlhYXJpYXMiLCJhIjoiY2ppY2NzMm55MTN6OTNsczZrcGFkNHpoOSJ9.cL-mifEoJa6szBQUGnLmrA',
      updateWhenIdle: true,
      reuseTiles: true
    });

  flexMap = L.map('map_flex', {
      fadeAnimation: true,
      markerZoomAnimation: false,
      zoom: 11,
      center: [-33.4372, -70.6506],
      zoomControl: false,
      zoomAnimation: true,
      layers: [streets]
    });

    fgr = L.featureGroup().addTo(flexMap);

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

    flexMap.on('draw:created', function(e) {
      size_box         = [];
      fgr.eachLayer(function(layer){
        fgr.removeLayer(layer);
      });

      fgr.addLayer(e.layer);
      layerType = e.layerType;

      if (layerType == 'polygon'){
        polygon = e.layer.getLatLngs();
        arr1    = []

        polygon.forEach(function(entry){
          size_box = Congo.map_utils.LatLngsToCoords(entry);
        })
      }

      // $.ajax({
      //   async: false,
      //   type: 'get',
      //   url: '/dashboards/filter_county_for_lon_lat.json',
      //   datatype: 'json',
      //   data: {lon: centerpt.lng, lat: centerpt.lat },
      //   success: function(data){
      //     Congo.dashboards.config.county_id.push([data['county_id']]);
      //     Congo.dashboards.config.county_name = data['county_name'];
      //   },
      //   error: function (jqxhr, textstatus, errorthrown) { console.log("algo malo paso"); }
      // })
    })
  }
  return{
    init:init,
  }
}();
