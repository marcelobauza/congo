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

building_regulations_popup = function(id) {

  data = {id: id};
  $.ajax({
    type: 'GET',
    url: '/building_regulations/index.json',
    datatype: 'json',
    data: data,
    success: function(data) {

      land_use_types = [];

      $.each(data.land_use_types, function(a, b) {
        land_use_types.push(b.name);
      });

      $('#popup_info_building_regulations').empty();

      // Agregamos la información general
      $('#popup_info_building_regulations').append(
        $('<p>').append(
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Normativa de Edificación:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.building_zone
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Uso:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': land_use_types
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Constructibilidad:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.construct
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Ocupación de Suelo:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.osinciti
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Altura Máxima:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.aminciti
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Habitantes por Hectárea:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.hectarea_inhabitants
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Sistema de Agrupamiento:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.grouping
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Superficie del Predio:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.area
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Estacionamientos:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.parkings
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Comentarios:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.comments
            }),
          ),
        ),
        $('<div>', {
          'class': 'text-center'
        }).append(
          $('<a>', {
            'class': 'btn btn-primary text-center',
            'href': 'building_regulations/building_regulation_download?county_id=' + data.county_code,
            'role': 'button',
            'text': 'Descargar Ordenanza',
          }),
        )
      )

      $('#leaflet_modal_building_regulations').modal('show');

      // Vuelve a activar el primer tab cuando se cierra el modal del popup
      $('#leaflet_modal_building_regulations').on('hidden.bs.modal', function (e) {
        $('#list-tab a:first-child').tab('show')
      })

    } // Cierra success
  }) // Cierra ajax
} // Cierra building_regulations_popup

