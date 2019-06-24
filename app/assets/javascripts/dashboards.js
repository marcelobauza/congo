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
  kind_reports: '',
  radius: 0,
  centerpt: '',
  size_box: '',
  typeGeometry: '',
}

Congo.dashboards.action_index = function(){
  init= function(){
        $.ajax({
          async: false,
          type: 'GET',
          url: '/dashboards/filter_period.json',
          datatype: 'json',
          success: function(data){
            Congo.dashboards.config.year = data['year'];
            Congo.dashboards.config.bimester = data['bimester'];
          }
        });
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

    // Aplicamos drag and drop
    dragula({
      containers: Array.prototype.slice.call($('.overlay'))
    });
  };

  empty_selection_alert = function() {
    var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert"> Por favor, realice la selección de los datos para deplegar la información de la capa. <button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
    $('#alerts').append(alert);
  }

  return {
    init: init,
    create_overlay: create_overlay,
    empty_selection_alert: empty_selection_alert
  }
}();

Congo.dashboards.action_graduated_points = function(){
  init=function(){
  }
return{
  init: init
}
}();
