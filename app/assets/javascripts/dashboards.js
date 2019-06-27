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
  size_box: [],
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
  create_overlay_and_filter_card = function() {

    if ($('.overlay').length == 0) {

      $('#map').before(
        $('<div>', { // overlay
          'class': 'overlay'
        }).append(
          $('<div>', { // card
            'class': 'card',
            'id': 'filter-container'
          }).append(
            $('<div>', { // card-header
              'class': 'card-header',
              'id': 'filter-header'
            }).append(
              $('<b>', { // título
                'text': 'Filtros'
              }),
              $('<button>', { // boton cerrar
                'class': 'close',
                'id': 'filter-header',
                'data-toggle': 'collapse',
                'data-target': '#filter-collapse'
              }).append(
                $('<i>', { // icono minimizar
                  'class': 'fas fa-window-minimize'
                })
              )
            ),
            $('<div>', { // collapse
              'class': 'collapse show',
              'id': 'filter-collapse'
            }).append(
              $('<div>', { // card-body
                'class': 'card-body',
                'id': 'filter-body'
              })
            )
          )
        )
      )
      var spinner = $('<div class="spinner-border float-right mr-2" role="status" id="spinner"></div>');
      $('#filter-container').after(spinner);

    }; // Cierra if overlay

    // Aplicamos drag and drop
    dragula({
      containers: Array.prototype.slice.call($('.overlay'))
    });
  };

  add_county_filter_item = function() {
    $('#item-comuna').remove();
    $('#filter-body').append(
      $('<div>', { // item
        'class': 'text-white bg-secondary px-2 mb-1 py-1 rounded',
        'id': 'item-comuna',
        'text': 'Comuna: '+Congo.dashboards.config.county_name
      })
    )
  }

  empty_selection_alert = function() {
    var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert"> Por favor, realice la selección de los datos para deplegar la información de la capa. <button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
    $('#alerts').append(alert);
  }

  return {
    init: init,
    create_overlay_and_filter_card: create_overlay_and_filter_card,
    empty_selection_alert: empty_selection_alert,
    add_county_filter_item: add_county_filter_item
  }
}();

Congo.dashboards.action_graduated_points = function(){
  init=function(){
  }
return{
  init: init
}
}();
