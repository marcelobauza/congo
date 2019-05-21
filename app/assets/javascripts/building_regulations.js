Congo.namespace('building_regulations.action_dashboards');

Congo.building_regulations.config= {
  county_name: '',
  county_id: '',
  layer_type: 'building_regulations_info'
}

Congo.building_regulations.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }
  return {
    init: init,
  }
}();
