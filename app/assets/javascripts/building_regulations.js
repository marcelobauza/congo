Congo.namespace('building_regulations.action_dashboards');

Congo.building_regulations.config= {
  county_name: '',
  county_id: '',
  layer_type: 'building_regulations_info',
  allowed_use_ids: [],
  from_construct: '',
  to_construct: '',
  from_land_ocupation: '',
  to_land_ocupation: '',
  from_max_height: '',
  to_max_height: '',
  from_inhabitants_hectare: '',
  to_inhabitants_hectare: '',
}

function addUsoFilter(id, name) {

  if ($('#item-uso-'+id).length == 0) {

    Congo.building_regulations.config.allowed_use_ids.push(id);

    $('#filter-body').append(
      $('<div>', {
          'class': 'filter-building-regulations text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow',
          'id': 'item-uso-'+id,
          'text': 'Uso Permitido: '+name
      }).append(
        $('<button>', {
            'type': 'button',
            'class': 'close',
            'id': 'close-uso-'+id,
            'text': '×',
            'onclick': 'delUsoFilter('+id+', "'+name+'")'
        })
      )
    );
    indicator_building_regulations();

  };

};

function delUsoFilter(id, name) {

  var active_uso = Congo.building_regulations.config.allowed_use_ids;

  var uso_updated = $.grep(active_uso, function(n, i) {
    return n != id;
  });

  Congo.building_regulations.config.allowed_use_ids = uso_updated;

  $('#item-uso-'+id).remove();
  indicator_building_regulations();

}

