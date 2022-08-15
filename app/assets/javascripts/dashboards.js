$(document).ready(function(){
  $(".reports").on('click', function(){
    Congo.dashboards.config.kind_reports = this.id;
    Congo.reports();
  })
  $('#prop_prv_availability').on('click', function(){
    Congo.dashboards.config.widget = 'prv_stock_units';
  });
  $('#prop_prv_sale').on('click', function(){
    Congo.dashboards.config.widget = 'prv_sold_units';
  });
  $('#prop_prv_uf').on('click', function(){
    Congo.dashboards.config.widget = 'prv_uf_avg_percent';
  });
  $('#prop_prv_uf_m2_util').on('click', function(){
    Congo.dashboards.config.widget = 'prv_uf_m2_u';
  });
  $('#prop_cbr_uf').on('click', function(){
    Congo.dashboards.config.widget = 'cbr_calculated_value';
  });
  $('#prop_cbr_uf_m2_util').on('click', function(){
    Congo.dashboards.config.widget = 'cbr_uf_m2_u';
  });
  $('#heat_cbr_amount').on('click', function(){
    Congo.dashboards.config.widget = 'heat_cbr_amount';
  });
  $('#heat_cbr_uf').on('click', function(){
    Congo.dashboards.config.widget = 'heat_calculated_value';
  });
  $('#heat_cbr_uf_m2_util').on('click', function(){
    Congo.dashboards.config.widget = 'heat_uf_m2_u';
  });
  $('#heat_prv_uf').on('click', function(){
    Congo.dashboards.config.widget = 'heat_prv_uf';
  });
  $('#heat_prv_uf_m2_util').on('click', function(){
    Congo.dashboards.config.widget = 'heat_prv_uf_m2_u';
  });
  $('#ica').on('click', function(){
    Congo.dashboards.config.widget = 'col_ica_vacancy';
  });
  $('#col_ica_vacancy').on('click', function(){
    Congo.dashboards.config.widget = 'col_ica_vacancy';
  });
  $('#col_ica_price').on('click', function(){
    Congo.dashboards.config.widget = 'col_ica_price';
  });
  $('#type_point').on('click', function(){

    layer_type = Congo.dashboards.config.layer_type;
    switch(layer_type){
      case 'future_projects_info':
        Congo.dashboards.config.style_layer= 'future_projects_normal_point';
        break;
      case 'transactions_info':
        Congo.dashboards.config.style_layer= 'poi_new';
        break;

      case 'projects_feature_info':
        Congo.dashboards.config.style_layer= 'poi_new';
        break;
    }
    Congo.map_utils.counties();
  });

  $('#building_regulations_max_density').on('click', function(){
    Congo.dashboards.config.widget = 'building_regulations_max_density';
  });
  $('#building_regulations_floors').on('click', function(){
    Congo.dashboards.config.widget = 'building_regulations_floors';
  });

  $("[data-action-show-password]").on('click',function() {
    if ($("[data-show-password]").attr('type') === 'password') {
      $("[data-show-password]").attr('type', 'text');
      $("[data-action-show-password]").removeClass('fa-eye-slash')
      $("[data-action-show-password]").addClass('fa-eye')
    } else {
      $("[data-show-password]").attr('type', 'password');
      $("[data-action-show-password]").removeClass('fa-eye')
      $("[data-action-show-password]").addClass('fa-eye-slash')
    }
  })
});



Congo.namespace('dashboards.action_index');
Congo.namespace('dashboards.action_graduated_points');

Congo.dashboards.config = {
  county_name: '',
  county_id: [],
  layer_type: '',
  style_layer: '',
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
  slider_periods: [],
  row_id: '',
  widget: '',
  square_meters_download_projects: 0,
  meters_download_radius_projects: 0,
  square_meters_download_future_projects: 0,
  meters_download_radius_future_projects: 0,
  square_meters_download_transactions: 0,
  meters_download_radius_transastions: 0,
  user_id: 0,
  map: {},
  groupLayer: {},
  layerControl: {},
  editableLayers: {},
  sourcePois: {},
  sourceLots: {},
  download_tag: 'info',
  years: []
}