function building_regulations_report_pdf() {

  $.ajax({
    type: 'GET',
    url: '/reports/building_regulations_pdf.json',
    datatype: 'json',
    data: data,
    success: function(data) {

      console.log(data);

      // Creamos el doc
      var doc = new jsPDF();

      doc.page = 1;

      // Pie de página
      function footer() {
        doc.setFontStyle("bold");
        doc.setFontSize(12);
        doc.text('Fuente:', 20, 290);
        doc.setFontStyle("normal");
        doc.text('Plan Regulador Comunal y Ordenanza Local vigente (de la comuna consultada)', 37, 290);
        doc.setFontSize(10);
        doc.text('p. ' + doc.page, 194, 290);
        doc.page++;
      };

      // Título
      doc.setFontStyle("bold");
      doc.setFontSize(22);
      doc.text('Informe de Normativa', 105, 20, null, null, 'center');

      // Subtítulo
      doc.setFontSize(16);
      doc.text('Información General', 105, 35, null, null, 'center');

      // Pie de página
      footer()

      // Agregamos una página
      doc.addPage('a4', 'portrait')

      // Pie de página
      footer()

      // Párrafo 1
      doc.setFontSize(12);
      doc.text('La información respecto a la subdivisión predial mínima, constructibilidad y ocupación de suelo está', 10, 20);
      doc.text('basada preferentemente en el uso de suelo residencial (RES), exceptuando aquellas zonas cuyo uso', 10, 28);
      doc.text('es exclusivo, por ejemplo EQUIP, IND, etc.', 10, 36);

      // Párrafo 2
      doc.text('La información respecto de altura máxima de edificación esta basada en el sistema de agrupamiento', 10, 52);
      doc.text('aislado.', 10, 60);

      // Párrafo 3
      doc.text('Para obtener mayor detalle respecto a condiciones normativas de cada zona, se recomienda hacer', 10, 76);
      doc.text('clic en “Descargar Ordenanza” para obtener la ordenanza local y modificaciones vigentes si', 10, 84);
      doc.text('corresponde.', 10, 92);

      // Separamos los datos
      $.each(data, function(i,reg){

        var max_height = reg['aminciti']
        var building_regulations = reg['building_zone']
        var allowed_use = reg['use_allow']['name']
        var land_occupation = reg['osinciti']
        var web = reg['site']
        var density = reg['hectarea_inhabitants']
        var max_density = reg['density_type']
        var construct = reg['construct']
        var comments = reg['comments']

        // Arreglamos los valores que llegan con null
        if (max_density == null) {
          max_density = ''
        }
        if (construct == null) {
          construct = ''
        }

        // Cambiamos a string los valores que llegan como integer
        max_height = max_height.toString()
        building_regulations = building_regulations.toString()
        allowed_use = allowed_use.toString()
        land_occupation = land_occupation.toString()
        density = density.toString()

        if (i % 2 == 1) { // impar

          // Agregamos una página
          doc.addPage('a4', 'portrait')

          // Pie de página
          footer()

          // Labels columna arriba
          doc.setFontStyle("bold");
          doc.setFontSize(12);
          doc.text('Normativa de Edificación:', 83, 20, null, null, 'right');
          doc.text('Uso:', 83, 30, null, null, 'right');
          doc.text('Constructibilidad:', 83, 40, null, null, 'right');
          doc.text('Ocupación de suelo:', 83, 50, null, null, 'right');
          doc.text('Altura Máxima:', 83, 60, null, null, 'right');
          doc.text('Densidad:', 83, 70, null, null, 'right');
          doc.text('Densidad Máxima:', 83, 80, null, null, 'right');
          doc.text('Web:', 83, 90, null, null, 'right');
          doc.text('Comentarios:', 83, 100, null, null, 'right');

          // Valores columna arriba
          doc.setFontStyle("normal");
          doc.text(building_regulations, 85, 20);
          doc.text(allowed_use, 85, 30);
          doc.text(construct, 85, 40);
          doc.text(land_occupation, 85, 50);
          doc.text(max_height, 85, 60);
          doc.text(density, 85, 70);
          doc.text(max_density, 85, 80);
          doc.text(web, 85, 90);
          var textLines = doc.splitTextToSize(comments, 120);
          doc.text(textLines, 85, 100);

        } else { // par

          // Separador
          doc.line(10, 140, 200, 140);

          // Labels columna abajo
          doc.setFontStyle("bold");
          doc.setFontSize(12);
          doc.text('Normativa de Edificación:', 83, 160, null, null, 'right');
          doc.text('Uso:', 83, 170, null, null, 'right');
          doc.text('Constructibilidad:', 83, 180, null, null, 'right');
          doc.text('Ocupación de suelo:', 83, 190, null, null, 'right');
          doc.text('Altura Máxima:', 83, 200, null, null, 'right');
          doc.text('Densidad:', 83, 210, null, null, 'right');
          doc.text('Densidad Máxima:', 83, 220, null, null, 'right');
          doc.text('Web:', 83, 230, null, null, 'right');
          doc.text('Comentarios:', 83, 240, null, null, 'right');

          // Valores columna abajo
          doc.setFontStyle("normal");
          doc.text(building_regulations, 85, 160);
          doc.text(allowed_use, 85, 170);
          doc.text(construct, 85, 180);
          doc.text(land_occupation, 85, 190);
          doc.text(max_height, 85, 200);
          doc.text(density, 85, 210);
          doc.text(max_density, 85, 220);
          doc.text(web, 85, 230);
          var textLines = doc.splitTextToSize(comments, 120);
          doc.text(textLines, 85, 240);
        } // Cierra else par/impar
      }) // Cierra for

      // Descarga el archivo PDF
      doc.save("Informe_Normativa.pdf");

    } // Cierra success
  }) // Cierra ajax
} // Cierra function building_regulations_report_pdf

