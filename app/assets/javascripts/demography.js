Congo.namespace('demography.action_dashboards');

Congo.demography.config = {
  legends: [],
  census_source: 1,
}

function changeCensusSource() {
  var census_selector = document.getElementById("census_selector");
  var selectedValue = census_selector.options[census_selector.selectedIndex].value;
  Congo.demography.config.census_source = selectedValue
  Congo.map_utils.counties();
}

Congo.demography.action_dashboards = function(){
  init=function(){
    Congo.map_utils.init();
  }

  demography_report_pdf = function() {

    county_id = [];
    $.each(Congo.dashboards.config.county_id, function(a, b) {
      county_id = b;
    })

    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
    type_geometry = Congo.dashboards.config.typeGeometry;
    layer_type = Congo.dashboards.config.layer_type;
    style_layer = Congo.dashboards.config.style_layer;
    census_source_id = Congo.demography.config.census_source;

    if (county_id != '') {

      data = {
        county_id: county_id,
        type_geometry: type_geometry,
        layer_type: layer_type,
        style_layer: style_layer,
        census_source_id: census_source_id
      };

    } else if (centerPoint != '') {

      data = {
        centerpt: centerPoint,
        radius: radius,
        type_geometry: type_geometry,
        layer_type: layer_type,
        style_layer: style_layer,
        census_source_id: census_source_id
      };

    } else {

      data = {
        wkt: JSON.stringify(wkt),
        type_geometry: type_geometry,
        layer_type: layer_type,
        style_layer: style_layer,
        census_source_id: census_source_id
      };
    };

    Number.prototype.format = function(n, x, s, c) {
          var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\D' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~n));

          return (c ? num.replace('.', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || ','));
    };
    $.ajax({
      type: 'GET',
      url: '/demography/general.json',
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

          // Creamos el doc
          var doc = new jsPDF();

          doc.page = 1;

          // Pie de página
          function footer() {


            doc.setFontSize(10);
            doc.setFontStyle("bold");
            doc.text('MILES DE PESOS', 10, 280, null, null, 'left');
            doc.text('FUENTE: CENSO 2017 | ENCUESTA PRESUPUESTO FAMILIARES', 10, 285, null, null, 'left');
            doc.text('2017 | ESTIMACIÓN GSE OCUC PUC ', 10, 290, null, null, 'left');

            doc.text('p. ' + doc.page, 194, 290);
            doc.page++;
          };

          // Título
          doc.setFontStyle("bold");
          doc.setFontSize(22);
          doc.text('Informe de Demografía y Gasto', 105, 20, null, null, 'center');

          // Subtítulo
          doc.setFontSize(16);
          doc.text('Información General', 105, 35, null, null, 'center');

          // Agrega mapa
          img_height = (img.height * 190) / img.width
          doc.addImage(img, 'JPEG', 9, 55, 190, img_height);

          // Agrega leyenda
          map_legends = Congo.demography.config.legends
          rect_begin = img_height + 59
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

          // Agregamos un página
          doc.addPage('a4', 'portrait')

          // Pie de página
          footer()

          // Gráficos
          for (var i = 2; i < data[0].length; i++) {

            var reg = data[0][i];
            var title = reg['title'];
            var series = reg['data']
            var datasets = [];
            var name = [];
            var count = [];

            // Extraemos los datos de las series
            $.each(series, function(c, d) {
              name.push(d['name'])
              count.push(d['count'])
            })

            // Guardamos "datasets" y "chart_type"
            chart_type = 'pie';
            datasets.push({
              data: count,
              backgroundColor: [
                'rgb(39,174,96)',
                'rgb(231,76,60)',
                'rgb(211,84,0)',
                'rgb(41,128,185)',
                'rgb(241,196,15)',
                'rgb(142,68,173)',
                'rgb(192,57,43)',
                'rgb(243,156,18)',
              ],
            })

            chart_data = {
              labels: name,
              datasets: datasets
            }

            // Guardamos "options"
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
                  color: '#FFFFFF',
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

            var chart_settings = {
              type: chart_type,
              data: chart_data,
              options: chart_options
            }

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
              doc.text(title, 105, 160, null, null, 'center');

              // Gráfico
              img_height = (final_chart.height * 190) / final_chart.width
              doc.addImage(chart, 'JPEG', 9, 170, 190, img_height);

              // Agrega nueva página
              doc.addPage('a4', 'portrait')

              // Pie de página
              footer()

            } else {

              // Título del gráfico
              doc.setFontSize(16);
              doc.setFontStyle("bold");
              doc.text(title, 105, 20, null, null, 'center');

              // Gráfico
              img_height = (final_chart.height * 190) / final_chart.width
              doc.addImage(chart, 'JPEG', 9, 30, 190, img_height);

            } // Cierra else impar
          } // Cierra for

          doc.addPage('a4', 'portrait')

          // Cantidad
          doc.setFontSize(16);
          doc.setFontStyle("bold");
          doc.text('GASTO MENSUAL E INGRESO PROMEDIO', 10, 25, null, null, 'left');
          doc.setFontSize(10);
          doc.setFontStyle("normal");

          gse = data[1];
          sum_expenses = data[2][0];
          houses = data[3][0];
          incomes = data[4][0];

          // Líneas Tabla
          doc.line(10, 45, 200, 45);
          doc.line(10, 55, 200, 55);
          doc.line(10, 65, 200, 65);
          doc.line(10, 75, 200, 75);
          doc.line(10, 85, 200, 85);
          doc.line(10, 95, 200, 95);
          doc.line(10, 105, 200, 105);
          doc.line(10, 115, 200, 115);
          doc.line(10, 125, 200, 125);
          doc.line(10, 135, 200, 135);
          doc.line(10, 145, 200, 145);
          doc.line(10, 155, 200, 155);
          doc.line(10, 165, 200, 165);
          doc.line(10, 175, 200, 175);
          doc.line(10, 185, 200, 185);
          doc.line(10, 195, 200, 195);
          doc.line(10, 205, 200, 205);
          doc.line(180, 45, 180, 205);

          // Columna Ítem
          doc.setFontType('bold');
          var spos = 18
          var epos = 52
          doc.text('ÍTEM', spos, epos, null, null, 'center');
          spos = spos + 85
          doc.text('ABC1', spos, epos, null, null, 'center');
          spos = spos + 18
          doc.text('C2', spos, epos, null, null, 'center');
          spos = spos + 18
          doc.text('C3', spos, epos, null, null, 'center');
          spos = spos + 18
          doc.text('D', spos, epos, null, null, 'center');
          spos = spos + 18
          doc.text('E', spos, epos, null, null, 'center');
          spos = spos + 18
          doc.text('TOTAL',spos, epos, null, null, 'center');
          spos = 12
          epos = 62
          doc.setFontType('normal');

          for (var i = 0, len = gse.length; i < len; i++) {
            doc.text(gse[i]['name'], spos, epos);
            spos = spos + 90
            doc.text(gse[i]['abc1'].format(0,3,'.').toString(), spos, epos, null, null, 'right');
            spos = spos + 18
            doc.text(gse[i]['c2'].format(0,3,'.').toString(), spos, epos, null, null, 'right');
            spos = spos + 18
            doc.text(gse[i]['c3'].format(0,3,'.').toString(), spos, epos, null, null, 'right');
            spos = spos + 18
            doc.text(gse[i]['d'].format(0,3,'.').toString(), spos, epos, null, null, 'right');
            spos = spos + 18
            doc.text(gse[i]['e'].format(0,3,'.').toString(), spos, epos, null, null, 'right');
            spos = spos + 18
            doc.setFontType('bold');
            doc.text(parseFloat(gse[i]['total_expenses']).format(0,3,'.').toString(), spos, epos, null, null, 'right');
            doc.setFontType('normal');
            spos = 12
            epos = epos + 10
          }

          // Totales
          spos = 18
          epos = epos + 10
          doc.setFontType('bold');
          doc.text('Totales', spos, 182, null, null, 'center');
          spos = spos + 85
          doc.text(parseFloat(sum_expenses['abc1']).format(0,3,'.').toString(), spos, 182, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(sum_expenses['c2']).format(0,3,'.').toString(), spos, 182, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(sum_expenses['c3']).format(0,3,'.').toString(), spos, 182, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(sum_expenses['d']).format(0,3,'.').toString(), spos, 182, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(sum_expenses['e']).format(0,3,'.').toString(), spos, 182, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(sum_expenses['total_sum_expenses']).format(0,3,'.').toString(), spos, 182, null, null, 'right');

          spos = 18
          epos = epos + 10
          // Hogares
          doc.text('Hogares', spos, 192, null, null, 'center');
          spos = spos + 85
          doc.text(parseFloat(houses['total_house_abc1']).format(0,3,'.').toString(), spos, 192, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(houses['total_house_c2']).format(0,3,'.').toString(), spos, 192, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(houses['total_house_c3']).format(0,3,'.').toString(), spos, 192, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(houses['total_house_d']).format(0,3,'.').toString(), spos, 192, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(houses['total_house_e']).format(0,3,'.').toString(), spos, 192, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(houses['total_houses']).format(0,3,'.').toString(), spos, 192, null, null, 'right');
          spos = 18
          epos = epos + 10
          // Ingresos
          doc.text('Ingresos', spos, 202, null, null, 'center');
          spos = spos + 85
          doc.text(parseFloat(incomes['abc1']).format(0,3,'.').toString(), spos, 202, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(incomes['c2']).format(0,3,'.').toString(), spos, 202, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(incomes['c3']).format(0,3,'.').toString(), spos, 202, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(incomes['d']).format(0,3,'.').toString(), spos, 202, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(incomes['e']).format(0,3,'.').toString(), spos, 202, null, null, 'right');
          spos = spos + 18
          doc.text(parseFloat(incomes['weighted_average']).format(0,3,'.').toString(), spos, 202, null, null, 'right');

          footer()
          // Descarga el archivo PDF
          doc.save("Informe_DemografíaYGasto.pdf");

        }); // Cierra then
      } // Cierra success
    }) // Cierra ajax
  } // Cierra demography_report_pdf

  indicator_demography = function(){
    county_id = [];
    $.each(Congo.dashboards.config.county_id, function(a,b){
      county_id =b;
    })
    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
    type_geometry = Congo.dashboards.config.typeGeometry;
    layer_type = Congo.dashboards.config.layer_type;
    style_layer = Congo.dashboards.config.style_layer;
    census_source_id = Congo.demography.config.census_source;

    // Creamos el overlay
    Congo.dashboards.action_index.create_overlay_and_filter_card();

    if (county_id != '') {

      data = {
        county_id: county_id,
        type_geometry: type_geometry,
        layer_type: layer_type,
        style_layer: style_layer,
        census_source_id: census_source_id
      };

    } else if (centerPoint != '') {

      data = {
        centerpt: centerPoint,
        radius: radius,
        type_geometry: type_geometry,
        layer_type: layer_type,
        style_layer: style_layer,
        census_source_id: census_source_id
      };

    } else {

      data = {
        wkt: JSON.stringify(wkt),
        type_geometry: type_geometry,
        layer_type: layer_type,
        style_layer: style_layer,
        census_source_id: census_source_id
      };

    };
    //Legends
    Congo.demography.config.legends = [];

    Congo.demography.config.legends.push({'name':'ABC1', 'color':'004b99'});
    Congo.demography.config.legends.push({'name':'C2', 'color':'3b8ea5'});
    Congo.demography.config.legends.push({'name':'C3', 'color':'f5ee9e'});
    Congo.demography.config.legends.push({'name':'D', 'color':'f49e4c'});
    Congo.demography.config.legends.push({'name':'E', 'color':'ab3428'});

    $.ajax({
      type: 'GET',
      url: '/demography/general.json',
      datatype: 'json',
      data: data,
      beforeSend: function() {

        // Mostramos el spinner y deshabilitamos los botones
        $("#spinner").show();
        $('.btn').addClass('disabled')
        $('.close').prop('disabled', true);

        // Establece el nombre de la capa en el navbar
        $('#layer-name').text('DEMOGRAFÍA Y GASTO');

        // Mostramos los iconos de Útiles correspondientes
        $("#boost").hide();
        $("#base").hide();
        $("#graph").hide();
        $("#census").show();

        // Mostramos el icono de Puntos/Poligonos correspondiente
        $("#type_point").hide();
        $("#poly_build").hide();
        $("#vor_dem").show();
        $("#col-ica").hide();

        // Mostramos el icono de Puntos Proporcionales correspondiente
        $("#prop-prv").hide();
        $("#prop-cbr").hide();
        $("#prop-em").hide();

        // Mostramos el icono de Heatmap correspondiente
        $("#heat-prv").hide();
        $("#heat-cbr").hide();
        $("#heat-em-dem").hide();

        //Ocultamos KML
        $("#kml").hide();
        // Eliminamos los chart-containter de la capa anterior
        $(".chart-container").remove();

        // Mostramos el filtro de la capa y ocultamos los demás
        $('.filter-building-regulations').hide();
        $('.filter-transactions').hide();
        $('.filter-projects').hide();
        $('.filter-future-projects').hide();

        // Eliminamos los time_slider
        $('#time_slider_cbr_item').remove()
        $('#time_slider_item').remove()

      },
      success: function(data) {

        data = data[0]
        // Ocultamos el spinner y habilitamos los botones
        $("#spinner").hide();
        $('.btn').removeClass('disabled')
        $('.close').prop('disabled', false);

        // Separamos la información
        for (var i = 0; i < data.length; i++) {

          var reg = data[i];
          var title = reg['title'];

          if (title == 'Variable') {

            if ($('#census_filter').length == 0) {
              // Agregamos el select al card de "Filtros Activos"
              $('#filter-body').prepend(
                $("<div>", {
                  'id': 'census_filter',
                }).append(
                  $('<select>', {
                    'id': 'census_selector',
                    'class': 'form-control form-control-sm',
                    'onchange': 'changeCensusSource();',
                  }).append(
                    $("<option>", {
                      'value': '1',
                      'text': 'Censo 2017'
                    }),
                    $("<option>", {
                      'value': '2',
                      'text': 'Censo 2012',
                    }),
                  ),
                  $("<div>", {
                    'class': 'dropdown-divider',
                  })
                )
              )

            } // Cierra if length

          } else {

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

            // Resumen
            if (title == 'Resumen') {

              var info = reg['data'];

              // Extraemos y adjuntamos los datos al card-body
              $.each(info, function(y, z) {
                name = z['name'];
                count = z['count']
                count = count.toLocaleString('es-ES')
                item = name + ': ' + count + '<br>';
                $('#body' + i).append(item);
              })

              // Gráficos
            } else {

              var info = reg['data']
              var datasets = [];
              var name = [];
              var count = [];

              // Extraemos los datos de las series
              $.each(info, function(c, d){
                name.push(d['name'])
                count.push(d['count'])
              })

              // Guardamos "datasets" y "chart_type"
              chart_type = 'pie';
              datasets.push({
                data: count,
                backgroundColor: [
                  'rgb(39,174,96)',
                  'rgb(231,76,60)',
                  'rgb(211,84,0)',
                  'rgb(41,128,185)',
                  'rgb(241,196,15)',
                  'rgb(142,68,173)',
                  'rgb(192,57,43)',
                  'rgb(243,156,18)',
                ],
              })

              chart_data = {
                labels: name,
                datasets: datasets
              }

              // Guardamos "options"
              var chart_options = {
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

            } // Cierra else gráficos
          } // Cierra if Variable
        } // Cierra for
      } // Cierra success
    }) // Cierra ajax
  } // Cierra indicator_demography
  return {
    init: init,
    indicator_demography: indicator_demography
  }
}();
