Congo.namespace('transactions.action_graduated_points');
Congo.namespace('transactions.action_dashboards');

Congo.transactions.config= {
  county_name: '',
  county_id: '',
  layer_type: 'transactions_info',
  property_type_ids: [],
  seller_type_ids: [],
  periods: [],
  years: [],
  from_calculated_value: [],
  to_calculated_value: [],
  legends: []
}


Congo.transactions.action_heatmap = function(){

  init=function(){
    widget =  Congo.dashboards.config.widget;
    Congo.transactions.config.legends =[]
    switch (widget) {
      case 'heat_calculated_value':

        Congo.dashboards.config.style_layer= 'heatmap_transactions_calculated_value';
        Congo.transactions.config.legends.push({'name':'Alto', 'color':'9d2608'});
        Congo.transactions.config.legends.push({'name':'Medio Alto', 'color':'f94710'});
        Congo.transactions.config.legends.push({'name':'Medio', 'color':'fa7c16'});
        Congo.transactions.config.legends.push({'name':'Medio Bajo', 'color':'fda821'});
        Congo.transactions.config.legends.push({'name':'Bajo', 'color':'fcd930'});
        Congo.map_utils.counties();
        $('#layer-name').text('Compraventas - UF');
        break;
      case 'heat_uf_m2_u':
        Congo.dashboards.config.style_layer= 'heatmap_transactions_uf_m2_u';
        Congo.transactions.config.legends.push({'name':'Alto', 'color':'9d2608'});
        Congo.transactions.config.legends.push({'name':'Medio Alto', 'color':'f94710'});
        Congo.transactions.config.legends.push({'name':'Medio', 'color':'fa7c16'});
        Congo.transactions.config.legends.push({'name':'Medio Bajo', 'color':'fda821'});
        Congo.transactions.config.legends.push({'name':'Bajo', 'color':'fcd930'});
        Congo.map_utils.counties();
        $('#layer-name').text('Compraventas - UF M² Útil');
        break;
      case 'heat_cbr_amount':
        Congo.dashboards.config.style_layer= 'heatmap_transactions_amount';
        Congo.transactions.config.legends.push({'name':'Alto', 'color':'9d2608'});
        Congo.transactions.config.legends.push({'name':'Medio Alto', 'color':'f94710'});
        Congo.transactions.config.legends.push({'name':'Medio', 'color':'fa7c16'});
        Congo.transactions.config.legends.push({'name':'Medio Bajo', 'color':'fda821'});
        Congo.transactions.config.legends.push({'name':'Bajo', 'color':'fcd930'});
        Congo.map_utils.counties();
        $('#layer-name').text('Compraventas - Cantidad');
        break;
    }
  }
  return {
    init: init,
  }
}();

transactions_popup = function(id, latlng){

  bimester = Congo.dashboards.config.bimester;
  year = Congo.dashboards.config.year;
  Congo.dashboards.config.row_id = id;
  lat = latlng['lat'];
  lng = latlng['lng'];
  boost = Congo.dashboards.config.boost
  data = {id: id, bimester: bimester, year: year, lat: lat, lng: lng, boost: boost};
  $.ajax({
    type: 'GET',
    url: '/transactions/index.json',
    datatype: 'json',
    data: data,
    success: function(data) {

      // Creamos la tabla con las cabeceras
      $('#cbr_popup_body').append(
        $('<table>', {
          'id': 'cbr_popup_properties',
          'class': 'table table-striped table-hover table-bordered text-light'
        }).append(
          $('<thead>').append(
            $('<tr>').append(
              $('<th>', {
                'text': 'Dirección',
              }),
              $('<th>', {
                'text': 'Tipo de Propiedad',
              }),
              $('<th>', {
                'text': 'Tipo de Vendedor',
              })
            )
          ),
          $('<tbody>', {
            'id': 'cbr_popup_property_items',
          })
        )
      );

      // Agregamos las filas a la tabla
      $.each(data, function(index, info) {

        $('#cbr_popup_property_items').append(
          $('<tr>', {
            'id': 'tr_'+info.id,
          }).append(
            $('<td>', {
              'text': info.address,
            }),
            $('<td>', {
              'text': info.property_types.name,
            }),
            $('<td>', {
              'text': info.seller_types.name,
            })
          )
        );

        // Agregamos la función itemClick
        $('#tr_'+info.id)[0].onclick = function(e) {
          itemClick(e, info);
        }

        // Ocultamos las pestañas y el contenido
        $('#cbr_tab_list').hide()
        $('#cbr_tab_content').hide()

      })

      $('#leaflet_modal_transactions').modal('show');

      // Acciones cuando se cierra el modal del popup
      $('#leaflet_modal_transactions').on('hidden.bs.modal', function(e) {

        // Vuelve a activar el primer tab
        $('#cbr_tab_list a:first-child').tab('show')

        // Elimina la tabla de propiedades y la flecha para volver
        $('#cbr_popup_properties').remove()
        $('#back_to_properties').remove()

      }) // Cierra on hidden
    } // Cierra success
  })// Cierra ajax
  Congo.dashboards.pois();
} // Cierra transactions_popup

function itemClick(e, info) {

      $('.feedback_transaction_id').empty();
      $('.feedback_transaction_id').val(info.id);
  $('#cbr_popup_body').prepend(
    $('<div>', {
      'id': 'back_to_properties',
      'class': 'text-center p-1'
    }).append(
      $('<a>', {
        'href': '#'
      }).append(
        $('<i>', {
          'class': 'fas fa-chevron-up'
        })
      )
    )
  )

  if (!e) var e = window.event; // Get the window event
  e.cancelBubble = true; // IE Stop propagation
  if (e.stopPropagation) e.stopPropagation(); // Other Broswers

  $('#cbr_tab_list').show()
  $('#cbr_tab_content').show()

  $('#cbr_popup_properties').hide()

  $('#popup_info_transactions').empty();

  // Agregamos la información general
  $('#popup_info_transactions').append(
    $('<p>').append(
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Bimestre:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.bimester
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Año:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.year
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Dirección:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.address
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
          'text': info.property_types.name
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Vendedor:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.seller_types.name
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Vendedor:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.seller_name
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Comprador:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.buyer_name
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Foja:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.sheet
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Número:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.number
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Fecha de Inscripció:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.inscription_date
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Departamento:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.department
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Valor UF:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': Math.round(info.calculated_value).toLocaleString()
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Valor UF m2 Útil:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': !isNaN(parseFloat(info.uf_m2_u)) ? parseFloat(info.uf_m2_u).toFixed(1) : "-"
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Valor UF m2 Terreno:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': !isNaN(parseFloat(info.uf_m2_t)) ? parseFloat(info.uf_m2_t).toFixed(1) : "-"
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Superficie Útil:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': Math.round(info.total_surface_building)
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Superficie Terreno:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': Math.round(info.total_surface_terrain)
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Plano:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.blueprint
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Bodegas:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.cellar
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
          'text': info.parkingi
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Rol:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.role
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Rol 1:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.role_1
        }),
      ),
      $('<div>', {
        'class': 'row'
      }).append(
        $('<div>', {
          'class': 'col-md-6 text-right',
          'text': 'Rol 2:'
        }),
        $('<div>', {
          'class': 'col-md-6',
          'text': info.role_2
        }),
      ),
    )
  )

  $('#back_to_properties')[0].onclick = function(e){

    // Vuelve a activar el primer tab
    $('#cbr_tab_list a:first-child').tab('show')

    $('#popup_info_transactions').empty();
    $('#cbr_tab_list').hide()

    // Ocultamos las pestañas y el contenido
    $('#cbr_tab_content').hide()
    $('#cbr_popup_properties').show()

    // Eliminamos el botón volver
    $(this).remove()

  } // Cierra back_to_properties
}; // Cierra itemClick