Congo.dashboards.pois =function(){
    row_id = Congo.dashboards.config.row_id;
    model = Congo.dashboards.config.layer_type;
    data = {id: row_id, model: model};
    $.ajax({
      type: 'GET',
      url: '/pois/get_around_pois.json',
      datatype: 'json',
      data: data,
      success: function(result) {

        $('#popup_equip_'+model).empty();

        $('#popup_equip_'+model).append(
          $('<table>', {
            'class': 'table table-striped table-hover table-bordered text-light'
          }).append(
            $('<thead>').append(
              $('<tr>').append(
                $('<th>', {
                  'text': 'Tipo',
                }),
                $('<th>', {
                  'text': 'Distancia',
                }),
                $('<th>', {
                  'text': 'Nombre',
                })
              )
            ),
            $('<tbody>', {
              'id': 'tbody-equip_'+model,
            })
          )
        );

        $.each(result, function(key, rows){
          $.each(rows, function(i, value){
            $('#tbody-equip_'+model).append(
              $('<tr>').append(
                $('<td>', {
                  'text': value.sub_category_name,
                }),
                $('<td>', {
                  'text': value.meters + ' m',
                }),
                $('<td>', {
                  'text': value.name,
                })
              )
            );
          }); // Cierra each rows
        }); // Cierra each result

      } // Cierra success
    }) // Cierra ajax
}

