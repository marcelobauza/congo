Congo.namespace('dashboards.action_index');
Congo.namespace('dashboards.action_graduated_points');

Congo.dashboards.config = {
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
  boost: false,
  area: 0,
  draw_active: false,
  slider_periods: []
}

Congo.dashboards.action_index = function() {

  init = function() {

    $('#boost').on('click', function() {
      area = Congo.dashboards.config.area;
      radius = Congo.dashboards.config.radius;
      if ((area > 0 && area < 3140000) || (radius > 0 && radius < 1000)) {
        Congo.dashboards.config.boost = true;
        Congo.map_utils.counties();
      } else {
        console.log("es muy grande");
      }
    })

    $.ajax({
      async: false,
      type: 'GET',
      url: '/dashboards/filter_period.json',
      datatype: 'json',
      success: function(data) {
        Congo.dashboards.config.year = data['year'];
        Congo.dashboards.config.bimester = data['bimester'];
      }
    });

    Congo.map_utils.init();

    $.ajax({
      async: false,
      type: 'GET',
      data: {
        enable: "true"
      },
      url: '/admin/periods/active_periods.json',
      datatype: 'json',
      success: function(data) {
        $.each(data, function(key, period) {
          $.each(period, function(a, value) {
            Congo.dashboards.config.slider_periods.push(value.bimester + "/" + value.year);
          })
        })
      }
    });

  } // Cierra init

  // Creamos el overlay
  create_overlay_and_filter_card = function() {

    if ($('.overlay').length == 0) {

      $('#map').before(
        $('<div>', { // overlay
          'class': 'overlay'
        }).append(
          $('<div>', { // card
            'class': 'card text-light bg-primary sticky-top',
            'id': 'filter-container'
          }).append(
            $('<div>', { // card-header
              'class': 'card-header pl-3',
              'id': 'filter-header'
            }).append(
              $('<span>', { // handle
                'class': 'fas fa-arrows-alt handle border border-dark'
              }),
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
      var spinner = $('<div class="spinner-border text-dark float-right mr-2" role="status" id="spinner"></div>');
      $('#filter-container').after(spinner);

    }; // Cierra if overlay

    // Aplicamos drag and drop
    dragula({
      containers: Array.prototype.slice.call($('.overlay')),
      moves: function(el, container, handle) {
        return handle.classList.contains('handle') || handle.parentNode.classList.contains('handle');
      }
    });

  } // Cierra create_overlay_and_filter_card

  add_county_filter_item = function() {
    $('#item-comuna').remove();
    $('#filter-body').append(
      $('<div>', { // item
        'class': 'text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow',
        'id': 'item-comuna',
        'text': 'Comuna: ' + Congo.dashboards.config.county_name
      })
    )
  }

  add_time_slider = function() {

    if ($('#range_slider_time').length == 0) {

      // Agregamos el slider al card de "Filtros"
      $('#filter-body').prepend(
        $("<input>", {
          'id': 'range_slider_time'
        }),
        $("<div>", {
          'class': 'dropdown-divider',
        })
      )

      // Levantamos los datos de los periodos y del periodo actual
      var slider_periods = Congo.dashboards.config.slider_periods
      var actual_slider_period = to_bimester + '/' + to_year

      // Implementamos ionRangeSlider
      $("#range_slider_time").ionRangeSlider({
        skin: "flat",
        grid: true,
        min: slider_periods[0],
        max: slider_periods[slider_periods.length - 1],
        from: actual_slider_period,
        values: slider_periods,
        onFinish: function(data) {

          var data = data.from_value.split("/")
          var updated_bimester = data[0]
          var updated_year = data[1]

          // Actualizamos el periodo actual
          Congo.dashboards.config.bimester = updated_bimester
          Congo.dashboards.config.year = updated_year

          // Recargamos la capa
          Congo.map_utils.counties();

        }, // Cierra onFinish
      }); // Cierra ionRangeSlider
    } // If length
  } // Cierra add_time_slider

  empty_selection_alert = function() {
    var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert"> Por favor, realice la selección de los datos para deplegar la información de la capa. <button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
    $('#alerts').append(alert);
  }

  return {
    init: init,
    create_overlay_and_filter_card: create_overlay_and_filter_card,
    empty_selection_alert: empty_selection_alert,
    add_county_filter_item: add_county_filter_item,
    add_time_slider: add_time_slider,
  }
}();

Congo.dashboards.action_graduated_points = function() {

  init = function() {}

  return {
    init: init
  }

}();
