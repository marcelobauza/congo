// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require leaflet/leaflet-search
//= require leaflet/spin
//= require leaflet/leaflet-spin
//= require leaflet/leaflet-image
//= require html2canvas.min.js
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require rails-ujs
//= require activestorage
//= require congo
//= require legend
//= require lots
//= require pois
//= require map_utils
//= require flex/maps
//= require flex/dashboards
//= require_tree .

$.fn.datepicker.defaults.format = "yyyy/mm/dd";
$(document).ready(function(){
  $('.datepicker').datepicker();
});
