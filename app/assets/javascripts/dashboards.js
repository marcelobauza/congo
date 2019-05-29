Congo.namespace('dashboards.action_index');
Congo.namespace('dashboards.action_graduated_points');

Congo.dashboards.config= {
  county_name: '',
  county_id: '',
  layer_type: 'transactions_info',
  style_layer: 'poi_new',
  bimester: '',
  year: '',
  env: ''
}

Congo.dashboards.action_index = function(){
  init= function(){
    Congo.map_utils.init();  
  }
  return {
    init: init,
  }
}();

Congo.dashboards.action_graduated_points = function(){
  init=function(){
    console.log("psss");
        console.log(Congo.dashboard.layer_type);
  }
return{
  init: init
}
}();