Congo.building_regulations.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_building_regulations = function(){

    county_id = Congo.dashboards.config.county_id;
    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
    allowed_use_ids = Congo.building_regulations.config.allowed_use_ids;
    from_construct = Congo.building_regulations.config.from_construct;
    to_construct = Congo.building_regulations.config.to_construct;
    from_land_ocupation = Congo.building_regulations.config.from_land_ocupation;
    to_land_ocupation = Congo.building_regulations.config.to_land_ocupation;
    from_max_height = Congo.building_regulations.config.from_max_height;
    to_max_height = Congo.building_regulations.config.to_max_height;
    from_inhabitants_hectare = Congo.building_regulations.config.from_inhabitants_hectare;
    to_inhabitants_hectare = Congo.building_regulations.config.to_inhabitants_hectare;
    type_geometry = Congo.dashboards.config.typeGeometry;
    layer_type = Congo.dashboards.config.layer_type;
    style_layer = Congo.dashboards.config.style_layer;

    if (county_id == '' && centerPoint == '' && wkt.length == 0) {

      Congo.dashboards.action_index.empty_selection_alert();

    // Si se realizó la selección, añade los elementos al dashboard
    } else {

      // Creamos el overlay
      Congo.dashboards.action_index.create_overlay_and_filter_card();

      if (county_id != '') {

        // Agregamos filtro Comuna
        Congo.dashboards.action_index.add_county_filter_item()

        data = {
          allowed_use_ids: allowed_use_ids,
          from_construct: from_construct,
          to_construct: to_construct,
          from_land_ocupation: from_land_ocupation,
          to_land_ocupation: to_land_ocupation,
          from_max_height: from_max_height,
          to_max_height: to_max_height,
          from_inhabitants_hectare: from_inhabitants_hectare,
          to_inhabitants_hectare: to_inhabitants_hectare,
          county_id: county_id,
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer
        };

      } else if (centerPoint != '') {

        // Eliminamos filtro comuna
        $('#item-comuna').remove();

        data = {
          allowed_use_ids: allowed_use_ids,
          from_construct: from_construct,
          to_construct: to_construct,
          from_land_ocupation: from_land_ocupation,
          to_land_ocupation: to_land_ocupation,
          from_max_height: from_max_height,
          to_max_height: to_max_height,
          from_inhabitants_hectare: from_inhabitants_hectare,
          to_inhabitants_hectare: to_inhabitants_hectare,
          centerpt: centerPoint,
          radius: radius,
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer
        };

      } else {

        // Eliminamos filtro comuna
        $('#item-comuna').remove();

        data = {
          allowed_use_ids: allowed_use_ids,
          from_construct: from_construct,
          to_construct: to_construct,
          from_land_ocupation: from_land_ocupation,
          to_land_ocupation: to_land_ocupation,
          from_max_height: from_max_height,
          to_max_height: to_max_height,
          from_inhabitants_hectare: from_inhabitants_hectare,
          to_inhabitants_hectare: to_inhabitants_hectare,
          wkt: JSON.stringify(wkt),
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer
        };

      };

      $.ajax({
        type: 'GET',
        url: '/building_regulations/building_regulations_filters.json',
        datatype: 'json',
        data: data,
        beforeSend: function() {
          // Mostramos el spinner y deshabilitamos los botones
          $("#spinner").show();
          $('.btn').addClass('disabled')
          $('.close').prop('disabled', true);

          // Establece el nombre de la capa en el navbar
          $('#layer-name').text('Normativa');

          // Eliminamos los chart-containter de la capa anterior
          $(".chart-container").remove();

          // Mostramos el filtro de la capa y ocultamos los demás
          $('.filter-building-regulations').show();
          $('.filter-transactions').hide();
          $('.filter-projects').hide();
          $('.filter-future-projects').hide();
        },
        success: function(data){

          // Ocultamos el spinner y habilitamos los botones
          $("#spinner").hide();
          $('.btn').removeClass('disabled')
          $('.close').prop('disabled', false);

          // Creamos el div contenedor
          var chart_container = document.createElement('div');
          chart_container.className = 'chart-container card text-light bg-primary';
          chart_container.id = 'chart-container';

          // Creamos el card-header
          var card_header = document.createElement('div');
          card_header.className = 'card-header pl-3';
          card_header.id = 'header';

          // Creamos el collapse
          var collapse = document.createElement('div');
          collapse.className = 'collapse show';
          collapse.id = 'collapse';

          // Creamos el card-body
          var card_body = document.createElement('div');
          card_body.className = 'card-body';
          card_body.id = 'body';

          // TODO: Crear título y boton minimizar dinámicos

          // Creamos título y boton minimizar
          var card_handle = '<span class="fas fa-arrows-alt handle border border-dark">'
          var card_min_button = '<button type="button" class="close" data-toggle="collapse" data-target="#collapse" aria-expanded="true" aria-controls="collapse" aria-label="Minimize"><i class="fas fa-window-minimize"></i></button>'
          var card_header_title = '<b>Filtrar Información por:</b>'

          // Adjuntamos los elementos
          $('.overlay').append(chart_container);
          $('#chart-container').append(card_header, collapse);
          $('#collapse').append(card_body);
          $('#header').append(card_handle, card_min_button, card_header_title);

          // Separamos la información
          for (var i = 0; i < data.length; i++) {

            var reg = data[i];
            var label = reg['label'];

            if (label == "Uso Permitido") {

              var info = reg['data'];

              // Agrega el título y el list_group
              $('#body').append(
                $("<h6>", {
                  'class': 'card-subtitle mb-2',
                  'text': label
                }),
                $("<div>", {
                  'class': 'list-group border',
                  'id': 'uso-list'
                }),
                $("<div>", {
                  'class': 'dropdown-divider',
                })
              );

              // Extraemos los datos y los adjuntamos al list_group
              $.each(info, function(y, z){
                name = z['name'];
                id = z['id']

                $('#uso-list').append(
                  $("<button>", {
                      'type': 'button',
                      'id': 'uso-'+id,
                      'onclick': 'addUsoFilter('+id+', "'+name+'")',
                      'class': 'list-group-item list-group-item-action',
                      'text': name
                  })
                )

              }) // Cierra each
            } // Cierra if Uso Permitido

            if (label == "Coeficiente de Constructibilidad") {

              var min = reg['min'];
              var max = reg['max'];
              var to;
              var from;

              // Levantamos los valores de "to" y "from"
              if (Congo.building_regulations.config.to_construct == '') {
                to = max
              } else {
                to = Congo.building_regulations.config.to_construct
              };
              from = Congo.building_regulations.config.from_construct;

              // Agrega el título y el range_slider
              $('#body').append(
                $("<h6>", {
                  'class': 'card-subtitle mb-2',
                  'text': label
                }),
                $("<input>", {
                  'id': 'range_slider_coef_const'
                }),
                $("<div>", {
                  'class': 'dropdown-divider',
                })
              );

              $("#range_slider_coef_const").ionRangeSlider({
                skin: "flat",
                type: 'double',
                grid: true,
                min: min,
                max: max,
                step: 0.1,
                from: from,
                to: to,
                onFinish: function (data) {

                  // Almacena los datos en la variable global
                  Congo.building_regulations.config.from_construct = data.from;
                  Congo.building_regulations.config.to_construct = data.to;

                  // Si no existe el filtro, lo crea
                  if ($('#item-construct').length == 0) {

                    $('#filter-body').append(
                      $("<div>", {
                          'class': 'filter-building-regulations text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow',
                          'id': 'item-construct',
                          'text': 'Coeficiente de Constructibilidad >= '+data.from+' <= '+data.to
                      })
                    );

                  // Si existe el filtro, solo modifica el texto
                  } else {
                    $('#item-construct').text('Coeficiente de Constructibilidad >= '+data.from+' <= '+data.to);
                  };

                  // Agrega el close button
                  $('#item-construct').append(
                    $("<button>", {
                        'class': 'close',
                        'id': 'close-item-construct',
                        'type': 'button',
                        'text': '×'
                    })
                  )
                  indicator_building_regulations();

                }, // Cierra onFinish
              }); // Cierra ionRangeSlider

              // Elimina el filtro
              $('#close-item-construct').unbind('click').click(function() {
                Congo.building_regulations.config.from_construct = '';
                Congo.building_regulations.config.to_construct = '';
                $('#item-construct').remove();
                indicator_building_regulations();
              });

            } // Cierra if Coeficiente de Constructibilidad

            if (label == "Ocupación de Suelo") {

              var min = reg['min'];
              var max = reg['max'];
              var to;
              var from;

              // Levantamos los valores de "to" y "from"
              if (Congo.building_regulations.config.to_land_ocupation == '') {
                to = max
              } else {
                to = Congo.building_regulations.config.to_land_ocupation
              };
              from = Congo.building_regulations.config.from_land_ocupation;

              // Agrega el título y el range_slider
              $('#body').append(
                $("<h6>", {
                  'class': 'card-subtitle mb-2',
                  'text': label
                }),
                $("<input>", {
                  'id': 'range_slider_ocup_suelo'
                }),
                $("<div>", {
                  'class': 'dropdown-divider',
                })
              );

              $("#range_slider_ocup_suelo").ionRangeSlider({
                skin: "flat",
                type: 'double',
                grid: true,
                min: min,
                max: max,
                step: 0.1,
                from: from,
                to: to,
                onFinish: function (data) {

                  // Almacena los datos en la variable global
                  Congo.building_regulations.config.from_land_ocupation = data.from;
                  Congo.building_regulations.config.to_land_ocupation = data.to;

                  // Si no existe el filtro, lo crea
                  if ($('#item-suelo').length == 0) {

                    $('#filter-body').append(
                      $("<div>", {
                          'class': 'filter-building-regulations text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow',
                          'id': 'item-suelo',
                          'text': 'Ocupación de Suelo >= '+data.from+' <= '+data.to
                      })
                    );

                  // Si existe el filtro, solo modifica el texto
                  } else {
                    $('#item-suelo').text('Ocupación de Suelo >= '+data.from+' <= '+data.to);
                  };

                  // Agrega el close button
                  $('#item-suelo').append(
                    $("<button>", {
                        'class': 'close',
                        'id': 'close-item-suelo',
                        'type': 'button',
                        'text': '×'
                    })
                  )
                  indicator_building_regulations();

                }, // Cierra onFinish
              }); // Cierra ionRangeSlider

              // Elimina el filtro
              $('#close-item-suelo').unbind('click').click(function() {
                Congo.building_regulations.config.from_land_ocupation = '';
                Congo.building_regulations.config.to_land_ocupation = '';
                $('#item-suelo').remove();
                indicator_building_regulations();
              });

            } // Cierra if Ocupación de Suelo

            if (label == "Altura Máxima") {

              var min = reg['min'];
              var max = reg['max'];
              var to;
              var from;

              // Levantamos los valores de "to" y "from"
              if (Congo.building_regulations.config.to_max_height == '') {
                to = max
              } else {
                to = Congo.building_regulations.config.to_max_height
              };
              from = Congo.building_regulations.config.from_max_height;

              // Agrega el título y el range_slider
              $('#body').append(
                $("<h6>", {
                  'class': 'card-subtitle mb-2',
                  'text': label
                }),
                $("<input>", {
                  'id': 'range_slider_alt_max'
                }),
                $("<div>", {
                  'class': 'dropdown-divider',
                })
              );

              $("#range_slider_alt_max").ionRangeSlider({
                skin: "flat",
                type: 'double',
                grid: true,
                min: min,
                max: max,
                step: 0.1,
                from: from,
                to: to,
                onFinish: function (data) {

                  // Almacena los datos en la variable global
                  Congo.building_regulations.config.from_max_height = data.from;
                  Congo.building_regulations.config.to_max_height = data.to;

                  // Si no existe el filtro, lo crea
                  if ($('#item-altura').length == 0) {

                    $('#filter-body').append(
                      $("<div>", {
                          'class': 'filter-building-regulations text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow',
                          'id': 'item-altura',
                          'text': 'Altura Máxima >= '+data.from+' <= '+data.to
                      })
                    );

                  // Si existe el filtro, solo modifica el texto
                  } else {
                    $('#item-altura').text('Altura Máxima >= '+data.from+' <= '+data.to);
                  };

                  // Agrega el close button
                  $('#item-altura').append(
                    $("<button>", {
                        'class': 'close',
                        'id': 'close-item-altura',
                        'type': 'button',
                        'text': '×'
                    })
                  )
                  indicator_building_regulations();

                }, // Cierra onFinish
              }); // Cierra ionRangeSlider

              // Elimina el filtro
              $('#close-item-altura').unbind('click').click(function() {
                Congo.building_regulations.config.from_max_height = '';
                Congo.building_regulations.config.to_max_height = '';
                $('#item-altura').remove();
                indicator_building_regulations();
              });

            } // Cierra if Altura Máxima

            if (label == "Habitantes por Hectárea") {

              var min = reg['min'];
              var max = reg['max'];
              var to;
              var from;

              // Levantamos los valores de "to" y "from"
              if (Congo.building_regulations.config.to_inhabitants_hectare == '') {
                to = max
              } else {
                to = Congo.building_regulations.config.to_inhabitants_hectare
              };
              from = Congo.building_regulations.config.from_inhabitants_hectare;

              // Agrega el título y el range_slider
              $('#body').append(
                $("<h6>", {
                  'class': 'card-subtitle mb-2',
                  'text': label
                }),
                $("<input>", {
                  'id': 'range_slider_hab_hect'
                })
              );

              $("#range_slider_hab_hect").ionRangeSlider({
                skin: "flat",
                type: 'double',
                grid: true,
                min: min,
                max: max,
                step: 10,
                from: from,
                to: to,
                onFinish: function (data) {

                  // Almacena los datos en la variable global
                  Congo.building_regulations.config.from_inhabitants_hectare = data.from;
                  Congo.building_regulations.config.to_inhabitants_hectare = data.to;

                  // Si no existe el filtro, lo crea
                  if ($('#item-habitantes').length == 0) {

                    $('#filter-body').append(
                      $("<div>", {
                          'class': 'filter-building-regulations text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow',
                          'id': 'item-habitantes',
                          'text': 'Habitantes por Hectárea >= '+data.from+' <= '+data.to
                      })
                    );

                  // Si existe el filtro, solo modifica el texto
                  } else {
                    $('#item-habitantes').text('Habitantes por Hectárea >= '+data.from+' <= '+data.to);
                  };

                  // Agrega el close button
                  $('#item-habitantes').append(
                    $("<button>", {
                        'class': 'close',
                        'id': 'close-item-habitantes',
                        'type': 'button',
                        'text': '×'
                    })
                  )
                  indicator_building_regulations();

                }, // Cierra onFinish
              }); // Cierra ionRangeSlider

              // Elimina el filtro
              $('#close-item-habitantes').unbind('click').click(function() {
                Congo.building_regulations.config.from_inhabitants_hectare = '';
                Congo.building_regulations.config.to_inhabitants_hectare = '';
                $('#item-habitantes').remove();
                indicator_building_regulations();
              });

            } // Cierra if Habitantes por Hectárea

          } // Cierra for
        } // Cierra success
      }) // Cierra ajax
    } // Cierra if alert
  } // Cierra indicator_building_regulations

  return {
    init: init,
    indicator_building_regulations: indicator_building_regulations
  }
}();
