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


function building_regulations_report_pdf() {

  $.ajax({
    type: 'GET',
    url: '/reports/building_regulations_pdf.json',
    datatype: 'json',
    data: data,
    success: function(data) {

      data = data['data']

      // Creamos el doc
      var doc = new jsPDF();

      // Título
      doc.setFontStyle("bold");
      doc.setFontSize(22);
      doc.text('Informe de Normativa', 105, 20, null, null, 'center');

      // Subtítulo
      doc.setFontSize(16);
      doc.text('Polígono Seleccionado', 105, 30, null, null, 'center');

      // Pie de página
      doc.setFontStyle("bold");
      doc.setFontSize(12);
      doc.text('Fuente:', 20, 290);
      doc.setFontStyle("normal");
      doc.text('Plan Regulador Comunal y Ordenanza Local vigente (de la comuna consultada)', 37, 290);

      // Agregamos una página
      doc.addPage('a4', 'portrait')

      // Párrafo 1
      doc.setFontSize(12);
      doc.text('La información respecto a la subdivisión predial mínima, constructibilidad y ocupación de suelo está', 10, 20);
      doc.text('basada preferentemente en el uso de suelo residencial (RES), exceptuando aquellas zonas cuyo uso', 10, 28);
      doc.text('es exclusivo, por ejemplo EQUIP, IND, etc.', 10, 36);

      // Párrafo 2
      doc.text('La información respecto de altura máxima de edificación esta basada en el sistema de agrupamiento', 10, 52);
      doc.text('aislado.', 10, 60);

      // Párrafo 3
      doc.text('Se recomienda consultar la nomenclatura de usos (RES, IND, AV, etc.) en el botón “Usos de Suelo”.', 10, 76);

      // Párrafo 4
      doc.text('Para obtener mayor detalle respecto a condiciones normativas de cada zona, se recomienda hacer', 10, 92);
      doc.text('clic en “Descargar Normativa” para obtener la ordenanza local y modificaciones vigentes si', 10, 100);
      doc.text('corresponde.', 10, 108);

      // Pie de página
      doc.setFontStyle("bold");
      doc.setFontSize(12);
      doc.text('Fuente:', 20, 290);
      doc.setFontStyle("normal");
      doc.text('Plan Regulador Comunal y Ordenanza Local vigente (de la comuna consultada)', 37, 290);

      // Separamos los datos
      for (var i = 0; i < data.length; i++) {
        var reg = data[i]

        var am_cc = reg['am_cc']
        var aminciti = reg['aminciti']
        var building_zone = reg['building_zone']
        var construct = reg['construct']
        var density_type_id = reg['density_type_id']
        var hectarea_inhabitants = reg['hectarea_inhabitants']
        var icinciti = reg['icinciti']
        var id = reg['id']
        var land_ocupation = reg['land_ocupation']
        var osinciti = reg['osinciti']

        // Cambiamos a string los valores que llegan como integer
        am_cc = am_cc.toString()
        aminciti = aminciti.toString()
        building_zone = building_zone.toString()
        //construct = construct.toString()
        density_type_id = density_type_id.toString()
        hectarea_inhabitants = hectarea_inhabitants.toString()
        icinciti = icinciti.toString()
        //id = id.toString()
        //land_ocupation = land_ocupation.toString()
        osinciti = osinciti.toString()

        if (i % 2 == 1) { // impar

          // Agregamos una página
          doc.addPage('a4', 'portrait')

          // Labels columna arriba
          doc.setFontStyle("bold");
          doc.setFontSize(12);
          doc.text('Normativa de Edificación:', 83, 20, null, null, 'right');
          doc.text('Altura Máxima:', 83, 30, null, null, 'right');
          doc.text('Zona:', 83, 40, null, null, 'right');
          doc.text('Uso Permitido:', 83, 50, null, null, 'right');
          doc.text('Constructibilidad:', 83, 60, null, null, 'right');
          doc.text('Ocupación de suelo:', 83, 70, null, null, 'right');
          doc.text('Web:', 83, 80, null, null, 'right');
          doc.text('Densidad:', 83, 90, null, null, 'right');
          doc.text('Densidad Máxima:', 83, 100, null, null, 'right');
          doc.text('Última actualización:', 83, 110, null, null, 'right');
          doc.text('Subdivisión predial mínima m2:', 83, 120, null, null, 'right');

          // Valores columna arriba
          doc.setFontStyle("normal");
          doc.text(building_zone, 85, 20);
          doc.text(aminciti, 85, 30);
          doc.text('null', 85, 40);
          doc.text('null', 85, 50);
          //doc.text(construct, 85, 60);
          doc.text(osinciti, 85, 70);
          doc.text('null', 85, 80);
          doc.text('null', 85, 90);
          doc.text(density_type_id, 85, 100);
          doc.text('null', 85, 110);
          doc.text('null', 85, 120);

          // Pie de página
          doc.setFontStyle("bold");
          doc.setFontSize(12);
          doc.text('Fuente:', 20, 290);
          doc.setFontStyle("normal");
          doc.text('Plan Regulador Comunal y Ordenanza Local vigente (de la comuna consultada)', 37, 290);


        } else { // par

          // Separador
          doc.line(10, 140, 200, 140);

          // Labels columna abajo
          doc.setFontStyle("bold");
          doc.setFontSize(12);
          doc.text('Normativa de Edificación', 83, 160, null, null, 'right');
          doc.text('Altura Máxima:', 83, 170, null, null, 'right');
          doc.text('Zona:', 83, 180, null, null, 'right');
          doc.text('Uso Permitido:', 83, 190, null, null, 'right');
          doc.text('Constructibilidad:', 83, 200, null, null, 'right');
          doc.text('Ocupación de suelo:', 83, 210, null, null, 'right');
          doc.text('Web:', 83, 220, null, null, 'right');
          doc.text('Densidad:', 83, 230, null, null, 'right');
          doc.text('Densidad Máxima:', 83, 240, null, null, 'right');
          doc.text('Última actualización:', 83, 250, null, null, 'right');
          doc.text('Subdivisión predial mínima m2:', 83, 260, null, null, 'right');

          // Valores columna abajo
          doc.setFontStyle("normal");
          doc.text(building_zone, 85, 160);
          doc.text(aminciti, 85, 170);
          doc.text('null', 85, 180);
          doc.text('null', 85, 190);
          //doc.text(construct, 85, 200);
          doc.text(osinciti, 85, 210);
          doc.text('null', 85, 220);
          doc.text('null', 85, 230);
          doc.text(density_type_id, 85, 240);
          doc.text('null', 85, 250);
          doc.text('null', 85, 260);

        } // Cierra else par/impar
      } // Cierra for

      // Descarga el archivo PDF
      doc.save("Reporte_Normativa.pdf");

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
