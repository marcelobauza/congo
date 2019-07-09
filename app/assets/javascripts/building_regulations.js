Congo.namespace('building_regulations.action_dashboards');

Congo.building_regulations.config= {
  county_name: '',
  county_id: '',
  layer_type: 'building_regulations_info',
  from_construct: '',
  to_construct: '',
  from_land_ocupation: '',
  to_land_ocupation: '',
  allowed_use_ids: []
}

function addUsoFilter(id, name) {

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
    from_construct = Congo.building_regulations.config.from_construct;
    to_construct = Congo.building_regulations.config.to_construct;
    from_land_ocupation = Congo.building_regulations.config.from_land_ocupation;
    to_land_ocupation = Congo.building_regulations.config.to_land_ocupation;
    allowed_use_ids = Congo.building_regulations.config.allowed_use_ids;
    type_geometry = Congo.dashboards.config.typeGeometry;
    layer_type = Congo.dashboards.config.layer_type;
    style_layer = Congo.dashboards.config.style_layer;

    if (county_id == '' && centerPoint == '' && wkt.length == 0) {

      Congo.dashboards.action_index.empty_selection_alert();

    // Si se realizó la selección, añade los elementos al dashboard
    } else {

      // Creamos el overlay
      Congo.dashboards.action_index.create_overlay_and_filter_card();

      // Si se realizó la selección por comuna/punto, agregamos el item al filtro
      if (county_id != '') {
        Congo.dashboards.action_index.add_county_filter_item()
      }

      if (county_id != '') {
        data = {
          from_construct: from_construct,
          to_construct: to_construct,
          from_land_ocupation: from_land_ocupation,
          to_land_ocupation: to_land_ocupation,
          allowed_use_ids: allowed_use_ids,
          county_id: county_id,
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer

        };
      } else if (centerPoint != '') {
        data = {
          from_construct: from_construct,
          to_construct: to_construct,
          from_land_ocupation: from_land_ocupation,
          to_land_ocupation: to_land_ocupation,
          allowed_use_ids: allowed_use_ids,
          centerpt: centerPoint,
          radius: radius,
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer

        };
      } else {
        data = {
          from_construct: from_construct,
          to_construct: to_construct,
          from_land_ocupation: from_land_ocupation,
          to_land_ocupation: to_land_ocupation,
          allowed_use_ids: allowed_use_ids,
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

          // Eliminamos los filtros de la capa anterior
          $('.filter-future-projects').remove();
          $('.filter-transactions').remove();
          $('.filter-projects').remove();
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
          card_header.className = 'card-header';
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
          var card_header_button = '<button type="button" class="close" data-toggle="collapse" data-target="#collapse" aria-expanded="true" aria-controls="collapse" aria-label="Minimize"><i class="fas fa-window-minimize"></i></button>'
          var card_header_title = '<b>Filtrar Información por:</b>'

          // Adjuntamos los elementos
          $('.overlay').append(chart_container);
          $('#chart-container').append(card_header, collapse);
          $('#collapse').append(card_body);
          $('#header').append(card_header_button, card_header_title);

          // Separamos la información
          for (var i = 0; i < data.length; i++) {

            var reg = data[i];
            var label = reg['label'];

            if (label == "Uso Permitido") {

              var info = reg['data'];

              // Agrega el título y el list_group
              $('#body').append(
                $("<b>", {
                    'text': label
                }),
                $("<div>", {
                  'class': 'list-group border',
                  'id': 'uso-list'
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
                $("<b>", {
                    'text': label
                }),
                $("<input>", {
                  'id': 'range_slider_coef_const'
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
                $("<b>", {
                    'text': label
                }),
                $("<input>", {
                  'id': 'range_slider_ocup_suelo'
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