function transactions_report_pdf(){

  $.ajax({
    type: 'GET',
    url: '/reports/transactions_pdf.json',
    datatype: 'json',
    data: data,
    beforeSend: function() {

      // Deshabilita la interacción con el mapa
      map.dragging.disable();
      map.doubleClickZoom.disable();
      map.scrollWheelZoom.disable();
      document.getElementById('map').style.cursor='default';

      // Muestra el spinner
      $("#report_spinner").show();

      // Deshabilita los botones
      $('.btn').addClass('disabled')
      $('.close').prop('disabled', true);
      $("#time_slider_cbr").data("ionRangeSlider").update({
        block: true
      });

    },
    success: function(data) {

      let build_image_map = new Promise((resolve, reject) => {
        leafletImage(map, function(err, canvas) {
          var img = document.createElement('img');
          var dimensions = map.getSize();
          img.width = dimensions.x;
          img.height = dimensions.y;
          img.src = canvas.toDataURL();
          resolve(img);
        });
      });

      build_image_map.then(function(img) {

        // Habilitar la interacción con el mapa
        map.dragging.enable();
        map.doubleClickZoom.enable();
        map.scrollWheelZoom.enable();
        document.getElementById('map').style.cursor='grab';

        // Oculta el spinner
        $("#report_spinner").hide();

        // Habilita los botones
        $('.btn').removeClass('disabled')
        $('.close').prop('disabled', false);
        $("#time_slider_cbr").data("ionRangeSlider").update({
          block: false,
        });

        data = data['data']

        // Levantamos los datos
        var info = data[0]['info'][0]
        var transactions_count = info['transactions_count']
        var avg_uf = info['average']
        var avg_land = info['avg_lands']
        var avg_build = info['avg_surface_line_build']
        var avg_uf_m2_land = info['avg_uf_m2_land']
        var avg_uf_m2_build = info['avg_uf_m2_u']
        var deviation_uf = info['deviation']
        var deviation_land = info['deviation_lands']
        var deviation_build = info['deviation_surface_line_build']
        var deviation_uf_m2_land = info['deviation_uf_m2_land']
        var deviation_uf_m2_build = info['deviation_uf_m2_u']
        var up_limit_uf = info['li_uf']
        var up_limit_land = info['li_sup_land']
        var up_limit_build = info['li_surface_line_build']
        var up_limit_uf_m2_land = info['li_uf_m2_land']
        var up_limit_uf_m2_build = info['li_uf_m2_u']
        var low_limit_uf = info['ls_uf']
        var low_limit_land = info['ls_sup_land']
        var low_limit_build = info['ls_surface_line_build']
        var low_limit_uf_m2_land = info['ls_uf_m2_land']
        var low_limit_uf_m2_build = info['ls_uf_m2_u']
        var max_val_uf = info['uf_max_value']
        var max_val_land = info['max_lands']
        var max_val_build = info['max_surface_line_build']
        var max_val_uf_m2_land = info['max_uf_m2_land']
        var max_val_uf_m2_build = info['max_uf_m2_u']
        var min_val_uf = info['uf_min_value']
        var min_val_land = info['min_lands']
        var min_val_build = info['min_surface_line_build']
        var min_val_uf_m2_land = info['min_uf_m2_land']
        var min_val_uf_m2_build = info['min_uf_m2_u']

        // Cambiamos a string los valores que llegan como integer
        transactions_count = transactions_count.toString()

        // Creamos el doc
        var doc = new jsPDF();

        doc.page = 1;

        // Pie de página
        function footer() {
          doc.setFontStyle("bold");
          doc.setFontSize(12);
          doc.text('Fuente:', 10, 284);
          doc.setFontStyle("normal");
          doc.text('Compraventas Inscritas en los Conservadores de Bienes Raíces de la Región Metropolitana', 27, 284);
          doc.text('(Santiago, San Miguel, Puente Alto y San Bernardo) y Planchetas de Predios Municipales', 10, 290);
          doc.setFontSize(10);
          doc.text('p. ' + doc.page, 194, 290);
          doc.page++;
        };

        // Título
        doc.setFontStyle("bold");
        doc.setFontSize(22);
        doc.text('Informe de Compraventas', 105, 20, null, null, 'center');

        // Subtítulo
        doc.setFontSize(16);
        doc.text('Información General', 105, 35, null, null, 'center');

        to_year = Congo.dashboards.config.year;
        to_bimester = Congo.dashboards.config.bimester;
        periods = Congo.transactions.config.periods;
        years = Congo.transactions.config.years;

        // Validamos si hay algún filtro aplicado
        if (periods == '') {

          // Calculamos el bimestre de incio a partir del bimetre final
          var bim = to_bimester
          var year = to_year
          for (var i = 0; i < 5; i++) {
            bim = bim - 1
            if (bim < 1) {
              year = year - 1
              bim = 6
            }
          }

          // Periodos Actuales
          doc.setFontSize(12);
          doc.setFontStyle("bold");
          doc.text('Periodos de tiempo seleccionados:', 10, 49);
          doc.setFontStyle("normal");
          doc.text('Desde el '+bim+'° bimestre del '+year+' al '+to_bimester+'° bimestre del '+to_year, 83, 49);

        } else {

          // Periodos Filtrados
          doc.setFontSize(12);
          doc.setFontStyle("bold");
          doc.text('Periodos de tiempo seleccionados:', 10, 49);
          doc.setFontStyle("normal");
          var tab = 83
          for (var i = 0; i < periods.length; i++) {
            doc.text(periods[i]+'/'+years[i]+', ', tab, 49);
            tab = tab + 16
          }

        }

        // Cantidad
        doc.setFontSize(12);
        doc.setFontStyle("bold");
        doc.text('Cantidad de Transacciones:', 10, 57);
        doc.setFontStyle("normal");
        doc.text(transactions_count, 68, 57);

        // Líneas Tabla
        doc.line(10, 65, 200, 65);
        doc.line(10, 75, 200, 75);
        doc.line(10, 85, 200, 85);
        doc.line(10, 95, 200, 95);
        doc.line(10, 105, 200, 105);
        doc.line(10, 115, 200, 115);
        doc.line(10, 125, 200, 125);
        doc.line(10, 135, 200, 135);
        doc.line(10, 65, 10, 135);
        doc.line(200, 65, 200, 135);
        doc.line(45, 65, 45, 135);

        // Columna Ítem
        doc.text('Ítem', 28, 72, null, null, 'center');
        doc.text('Promedio', 13, 82);
        doc.text('Desviación', 13, 92);
        doc.text('Límite Superior', 13, 102);
        doc.text('Límite Inferior', 13, 112);
        doc.text('Valor Máximo', 13, 122);
        doc.text('Valor Mínimo', 13, 132);

        // Columna Precio UF
        doc.text('Precio UF', 62, 72, null, null, 'center');
        doc.text(avg_uf, 62, 82, null, null, 'center');
        doc.text(deviation_uf, 62, 92, null, null, 'center');
        doc.text(up_limit_uf, 62, 102, null, null, 'center');
        doc.text(low_limit_uf, 62, 112, null, null, 'center');
        doc.text(max_val_uf, 62, 122, null, null, 'center');
        doc.text(min_val_uf, 62, 132, null, null, 'center');

        // Columna Terreno
        doc.text('Terreno', 91, 72, null, null, 'center');
        doc.text(avg_land, 91, 82, null, null, 'center');
        doc.text(deviation_land, 91, 92, null, null, 'center');
        doc.text(up_limit_land, 91, 102, null, null, 'center');
        doc.text(low_limit_land, 91, 112, null, null, 'center');
        doc.text(max_val_land, 91, 122, null, null, 'center');
        doc.text(min_val_land, 91, 132, null, null, 'center');

        // Columna Útil
        doc.text('Útil', 120, 72, null, null, 'center');
        doc.text(avg_build, 120, 82, null, null, 'center');
        doc.text(deviation_build, 120, 92, null, null, 'center');
        doc.text(up_limit_build, 120, 102, null, null, 'center');
        doc.text(low_limit_build, 120, 112, null, null, 'center');
        doc.text(max_val_build, 120, 122, null, null, 'center');
        doc.text(min_val_build, 120, 132, null, null, 'center');

        // Columna UF m² Terreno
        doc.text('UF m² Terreno', 149, 72, null, null, 'center');
        doc.text(avg_uf_m2_land, 149, 82, null, null, 'center');
        doc.text(deviation_uf_m2_land, 149, 92, null, null, 'center');
        doc.text(up_limit_uf_m2_land, 149, 102, null, null, 'center');
        doc.text(low_limit_uf_m2_land, 149, 112, null, null, 'center');
        doc.text(max_val_uf_m2_land, 149, 122, null, null, 'center');
        doc.text(min_val_uf_m2_land, 149, 132, null, null, 'center');

        // Columna UF m² Útil
        doc.text('UF m² Útil', 181, 72, null, null, 'center');
        doc.text(avg_uf_m2_build, 181, 82, null, null, 'center');
        doc.text(deviation_uf_m2_build, 181, 92, null, null, 'center');
        doc.text(up_limit_uf_m2_build, 181, 102, null, null, 'center');
        doc.text(low_limit_uf_m2_build, 181, 112, null, null, 'center');
        doc.text(max_val_uf_m2_build, 181, 122, null, null, 'center');
        doc.text(min_val_uf_m2_build, 181, 132, null, null, 'center');

        // Agrega mapa
        img_height = (img.height * 190) / img.width
        doc.addImage(img, 'JPEG', 9, 145, 190, img_height);
        // 55 a 145

        // Agrega leyenda
        map_legends = Congo.transactions.config.legends
        rect_begin = img_height + 149
        for (var i = 0; i < map_legends.length; i++) {
          var leg = map_legends[i]
          var name = leg['name']
          var color = leg['color']

          doc.setDrawColor(0)
          doc.setFillColor(color)
          doc.rect(20, rect_begin, 3, 3, 'F')

          text_begin = rect_begin + 3
          doc.setFontSize(10);
          doc.setFontStyle("normal");
          doc.text(name, 25, text_begin);

          rect_begin = rect_begin + 6
        }

        // Pie de página
        footer()

        // Agregamos un página
        doc.addPage('a4', 'portrait')

        // Pie de página
        footer()

        // Separamos la información
        for (var i = 1; i < data.length; i++) {

          var reg = data[i];
          var title = reg['title'];
          var series = reg['series'];
          var datasets = [];

          // Extraemos las series
          $.each(series, function(a, b){

            // FIXME: Omite el chart Compraventas hasta que lleguen bien los datos
            if (title == 'Compraventas') {

              // var data = b['data']
              //
              // // Separamos las comunas
              // for (var i = 1; i < data.length; i++) {
              //   var reg = data[i];
              //
              //   var label = reg[0]
              //
              //   var name = [];
              //   var count = [];
              //
              //   // Separamos los bimestres de la comuna
              //   for (var a = 1; a < reg.length; a++) {
              //     var bim = reg[a]
              //
              //     var cantidad = bim[0]
              //     var periodo = bim[1]
              //     var año = bim[2]
              //     var nombre = periodo+'/'+año
              //
              //     name.push(nombre)
              //     count.push(cantidad)
              //
              //   } // Cierra for bimestre
              //
              //   if (title == 'Compraventas') { // Line
              //     chart_type = 'line';
              //     datasets.push({
              //       label: label,
              //       data: count,
              //       fill: false,
              //       borderColor: '#58b9e2',
              //       borderWidth: 3,
              //       pointRadius: 0,
              //       pointStyle: 'line',
              //       lineTension: 0,
              //     })
              //   }
              //
              //   chart_data = {
              //     labels: name,
              //     datasets: datasets
              //   }
              //
              // } // Cierra for comunas

            } else {

              var label = b['label']
              var data = b['data']
              var name = [];
              var count = [];
              var name_colour = [];
              var colour;

              // Extraemos los datos de las series
              $.each(data, function(c, d){

                name.push(d['name'])
                count.push(d['count'])

                // Setea los colores dependiendo del label
                if (title == 'Uso' || title == 'Vendedor') {
                  switch (d['name']) {
                    case 'Propietario':
                      colour = '#3498DB'
                      break;
                    case 'Inmobiliaria':
                      colour = '#1ABC9C'
                      break;
                    case 'Empresa':
                      colour = '#F5B041'
                      break;
                    case 'Banco':
                      colour = '#8E44AD'
                      break;
                    case 'Cooperativa':
                      colour = '#EC7063'
                      break;
                    case 'Municipalidad':
                      colour = '#27AE60'
                      break;
                    case 'Sin informacion':
                      colour = '#C0392B'
                      break;
                    case 'Departamento':
                      colour = '#3498DB'
                      break;
                    case 'Casa':
                      colour = '#1ABC9C'
                      break;
                    case 'Estacionamiento':
                      colour = '#DC7633'
                      break;
                    case 'Bodega':
                      colour = '#F5B041'
                      break;
                    case 'Local comercial':
                      colour = '#8E44AD'
                      break;
                    case 'Oficina':
                      colour = '#EC7063'
                      break;
                    case 'Sitio':
                      colour = '#7F8C8D'
                      break;
                    case 'Industria':
                      colour = '#ECF0F1'
                      break;
                    case 'Otro':
                      colour = '#Otro'
                      break;
                    case 'Parcela':
                      colour = '#C0392B'
                      break;
                  }
                  name_colour.push(colour)
                }

              })

              // Guardamos "datasets" y "chart_type"
              if (title == 'Uso') { // Pie
                chart_type = 'pie';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: name_colour,
                })
              }

              if (title == 'Vendedor') { // Pie
                chart_type = 'pie';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: name_colour,
                })
              }

              // FIXME: Omite el chart Compraventas hasta que lleguen bien los datos
              if (title == 'Compraventas') { // Line
                // chart_type = 'line';
                // datasets.push({
                //   label: label,
                //   data: count,
                //   fill: false,
                //   borderColor: '#58b9e2',
                //   borderWidth: 4,
                //   pointRadius: 0,
                //   pointStyle: 'line',
                //   lineTension: 0,
                // })
              }

              if (title == 'PxQ | UF') { // Line
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: '#58b9e2',
                  borderWidth: 4,
                  pointRadius: 0,
                  pointStyle: 'line',
                  lineTension: 0,
                })
              }

              if (title == 'Precio Promedio | UF') { // Line
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: '#58b9e2',
                  borderWidth: 4,
                  pointRadius: 0,
                  pointStyle: 'line',
                  lineTension: 0,
                })
              }

              if (title == 'Superficie Línea Construcción (útil m²) por Bimestre') { // Line
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: '#58b9e2',
                  borderWidth: 4,
                  pointRadius: 0,
                  pointStyle: 'line',
                  lineTension: 0,
                })
              }

              if (title == 'Precio UFm² en Base Útil por Bimestre') { // Line
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: '#58b9e2',
                  borderWidth: 4,
                  pointRadius: 0,
                  pointStyle: 'line',
                  lineTension: 0,
                })
              }

              if (title == 'Superficie Terreno (m²) por Bimestre') { // Line
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: '#58b9e2',
                  borderWidth: 4,
                  pointRadius: 0,
                  pointStyle: 'line',
                  lineTension: 0,
                })
              }

              if (title == 'Precio UFm² en Base Terreno por Bimestre') { // Line
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: '#58b9e2',
                  borderWidth: 4,
                  pointRadius: 0,
                  pointStyle: 'line',
                  lineTension: 0,
                })
              }

              chart_data = {
                labels: name,
                datasets: datasets
              }

            } // Cierra else

          }) // Cierra each series

          // Guardamos "options"
          if (chart_type == 'pie') { // Pie

            var chart_options = {
              animation: false,
              responsive: true,
              title: {
                display: false
              },
              legend: {
                display: true,
                position: 'bottom',
                labels: {
                  fontColor: '#3d4046',
                  fontSize: 12,
                  usePointStyle: true,
                }
              },
              plugins: {
                datalabels: {
                  formatter: (value, ctx) => {
                    // Mustra sólo los valores (en porcentajes) que estén por encima del 3%
                    let sum = 0;
                    let dataArr = ctx.chart.data.datasets[0].data;
                    dataArr.map(data => {
                        sum += data;
                    });
                    let percentage = (value*100 / sum).toFixed(2);
                    if (percentage > 4) {
                      return percentage+'%';
                    } else {
                      return null;
                    }
                  },
                  align: 'end',
                  anchor: 'center',
                  color: 'white',
                  font: {
                    weight: 'bold'
                  },
                  textStrokeColor: '#3d4046',
                  textStrokeWidth: 1,
                  textShadowColor: '#000000',
                  textShadowBlur: 3,
                }
              },
            };

          } else { // Line

            var chart_options = {
              animation: false,
              responsive: true,
              title: {
                display: false
              },
              legend: {
                display: false,
              },
              plugins: {
                datalabels: {
                  formatter: function(value, context) {
                    if (value > 0) {
                      return value.toLocaleString('es-ES')
                    } else {
                      return null
                    }
                  },
                  align: 'start',
                  anchor: 'start',
                  color: '#3d4046',
                  font: {
                    size: 10
                  },
                }
              },
              scales: {
                xAxes: [{
                  stacked: true,
                  ticks: {
                    display: true,
                    fontSize: 10,
                    fontColor: '#3d4046'
                  }
                }],
                yAxes: [{
                  ticks: {
                    callback: function(label, index, labels) {
                      label = label.toLocaleString('es-ES')
                      return label;
                    },
                    beginAtZero: true,
                    display: true,
                    fontSize: 10,
                    fontColor: '#3d4046'
                  },
                }],
              }
            };

          } // Cierra else ("options")

          var chart_settings = {
            type: chart_type,
            data: chart_data,
            options: chart_options
          }

          // FIXME: Omite el chart Compraventas hasta que lleguen bien los datos
          if (title != 'Compraventas') {

          // Creamos y adjuntamos el canvas
          var canvas = document.createElement('canvas');
          canvas.id = 'report-canvas-'+i;
          $('#chart-report'+i).append(canvas);

          var chart_canvas = document.getElementById('report-canvas-'+i).getContext('2d');
          var final_chart = new Chart(chart_canvas, chart_settings);

          var chart = final_chart.toBase64Image();

          if (i % 2 == 1) {

            // Título del gráfico
            doc.setFontSize(16);
            doc.setFontStyle("bold");
            doc.text(title, 105, 20, null, null, 'center');

            // Gráfico
            img_height = (final_chart.height * 190) / final_chart.width
            doc.addImage(chart, 'JPEG', 9, 30, 190, img_height);

          } else {

            // Título del gráfico
            doc.setFontSize(16);
            doc.setFontStyle("bold");
            doc.text(title, 105, 160, null, null, 'center');

            // Gráfico
            img_height = (final_chart.height * 190) / final_chart.width
            doc.addImage(chart, 'JPEG', 9, 170, 190, img_height);

            // Agrega nueva página
            doc.addPage('a4', 'portrait')

            // Pie de página
            footer()

          } // Cierra else impar
          }
        } // Cierra for

        // Descarga el archivo PDF
        doc.save("Informe_Compraventas.pdf");

      }); // Cierra then
    } // Cierra success
  }) // Cierra ajax
} // Cierra transactions_report_pdf

