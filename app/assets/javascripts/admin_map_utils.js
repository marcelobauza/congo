Congo.namespace("admin_map_utils");

Congo.admin_map_utils = function(){

  var init = function(){
    url = window.location.hostname;

    var streets = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      updateWhenIdle: false,
      reuseTiles: true
    });

    map = L.map('admin_map',{
      fadeAnimation: false,
      markerZoomAnimation: false,
      zoom: 11,
      center: [-33.4372, -70.6506],
      zoomControl: true,
      zoomAnimation: false,
      layers: [streets],
      loadingControl: true,
    }) ;
  }

  return{
    init:init,
  }
}();