function addUsoFilter(id, name) {

  if ($('#item-uso-'+id).length == 0) {

    Congo.building_regulations.config.allowed_use_ids.push(id);

    $('#filter-body').append(
      $('<div>', {
          'class': 'filter-building-regulations text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow',
          'id': 'item-uso-'+id,
          'text': 'Uso: '+name
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
    Congo.map_utils.counties();

  };

};

function delUsoFilter(id, name) {

  var active_uso = Congo.building_regulations.config.allowed_use_ids;

  var uso_updated = $.grep(active_uso, function(n, i) {
    return n != id;
  });

  Congo.building_regulations.config.allowed_use_ids = uso_updated;

  $('#item-uso-'+id).remove();
  Congo.map_utils.counties();

}

Congo.building_regulations.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_building_regulations = function(){

    county_id = [];
    $.each(Congo.dashboards.config.county_id, function(a,b){
       county_id =b;
    })
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

    if (county_id.length == 0 && centerPoint == '' && wkt.length == 0) {

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

          // Mostramos los iconos de Útiles correspondientes
          $("#boost").hide();
          $("#base").hide();
          $("#graph").hide();

          // Mostramos el icono de Puntos/Poligonos correspondiente
          $("#type_point").hide();
          $("#poly_build").show();
          $("#vor_dem").hide();

          // Mostramos el icono de Puntos Proporcionales correspondiente
          $("#prop-prv").hide();
          $("#prop-cbr").hide();
          $("#prop-em").hide();

          // Mostramos el icono de Heatmap correspondiente
          $("#heat-prv").hide();
          $("#heat-cbr").hide();
          $("#heat-em-dem").hide();

          // Eliminamos los chart-containter de la capa anterior
          $(".chart-container").remove();

          // Mostramos el filtro de la capa y ocultamos los demás
          $('.filter-building-regulations').show();
          $('.filter-transactions').hide();
          $('.filter-projects').hide();
          $('.filter-future-projects').hide();

          // Eliminamos el time_slider y el census_filter
          $('#time_slider_item').remove()
          $('#census_filter').remove()

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

            // if (label == "Uso") {

            //   var info = reg['data'];

            //   // Agrega el título y el list_group
            //   $('#body').append(
            //     $("<h6>", {
            //       'class': 'card-subtitle mb-2',
            //       'text': label
            //     }),
            //     $("<div>", {
            //       'class': 'list-group list-overflow border',
            //       'id': 'uso-list'
            //     }),
            //     $("<div>", {
            //       'class': 'dropdown-divider',
            //     })
            //   );

            //   // Extraemos los datos y los adjuntamos al list_group
            //   $.each(info, function(y, z){
            //     name = z['name'];
            //     id = z['id']

            //     $('#uso-list').append(
            //       $("<button>", {
            //           'type': 'button',
            //           'id': 'uso-'+id,
            //           'onclick': 'addUsoFilter('+id+', "'+name+'")',
            //           'class': 'list-group-item list-group-item-action',
            //           'text': name
            //       })
            //     )

            //   }) // Cierra each
            // } // Cierra if Uso

            if (label == "Constructibilidad") {

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
                          'text': 'Constructibilidad >= '+data.from+' <= '+data.to
                      })
                    );

                  // Si existe el filtro, solo modifica el texto
                  } else {
                    $('#item-construct').text('Constructibilidad >= '+data.from+' <= '+data.to);
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
                  Congo.map_utils.counties();

                }, // Cierra onFinish
              }); // Cierra ionRangeSlider

              // Elimina el filtro
              $('#close-item-construct').unbind('click').click(function() {
                Congo.building_regulations.config.from_construct = '';
                Congo.building_regulations.config.to_construct = '';
                $('#item-construct').remove();
                Congo.map_utils.counties();
              });

            } // Cierra if Constructibilidad

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
                  Congo.map_utils.counties();

                }, // Cierra onFinish
              }); // Cierra ionRangeSlider

              // Elimina el filtro
              $('#close-item-suelo').unbind('click').click(function() {
                Congo.building_regulations.config.from_land_ocupation = '';
                Congo.building_regulations.config.to_land_ocupation = '';
                $('#item-suelo').remove();
                Congo.map_utils.counties();
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
                  Congo.map_utils.counties();

                }, // Cierra onFinish
              }); // Cierra ionRangeSlider

              // Elimina el filtro
              $('#close-item-altura').unbind('click').click(function() {
                Congo.building_regulations.config.from_max_height = '';
                Congo.building_regulations.config.to_max_height = '';
                $('#item-altura').remove();
                Congo.map_utils.counties();
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
                  Congo.map_utils.counties();

                }, // Cierra onFinish
              }); // Cierra ionRangeSlider

              // Elimina el filtro
              $('#close-item-habitantes').unbind('click').click(function() {
                Congo.building_regulations.config.from_inhabitants_hectare = '';
                Congo.building_regulations.config.to_inhabitants_hectare = '';
                $('#item-habitantes').remove();
                Congo.map_utils.counties();
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