Congo.transactions.action_graduated_points = function(){

  init=function(){
    widget =  Congo.dashboards.config.widget;
    Congo.transactions.config.legends =[]
    switch (widget) {
      case 'cbr_calculated_value':
        Congo.dashboards.config.style_layer= 'transactions_point_graduated_uf';
        Congo.transactions.config.legends.push({'name':'Menor a 2.499', 'color':'b9fc30'});
        Congo.transactions.config.legends.push({'name':'2.500 a 3.999', 'color':'fcd930'});
        Congo.transactions.config.legends.push({'name':'4.000 a 6.499', 'color':'fda821'});
        Congo.transactions.config.legends.push({'name':'6.500 a 10.499', 'color':'fa7c16'});
        Congo.transactions.config.legends.push({'name':'10.500 a 14.999', 'color':'f94710'});
        Congo.transactions.config.legends.push({'name':'Mayor a 15.000', 'color':'9d2608'});
        Congo.map_utils.counties();
        $('#layer-name').text('Compraventas - UF');
        break;
      case 'cbr_uf_m2_u':
        Congo.dashboards.config.style_layer= 'transactions_point_graduated_uf_m2_util';
        Congo.transactions.config.legends.push({'name':'Menor a 26', 'color':'b9fc30'});
        Congo.transactions.config.legends.push({'name':'27 a 52', 'color':'fcd930'});
        Congo.transactions.config.legends.push({'name':'53 a 63', 'color':'fda821'});
        Congo.transactions.config.legends.push({'name':'64 a 82', 'color':'fa7c16'});
        Congo.transactions.config.legends.push({'name':'83 a 101', 'color':'f94710'});
        Congo.transactions.config.legends.push({'name':'Mayor a 102', 'color':'9d2608'});
        Congo.map_utils.counties();
        $('#layer-name').text('Compraventas - UF M² Útil');
        break;
    }
  }
  return {
    init: init,
  }
}();

