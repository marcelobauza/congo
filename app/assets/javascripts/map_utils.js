Congo.namespace('map_utils');

Congo.map_utils = function(){

  var init = function(){
var streets = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        updateWhenIdle: true,
        reuseTiles: true
      });

   var map = L.map('map',{
            zoom: 12,
            center: [-33.113399134183744, -69.69339599609376],
            zoomControl: false,
            layers: [streets]
          }) ;

}
return{
  init:init
}
}();
