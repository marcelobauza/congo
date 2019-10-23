Congo.namespace("admin_map_utils");

Congo.admin_map_utils = function(){
  var map_admin, marker;
  var init = function(){
    url = window.location.hostname;

    var streets = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      updateWhenIdle: false,
      reuseTiles: true
    });

    map_admin = L.map('admin_map',{
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
  var addMarker = function(latitude, longitude, current_layer){
    var marker = L.marker([latitude, longitude],{draggable: 'true'} ).addTo(map_admin);
    map_admin.setView([latitude, longitude], 15);
    marker.on('dragend', function(event) {
      var position = marker.getLatLng();
      $("#"+current_layer +"_latitude").val(position.lat);
      $("#"+current_layer+"_longitude").val(position.lng);
    });
  } 

  var geocoding =function(address){
    geocoder = new L.Control.Geocoder.Nominatim();
    geocoder.geocode(address, function(results) { 
      if (results.length > 0 ){

        if(marker !== undefined){
          map_admin.removeLayer(marker);
        } 
        $('#projects_latitude').val(results[0].center.lat);
        $('#projects_longitude').val(results[0].center.lng);
        latLng= new L.LatLng(results[0].center.lat, results[0].center.lng);
        marker = new L.Marker(latLng, {draggable: 'true'}).addTo(map_admin);
        map_admin.setView(latLng, 15);
      }else{
        $('#geocodingResult').replaceWith('<div>No se encontraron registros</div>');

      }
    });
  }

  return{
    init:init,
    addMarker:addMarker,
    geocoding:geocoding,
  }
}();
