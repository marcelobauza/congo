Congo.namespace('flex_dashboards.action_index');

Congo.flex_dashboards.action_index = function(){
  var map_admin, marker;

  var init = function(){
    console.log("llega");
    var streets = L.tileLayer('https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
      attribution: '',
      id: 'streets-v11',
      accessToken: 'pk.eyJ1IjoiZmxhdmlhYXJpYXMiLCJhIjoiY2ppY2NzMm55MTN6OTNsczZrcGFkNHpoOSJ9.cL-mifEoJa6szBQUGnLmrA',
      updateWhenIdle: true,
      reuseTiles: true
    });

    L.map('map_flex',{
      fadeAnimation: true,
      markerZoomAnimation: false,
      zoom: 11,
      center: [-33.4372, -70.6506],
      zoomControl: false,
      zoomAnimation: true,
      layers: [streets]
    });
  }

  return{
    init:init,
  }
}();
