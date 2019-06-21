Congo.namespace('dashboards.action_index');
Congo.namespace('dashboards.action_graduated_points');

Congo.dashboards.config= {
  county_name: '',
  county_id: '',
  layer_type: 'future_projects_info',
  style_layer: 'future_projects_normal_point',
  bimester: '',
  year: '',
  env: '',
  kind_reports: ''
}

Congo.dashboards.action_index = function(){
  init= function(){
    Congo.map_utils.init();
  }

  // Creamos el overlay
  create_overlay = function(){
    if ($('.overlay').length == 0) {
      $('#map').before(
        $('<div>', {
            'class': 'overlay'
        })
      );
    };
  };

  return {
    init: init,
    create_overlay: create_overlay
  }
}();

Congo.dashboards.action_graduated_points = function(){
  init=function(){
  }
return{
  init: init
}
}();