Congo.dashboards.action_index = function() {

  init = function() {
    var va = document.querySelector('#downloads');
    var layer_type;

    if (va){
      Congo.dashboards.config.square_meters_download_projects        = va.dataset.allowedAreaProjects
      Congo.dashboards.config.meters_download_radius_projects        = va.dataset.allowedRadiusProjects
      Congo.dashboards.config.square_meters_download_future_projects = va.dataset.allowedAreaFutureProjects
      Congo.dashboards.config.meters_download_radius_future_projects = va.dataset.allowedRadiusFutureProjects
      Congo.dashboards.config.square_meters_download_transactions    = va.dataset.allowedAreaTransactions
      Congo.dashboards.config.meters_download_radius_transactions    = va.dataset.allowedRadiusTransactions
    }
    // Aplica el boost si cumple con la condición
    $('#boost').on('click', function() {
      area = Congo.dashboards.config.area;
      radius = Congo.dashboards.config.radius;
      if ((area > 0 && area < 785398) || (radius > 0 && radius < 500)) {
        Congo.dashboards.config.boost = true;
        if ($('#item-boost').length == 0) {
          $('#filter-body').append(
            $('<div>', {
              'class': 'text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow',
              'id': 'item-boost',
              'text': 'Boost Activo'
            }).append(
              $('<button>', {
                'type': 'button',
                'class': 'close',
                'id': 'close-boost',
                'text': '×',
                'onclick': 'del_boost_filter()'
              })
            )
          )
        }
        Congo.map_utils.counties();
      } else {
        var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
        $('#alerts').append(alert);
      }
    })
    Congo.dashboards.action_index.get_last_period();
    Congo.map_utils.init();

    var active_periods = document.querySelector('#downloads').dataset.urlPeriods

    $.ajax({
      headers: { "Accept": "application/json"},
      async: false,
      type: 'GET',
      crossDomain: true,
      data: {
        enable: "true"
      },
      url: active_periods,
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

  // Elimina el boost
  del_boost_filter = function() {
    Congo.dashboards.config.boost = false
    $('#item-boost').remove();
    Congo.map_utils.counties();
  }

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
                'text': 'Filtros Activos'
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
            ),
            $('<i>', { // flecha
              'class': 'fas fa-arrow-alt-circle-right',
              'id': 'view'
            })
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

    $("#view").unbind('click').click(function() {

      // Chequeamos el estado de view
      view_status = $('#view').hasClass('div_off');

      if (!view_status) { // Oculto

        $(".overlay").css("transition", "width 1s");

        $('#view').addClass('div_off');
        $('#view').removeClass('fa-arrow-alt-circle-right');
        $('#view').addClass('fa-arrow-alt-circle-left');
        $(".overlay").css("width", "15px");
        $(".overlay").css("overflow-y", "hidden");

        $("#filter-container").removeClass('bg-primary');
        $("#filter-container").addClass('border-0');
        $("#filter-container").css("background-color", "rgba(58, 63, 68, 0)");
        $("#filter-container").css("transition-delay", "0s");

        $("#filter-header").css("transition-delay", "0s");
        $("#filter-header").css("transform", "scale(0)");

        $("#filter-collapse").css("transition-delay", "0s");
        $("#filter-collapse").css("transform", "scale(0)");

        $(".chart-container").css("transition-delay", "0s");
        $(".chart-container").css("transform", "scale(0)");

      } else { // Visible

        $('#view').removeClass('div_off');
        $('#view').removeClass('fa-arrow-alt-circle-left');
        $('#view').addClass('fa-arrow-alt-circle-right');
        $(".overlay").css("width", "400px");
        $(".overlay").css("overflow-y", "scroll");

        $("#filter-container").addClass('bg-primary');
        $("#filter-container").removeClass('border-0');
        $("#filter-container").css("background-color", "rgba(58, 63, 68, 1)");
        $("#filter-container").css("transition-delay", "0.8s");

        $("#filter-header").css("transition-delay", "0.8s");
        $("#filter-header").css("transform", "scale(1)");

        $("#filter-collapse").css("transition-delay", "0.8s");
        $("#filter-collapse").css("transform", "scale(1)");

        $(".chart-container").css("transition-delay", "0.8s");
        $(".chart-container").css("transform", "scale(1)");

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
    if ($('#time_slider').length == 0) {

      // Agregamos el slider al card de "Filtros Activos"
      $('#filter-body').prepend(
        $('<div>', {
          'id': 'time_slider_item'
        }).append(
          $("<input>", {
            'id': 'time_slider'
          }),
          $("<div>", {
            'class': 'dropdown-divider',
          })
        )
      )

      // Levantamos los datos de los periodos
      var slider_periods = Congo.dashboards.config.slider_periods

      // Implementamos ionRangeSlider
      $("#time_slider").ionRangeSlider({
        skin: "flat",
        grid: false,
        from: slider_periods.length-1,
        values: slider_periods,
        block: false,
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
    } // Cierra if length
  } // Cierra add_time_slider

  empty_selection_alert = function() {
    var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert"> Por favor, realice la selección de los datos para deplegar la información de la capa. <button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
    $('#alerts').append(alert);
  }

  get_last_period = function() {
    layer_type = Congo.dashboards.config.layer_type;
    county_id = [];
    $.each(Congo.dashboards.config.county_id, function(a,b){
       county_id =b;
    })
    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = JSON.stringify(Congo.dashboards.config.size_box);

    data ={
      wkt: wkt,
      radius: radius,
      centerpt: centerPoint,
      county_id: county_id,
      layer_type: layer_type
    }
    $.ajax({
      async: false,
      type: 'GET',
      url: '/dashboards/filter_period.json',
      data: {data: data},
      datatype: 'json',
      success: function(data) {

        Congo.dashboards.config.year = data['year'];
        Congo.dashboards.config.bimester = data['bimester'];
      }
    });
}

  return {
    init: init,
    del_boost_filter: del_boost_filter,
    create_overlay_and_filter_card: create_overlay_and_filter_card,
    empty_selection_alert: empty_selection_alert,
    add_county_filter_item: add_county_filter_item,
    add_time_slider: add_time_slider,
    get_last_period: get_last_period
  }
}();

Congo.dashboards.action_graduated_points = function() {

  init = function() {}

  return {
    init: init
  }
}();
