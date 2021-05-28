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
          arr1 = Congo.map_utils.LatLngsToCoords(entry)
          arr1.push(arr1[0])
          size_box = [arr1];
        })
      }
      data = {polygon: JSON.stringify(size_box)}

      $.ajax({
        async: false,
        type: 'get',
        url: 'flex/dashboards/search_data_for_filters.json',
        datatype: 'json',
        data: data,
        success: function(data){

        },
        error: function (jqxhr, textstatus, errorthrown) { console.log("algo malo paso"); }
      })
    })
  }
  return{
    init:init,
  }
}();