function maxCard(i){
  $('#chart-container'+i).toggleClass('card-max fixed-top')
}

add_time_slider_cbr = function() {

  if ($('#time_slider_cbr').length == 0) {

    // Agregamos el slider al card de "Filtros Activos"
    $('#filter-body').prepend(
      $('<div>', {
        'id': 'time_slider_cbr_item'
      }).append(
        $("<input>", {
          'id': 'time_slider_cbr'
        }),
        $("<div>", {
          'class': 'dropdown-divider',
        })
      )
    )

    // Levantamos los datos de los periodos
    var slider_periods = Congo.dashboards.config.slider_periods

    // Implementamos ionRangeSlider
    $("#time_slider_cbr").ionRangeSlider({
      skin: 'flat',
      type: 'double',
      grid: false,
      from: slider_periods.length - 6,
      to: slider_periods.length - 1,
      values: slider_periods,
      drag_interval: true,
      min_interval: 6,
      max_interval: 6,
      block: false,
      onFinish: function(data) {

        var data = data.to_value.split("/")
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
} // Cierra add_time_slider_cbr

Congo.transactions.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_transactions = function(){
    county_id = []
    $.each(Congo.dashboards.config.county_id, function(a,b){
       county_id =b;
    })
    to_year = Congo.dashboards.config.year;
    to_bimester = Congo.dashboards.config.bimester;
    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
    property_type_ids = Congo.transactions.config.property_type_ids;
    seller_type_ids = Congo.transactions.config.seller_type_ids;
    periods = Congo.transactions.config.periods;
    years = Congo.transactions.config.years;
    from_calculated_value = Congo.transactions.config.from_calculated_value;
    to_calculated_value = Congo.transactions.config.to_calculated_value;
    type_geometry = Congo.dashboards.config.typeGeometry;
    layer_type = Congo.dashboards.config.layer_type;
    style_layer = Congo.dashboards.config.style_layer;
    boost = Congo.dashboards.config.boost;

    // Sino se realizó la selección muestra un mensaje de alerta
    if (county_id.length == 0 && centerPoint == '' && wkt.length == 0) {

      Congo.dashboards.action_index.empty_selection_alert();

    // Si se realizó la selección, añade los elementos al dashboard
    } else {

      // Creamos el overlay y el time_slider
      Congo.dashboards.action_index.create_overlay_and_filter_card();
      add_time_slider_cbr();

      if (county_id != '') {

        // Agregamos filtro Comuna
        Congo.dashboards.action_index.add_county_filter_item()

        data = {
          to_year: to_year,
          to_period: to_bimester,
          property_type_ids: property_type_ids,
          seller_type_ids: seller_type_ids,
          periods: periods,
          years: years,
          from_calculated_value: from_calculated_value,
          to_calculated_value: to_calculated_value,
          county_id: county_id,
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer
        };

      } else if (centerPoint != '') {

        // Eliminamos filtro comuna
        $('#item-comuna').remove();

        data = {
          to_year: to_year,
          to_period: to_bimester,
          property_type_ids: property_type_ids,
          seller_type_ids: seller_type_ids,
          periods: periods,
          years: years,
          from_calculated_value: from_calculated_value,
          to_calculated_value: to_calculated_value,
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
          to_year: to_year,
          to_period: to_bimester,
          property_type_ids: property_type_ids,
          seller_type_ids: seller_type_ids,
          periods: periods,
          years: years,
          from_calculated_value: from_calculated_value,
          to_calculated_value: to_calculated_value,
          wkt: JSON.stringify(wkt),
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer
        };

      };

 if (boost == true){
               data['boost'] =  boost;
             }
      $.ajax({
        type: 'GET',
        url: '/transactions/transactions_summary.json',
        datatype: 'json',
        data: data,
        beforeSend: function() {

          // Mostramos el spinner y deshabilitamos los botones
          $("#spinner").show();
          $('.btn').addClass('disabled')
          $('.close').prop('disabled', true);
          $("#time_slider_cbr").data("ionRangeSlider").update({
            block: true
          });

          // Establece el nombre de la capa en el navbar
          $('#layer-name').text('Compraventas');

          // Mostramos los iconos de Útiles correspondientes
          $("#boost").show();
          $("#base").show();
          $("#graph").show();
          $("#census").hide();

          // Mostramos el icono de Puntos/Poligonos correspondiente
          $("#type_point").show();
          $("#poly_build").hide();
          $("#vor_dem").hide();
          $("#col-ica").hide();

          // Mostramos el icono de Puntos Proporcionales correspondiente
          $("#prop-prv").hide();
          $("#prop-cbr").show();
          $("#prop-em").hide();

          // Mostramos el icono de Heatmap correspondiente
          $("#heat-prv").hide();
          $("#heat-cbr").show();
          $("#heat-em-dem").hide();

          // Eliminamos los chart-containter de la capa anterior
          $(".chart-container").remove();

          // Mostramos el filtro de la capa y ocultamos los demás
          $('.filter-building-regulations').hide();
          $('.filter-transactions').show();
          $('.filter-projects').hide();
          $('.filter-future-projects').hide();

          // Eliminamos el census_filter y el time_slider de las otras capas
          $('#time_slider_item').remove()
          $('#census_filter').remove()

        },
        success: function(data){

          // Ocultamos el spinner y habilitamos los botones
          $("#spinner").hide();
          $('.btn').removeClass('disabled')
          $('.close').prop('disabled', false);
          bimester = Congo.dashboards.config.bimester;
          year = Congo.dashboards.config.year;
          ts_period = `${bimester}/${year}`;
          slider_periods = Congo.dashboards.config.slider_periods
          from = slider_periods.indexOf(ts_period) - 5 || slider_periods - 6;
          to = slider_periods.indexOf(ts_period) || slider_periods - 1;
          $("#time_slider_cbr").data("ionRangeSlider").update({
            block: false,
            from: from,
            to: to
          });

          // Separamos la información
          for (var i = 0; i < data.length; i++) {

            var reg = data[i];
            var title = reg['title'];
            var series = reg['series'];

            // Creamos el div contenedor
            var chart_container = document.createElement('div');
            chart_container.className = 'chart-container card text-light bg-primary';
            chart_container.id = 'chart-container'+i;

            // Creamos el card-header
            var card_header = document.createElement('div');
            card_header.className = 'card-header pl-3';
            card_header.id = 'header'+i;

            // Creamos el collapse
            var collapse = document.createElement('div');
            collapse.className = 'collapse show';
            collapse.id = 'collapse'+i;

            // Creamos el card-body
            var card_body = document.createElement('div');
            card_body.className = 'card-body';
            card_body.id = 'body'+i;

            // Creamos handle, título y botones
            var card_handle = '<span class="fas fa-arrows-alt handle border border-dark">'
            var card_header_title = '<b>'+title+'</b>'
            var card_min_button = '<button class="close" data-toggle="collapse" data-target="#collapse'+i+'" aria-expanded="true" aria-controls="collapse'+i+'" aria-label="Minimize"><i class="fas fa-window-minimize" style="width: 24px; height: 12px"></i></button>'
            var card_max_button = '<button class="close" id="card-max-'+i+'" onclick="maxCard('+i+')"><i class="fas fa-window-maximize" style="width: 24px; height: 12px"></i></button>'

            // Adjuntamos los elementos
            $('.overlay').append(chart_container);
            $('#chart-container'+i).append(card_header, collapse);
            $('#collapse'+i).append(card_body);
            $('#header'+i).append(card_handle, card_header_title, card_max_button, card_min_button);

            // Información General
            if (title == "Información General") {

              var info = reg['data'];

              // Extraemos y adjuntamos los datos al card-body
              $.each(info, function(y, z){
                name = z['name'];
                count = z['count']
                count = count.toLocaleString('es-ES')
                item = name+': '+count+'<br>';
                $('#body'+i).append(item);
              })

            // Gráficos
            } else {

              var datasets = [];

              // Extraemos las series
              $.each(series, function(a, b){

                if (title == 'Compraventas') {

                  var data = b['data']

                  // Separamos las comunas
                  for (var i = 0; i < data.length; i++) {

                    var reg = data[i];
                    var label = reg[0]
                    var name = [];
                    var count = [];

                    // Separamos los bimestres de la comuna
                    for (var a = 1; a < reg.length; a++) {
                      var bim = reg[a]

                      var cantidad = bim[0]
                      var periodo = bim[1]
                      var año = bim[2]
                      var nombre = periodo+'/'+año

                      name.push(nombre)
                      count.push(cantidad)

                    } // Cierra for bimestre

                    if (title == 'Compraventas') { // Line
                      chart_type = 'line';
                      datasets.push({
                        label: label,
                        data: count,
                        fill: false,
                        borderColor: '#58b9e2',
                        borderWidth: 4,
                        pointBackgroundColor: '#e8ebef',
                        pointRadius: 3,
                        lineTension: 0,
                        pointHoverBackgroundColor: '#e8ebef',
                        pointHoverBorderWidth: 3,
                        pointHitRadius: 5,
                      })
                    }

                    chart_data = {
                      labels: name,
                      datasets: datasets
                    }

                  } // Cierra for comunas

                } else {

                  var label = b['label']
                  var data = b['data']

                  var name = [];
                  var count = [];
                  var id = [];
                  var name_colour = [];
                  var colour;

                  // Extraemos los datos de las series
                  $.each(data, function(c, d){
                    name.push(d['name'])
                    count.push(d['count'])
                    id.push(d['id'])

                    // Setea los colores dependiendo del label
                    if (title == 'Uso' || title == 'Vendedor') {
                      switch (d['name']) {
                        case 'Propietario':
                          colour = '#3498DB'
                          break;
                        case 'Inmobiliaria':
                          colour = '#1ABC9C'
                          break;
                        case 'Empresa':
                          colour = '#F5B041'
                          break;
                        case 'Banco':
                          colour = '#8E44AD'
                          break;
                        case 'Cooperativa':
                          colour = '#EC7063'
                          break;
                        case 'Municipalidad':
                          colour = '#27AE60'
                          break;
                        case 'Sin informacion':
                          colour = '#C0392B'
                          break;
                        case 'Departamento':
                          colour = '#3498DB'
                          break;
                        case 'Casa':
                          colour = '#1ABC9C'
                          break;
                        case 'Estacionamiento':
                          colour = '#DC7633'
                          break;
                        case 'Bodega':
                          colour = '#F5B041'
                          break;
                        case 'Local comercial':
                          colour = '#8E44AD'
                          break;
                        case 'Oficina':
                          colour = '#EC7063'
                          break;
                        case 'Sitio':
                          colour = '#7F8C8D'
                          break;
                        case 'Industria':
                          colour = '#ECF0F1'
                          break;
                        case 'Otro':
                          colour = '#Otro'
                          break;
                        case 'Parcela':
                          colour = '#C0392B'
                          break;
                      }
                      name_colour.push(colour)
                    }

                  })

                  // Guardamos "datasets" y "chart_type"
                  if (title == 'Uso') { // Pie
                    chart_type = 'pie';
                    datasets.push({
                      label: label,
                      data: count,
                      id: id,
                      backgroundColor: name_colour,
                    })
                  }

                  if (title == 'Vendedor') { // Pie
                    chart_type = 'pie';
                    datasets.push({
                      label: label,
                      data: count,
                      id: id,
                      backgroundColor: name_colour,
                    })
                  }

                  if (title == 'PxQ | UF') { // Line
                    chart_type = 'line';
                    datasets.push({
                      label: label,
                      data: count,
                      fill: false,
                      borderColor: '#58b9e2',
                      borderWidth: 4,
                      pointBackgroundColor: '#e8ebef',
                      pointRadius: 3,
                      lineTension: 0,
                      pointHoverBackgroundColor: '#e8ebef',
                      pointHoverBorderWidth: 3,
                      pointHitRadius: 5,
                    })
                  }

                  if (title == 'Precio Promedio | UF') { // Line
                    chart_type = 'line';
                    datasets.push({
                      label: label,
                      data: count,
                      fill: false,
                      borderColor: '#58b9e2',
                      borderWidth: 4,
                      pointBackgroundColor: '#e8ebef',
                      pointRadius: 3,
                      lineTension: 0,
                      pointHoverBackgroundColor: '#e8ebef',
                      pointHoverBorderWidth: 3,
                      pointHitRadius: 5,
                    })
                  }

                  if (title == 'Precio Promedio | UFm² Útil') { // Line
                    chart_type = 'line';
                    datasets.push({
                      label: label,
                      data: count,
                      fill: false,
                      borderColor: '#58b9e2',
                      borderWidth: 4,
                      pointBackgroundColor: '#e8ebef',
                      pointRadius: 3,
                      lineTension: 0,
                      pointHoverBackgroundColor: '#e8ebef',
                      pointHoverBorderWidth: 3,
                      pointHitRadius: 5,
                    })
                  }

                  if (title == 'Compraventas por Rango Precio') { // Bar
                    chart_type = 'bar';
                    datasets.push({
                      label: label,
                      data: count,
                      backgroundColor: '#58b9e2',
                    })
                  }

                  chart_data = {
                    labels: name,
                    datasets: datasets
                  }

                }

              })

              // Guardamos "options"
              if (chart_type == 'bar') { // Bar

                var chart_options = {
                  onClick: function(c, i) {

                    // Almacena los valores del chart
                    var x_tick = this.data.labels[i[0]._index];
                    var title = this.options.title.text;

                    // Crea el filtro
                    var filter_item = document.createElement('div');
                    filter_item.className = 'filter-transactions text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split(" ").join("").split(".").join("");
                    filter_item.id = 'item-'+filter_item_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    var text_item = title+': '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id).length == 0) {

                      // Almacena la variable global dependiendo del chart
                      var filter_item_id_split = filter_item_id.split("-");
                      Congo.transactions.config.from_calculated_value.push(filter_item_id_split[0]);
                      Congo.transactions.config.to_calculated_value.push(filter_item_id_split[1]);

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();
                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {
                      var active_item_from = Congo.transactions.config.from_calculated_value;
                      var active_item_to = Congo.transactions.config.to_calculated_value;

                      var item_full_id = $('#item-'+filter_item_id).attr('id');

                      item_full_id = item_full_id.split("-");
                      var from_item_id = item_full_id[1];
                      var to_item_id = item_full_id[2];

                      var active_item_from_updated = $.grep(active_item_from, function(n, i) {
                        return n != from_item_id;
                      });

                      var active_item_to_updated = $.grep(active_item_to, function(n, i) {
                        return n != to_item_id;
                      });

                      Congo.transactions.config.from_calculated_value = active_item_from_updated;
                      Congo.transactions.config.to_calculated_value = active_item_to_updated;

                      $('#item-'+filter_item_id).remove();
                      Congo.map_utils.counties();

                    });

                  }, // Cierra onClick function
                  responsive: true,
                  title: {
                    display: false,
                    text: title
                  },
                  legend: {
                    display: false,
                  },
                  tooltips: {
                    callbacks: {
                      label: function(tooltipItem, data) {
                        var dataset = data.datasets[tooltipItem.datasetIndex];
                        var currentValue = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                        return currentValue.toLocaleString('es-ES');
                      }
                    }
                  },
                  plugins: {
                    datalabels: {
                      display: false,
                    },
                  },
                  scales: {
                    xAxes: [{
                      stacked: true,
                      ticks: {
                        autoSkip: false,
                        maxRotation: 30,
                        fontColor: '#e8ebef'
                      },
                      gridLines: {
                        color: "#2c2e34"
                      },
                    }],
                    yAxes: [{
                      stacked: true,
                        ticks: {
                          callback: function(label, index, labels) {
                            label = label.toLocaleString('es-ES')
                            return label;
                          },
                        beginAtZero: true,
                        fontColor: '#e8ebef'
                      },
                      gridLines: {
                        color: "#2c2e34"
                      },
                    }],
                  }
                };

              } else if (chart_type == 'pie') { // Pie

                var chart_options = {
                  onClick: function(c, i) {

                    // Almacena los valores del chart
                    var x_tick = this.data.labels[i[0]._index];
                    var x_tick_id = this.data.datasets[0].id[i[0]._index];
                    var title = this.options.title.text;

                    // Crea el filtro
                    var filter_item = document.createElement('div');
                    filter_item.className = 'filter-transactions text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split(" ").join("_");
                    filter_item.id = 'item-'+filter_item_id+'-'+x_tick_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    var text_item = title+': '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id+'-'+x_tick_id).length == 0) {

                      // Almacena la variable global dependiendo del chart
                      if (title == 'Uso') {
                        Congo.transactions.config.property_type_ids.push(x_tick_id);
                      } else {
                        Congo.transactions.config.seller_type_ids.push(x_tick_id);
                      };

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id+'-'+x_tick_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();
                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {

                      if (title == 'Uso') {
                        var active_items = Congo.transactions.config.property_type_ids;
                      } else {
                        var active_items = Congo.transactions.config.seller_type_ids;
                      };

                      var item_full_id = $('#item-'+filter_item_id+'-'+x_tick_id).attr('id');
                      item_full_id = item_full_id.split("-")
                      var item_id = item_full_id[2]

                      var active_items_updated = $.grep(active_items, function(n, i) {
                        return n != item_id;
                      });

                      if (title == 'Uso') {
                        Congo.transactions.config.property_type_ids = active_items_updated;
                      } else {
                        Congo.transactions.config.seller_type_ids = active_items_updated;
                      };

                      $('#item-'+filter_item_id+'-'+x_tick_id).remove();
                      Congo.map_utils.counties();
                    });

                  }, // Cierra onClick function
                  responsive: true,
                  title: {
                    display: false,
                    text: title
                  },
                  legend: {
                    display: false,
                  },
                  tooltips: {
                    callbacks: {
                      title: function(tooltipItem, data) {
                        return data.labels[tooltipItem[0].index];
                      },
                      label: function(tooltipItem, data) {
                        // Obtenemos los datos
                        var dataset = data.datasets[tooltipItem.datasetIndex];
                        // Calcula el total
                        var total = dataset.data.reduce(function(previousValue, currentValue, currentIndex, array) {
                          return previousValue + currentValue;
                        });
                        // Obtenemos el valor de los elementos actuales
                        var currentValue = dataset.data[tooltipItem.index];
                        // Calculamos el porcentaje
                        var precentage = ((currentValue/total) * 100).toFixed(2)
                        return precentage + "%";
                      }
                    }
                  },
                  plugins: {
                    datalabels: {
                      formatter: (value, ctx) => {
                        // Mustra sólo los labels cuyo valor sea mayor al 4%
                        let sum = 0;
                        var label = ctx.chart.data.labels[ctx.dataIndex]
                        let dataArr = ctx.chart.data.datasets[0].data;
                        dataArr.map(data => {
                            sum += data;
                        });
                        let percentage = (value*100 / sum).toFixed(2);
                        if (percentage > 4) {
                          return label;
                        } else {
                          return null;
                        }
                      },
                      font: {
                        size: 11,
                      },
                      textStrokeColor: '#616A6B',
                      color: '#e8ebef',
                      textStrokeWidth: 1,
                      textShadowColor: '#000000',
                      textShadowBlur: 2,
                      align: 'end',
                    }
                  },
                };

              } else { // Line

                var chart_options = {
                  onClick: function(c, i) {

                    // Almacena los valores del chart
                    var x_tick = this.data.labels[i[0]._index];

                    // Crea el filtro
                    var filter_item = document.createElement('div');
                    filter_item.className = 'filter-transactions text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split("/").join("-");
                    filter_item.id = 'item-'+filter_item_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    var text_item = 'Periodo: '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id).length == 0) {

                      // Almacena la variable global
                      var periods_years = x_tick.split("/");
                      Congo.transactions.config.periods.push(periods_years[0]);
                      if (title =! 'Compraventas') {
                        Congo.transactions.config.years.push(20+periods_years[1]);
                      } else {
                        Congo.transactions.config.years.push(periods_years[1]);
                      }

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();
                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {

                      var active_periods = Congo.transactions.config.periods;
                      var active_years = Congo.transactions.config.years;

                      var item_full_id = $('#item-'+filter_item_id).attr('id');

                      item_full_id = item_full_id.split("-");
                      var period_id = item_full_id[1];
                      var year_id = item_full_id[2];

                      var periods_updated = $.grep(active_periods, function(n, i) {
                        return n != period_id;
                      });

                      var period_position = active_periods.indexOf(period_id);

                      var years_updated = $.grep(active_years, function(n, i) {
                        return i != period_position;
                      });

                      Congo.transactions.config.periods = periods_updated;
                      Congo.transactions.config.years = years_updated;

                      $('#item-'+filter_item_id).remove();
                      Congo.map_utils.counties();

                    });

                  }, // Cierra onClick function
                  responsive: true,
                  title: {
                    display: false,
                    text: title
                  },
                  legend: {
                    display: false,
                  },
                  plugins: {
                    datalabels: {
                      display: false,
                    },
                  },
                  tooltips: {
                    callbacks: {
                      label: function(tooltipItem, data) {
                        var dataset = data.datasets[tooltipItem.datasetIndex];
                        var currentValue = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                        return currentValue.toLocaleString('es-ES');
                      }
                    },
                    mode: 'point',
                  },
                  hover: {
                    mode: 'point',
                  },
                  scales: {
                    xAxes: [{
                      ticks: {
                        fontColor: '#e8ebef'
                      },
                      gridLines: {
                        color: "#2c2e34"
                      },
                    }],
                    yAxes: [{
                      ticks: {
                        callback: function(label, index, labels) {
                          label = label.toLocaleString('es-ES')
                          return label;
                        },
                        beginAtZero: true,
                        fontColor: '#e8ebef'
                      },
                      gridLines: {
                        color: "#2c2e34"
                      },
                    }],
                  }
                };

              } // Cierra else ("options")

              var chart_settings = {
                type: chart_type,
                data: chart_data,
                options: chart_options
              }

              // Creamos y adjuntamos el canvas
              var canvas = document.createElement('canvas');
              canvas.id = 'canvas'+i;
              $('#body'+i).append(canvas);

              var chart_canvas = document.getElementById('canvas'+i).getContext('2d');
              var final_chart = new Chart(chart_canvas, chart_settings);

            } // Cierra if
          } // Cierra for
        } // Cierra success
      }) // Cierra ajax
    } // Cierra if alert
  } // Cierra indicator_transactions

  return {
    init: init,
    indicator_transactions: indicator_transactions
  }
}();
