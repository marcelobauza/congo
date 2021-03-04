Congo.namespace('rent_indicators.action_dashboards');

Congo.rent_indicators.config = {
  nId: '',
  county_name: '',
  county_id: '',
  layer_type: 'rent_indicators_info',
  project_status_ids: [],
  project_type_ids: [],
  mix_ids: [],
  periods: [],
  years: [],
  from_floor: [],
  to_floor: [],
  from_uf_value: [],
  to_uf_value: [],
  project_agency_ids: [],
  legends: [],
  selection_type: ''
}

var ica_pdf_ajax;

function containsObject(obj, list) {
  var i;
  for (i = 0; i < list.length; i++) {
    if (list[i].label == obj.label) {
      return true;
    }
  }
  return false;
}

function rent_indicators_report_pdf() {

  selection_type = Congo.rent_indicators.config.selection_type
  to_year = Congo.dashboards.config.year;
  to_bimester = Congo.dashboards.config.bimester;
  map_legends = Congo.rent_indicators.config.legends
  nId = Congo.rent_indicators.config.nId;

  var data = {
    to_year: to_year,
    to_period: to_bimester,
    id: nId
  }

  if (ica_pdf_ajax && ica_pdf_ajax.readyState != 4) {
    ica_pdf_ajax.abort();
  }

  ica_pdf_ajax = $.ajax({
    type: 'GET',
    url: '/rent_indicators/rent_indicators_summary.json',
    datatype: 'json',
    data: data,
    beforeSend: function() {

      // Muestra el spinner y deshabilita la interacción con el mapa
      $("#report_spinner").show();
      map.dragging.disable();
      map.doubleClickZoom.disable();
      map.scrollWheelZoom.disable();
      document.getElementById('map').style.cursor='default';

    },
    success: function(data) {

      console.log('Datos PDF:');
      console.log(data);

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

        // Oculta el spinner y habilitar la interacción con el mapa
        $("#report_spinner").hide();
        map.dragging.enable();
        map.doubleClickZoom.enable();
        map.scrollWheelZoom.enable();
        document.getElementById('map').style.cursor='grab';

        // Creamos el doc
        var doc = new jsPDF();

        doc.page = 1;

        // Pie de página
        function footer() {
          doc.setFontStyle("bold");
          doc.setFontSize(12);
          doc.text('Fuente:', 20, 290);
          doc.setFontStyle("normal");
          doc.text('Inciti - IEUT Pontificia Universidad Católica de Chile', 37, 290);
          doc.setFontSize(10);
          doc.text('p. ' + doc.page, 194, 290);
          doc.page++;
        };

        // Título
        doc.setFontStyle("bold");
        doc.setFontSize(22);
        doc.text('Informe de Indicadores Claves de Arriendo', 105, 20, null, null, 'center');

        // Subtítulo
        doc.setFontSize(16);
        doc.text('Información General', 105, 35, null, null, 'center');

        // Agrega resumen
        var summary = data[0]['data']

        doc.setFontSize(12);
        doc.text(20, 45, 'Resumen')

        doc.setFontSize(10);
        doc.setFontStyle("normal");
        var x_pos = 55
        for (var i = 0; i < summary.length; i++) {
          var item = summary[i]
          doc.text(20, x_pos, item['name'] + ': ' + item['count'])
          x_pos += 5
        }

        // Agrega mapa
        x_pos += 5
        doc.setFontSize(12);
        doc.setFontStyle("bold");
        doc.text(20, x_pos, selection_type)

        x_pos += 5
        img_height = (img.height * 190) / img.width
        doc.addImage(img, 'JPEG', 9, x_pos, 190, img_height);

        // Agrega leyenda
        rect_begin = x_pos + img_height + 5
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

          rect_begin += 6
        }

        // // Validamos si hay algún filtro aplicado
        // if (periods == '') {
        //
        //   // Periodo Actual
        //   doc.setFontSize(12);
        //   doc.setFontStyle("bold");
        //   doc.text('Periodo de tiempo seleccionado:', 10, 49);
        //   doc.setFontStyle("normal");
        //   doc.text(to_bimester + '° bimestre del ' + to_year, 78, 49);
        //
        // } else {
        //
        //   // Periodos Filtrados
        //   doc.setFontSize(12);
        //   doc.setFontStyle("bold");
        //   doc.text('Periodos de tiempo seleccionados:', 10, 49);
        //   doc.setFontStyle("normal");
        //   var tab = 83
        //   for (var i = 0; i < periods.length; i++) {
        //     doc.text(periods[i] + '/' + years[i] + ', ', tab, 49);
        //     tab = tab + 16
        //   }
        //
        // }

        // Pie de página
        footer()

        // Agrega nueva página
        doc.addPage('a4', 'portrait')

        // Pie de página
        footer()

        for (var i = 1; i < data.length; i++) {

          var reg = data[i];
          var title = reg['title'];
          var series = reg['series'];
          var datasets = [];
          var serie_colour;

          // Extraemos las series
          $.each(series, function(a, b) {

            var label = b['label']
            var data = b['data']

            if (a == 0) {
              position_y_axis = 'right-y-axis'
            } else {
              position_y_axis = 'left-y-axis'
            }

            // Setea los colores dependiendo de la serie
            if (title == 'Superficie' || title == 'Precio UF' || title == 'Precio UFm2' || title == 'Vacancia | Rentabilidad') {
              switch (label) {
                case 'Arriendo':
                case 'Vacancia':
                  serie_colour = '#ff0000'
                  break;
                case 'Venta':
                case 'Rentabilidad':
                  serie_colour = '#5dceaf'
                  break;
              }
            }

            var name = [];
            var count = [];
            var id = [];
            var name_colour = [];
            var colour;

            // Extraemos los datos de las series
            $.each(data, function(c, d) {
              name.push(d['name'])
              count.push(d['count'])
              id.push(d['id'])

              // Setea los colores dependiendo del label
              if (title == 'Distribución Programas') {
                switch (d['name']) {
                  case '1|1':
                    colour = '#4e67c8'
                    break;
                  case '2|1':
                    colour = '#5eccf3'
                    break;
                  case '2|2':
                    colour = '#a7ea52'
                    break;
                  case '3|1':
                    colour = '#5dceaf'
                    break;
                  case '3|2':
                    colour = '#ff8021'
                    break;
                  case '4+':
                    colour = '#f14124'
                    break;
                  default:
                    colour = "#" + ((1<<24)*Math.random() | 0).toString(16)
                }

                name_colour.push(colour)
              }

            })

            // Guardamos "datasets" y "chart_type"
            if (title == 'Distribución Programas') {
              chart_type = 'doughnut';
              datasets.push({
                label: label,
                data: count,
                labels: name,
                id: id,
                backgroundColor: name_colour,
              })
            }

            if (title == 'Superficie' || title == 'Vacancia | Rentabilidad') {
              chart_type = 'line';
              datasets.push({
                label: label,
                data: count,
                fill: false,
                borderColor: serie_colour,
                borderWidth: 4,
                pointRadius: 1,
                lineTension: 0,
                pointHoverBackgroundColor: '#e8ebef',
                pointHoverBorderWidth: 3,
                pointHitRadius: 5,
              })
            }

            if (title == 'Precio UF' || title == 'Precio UFm2') {
              chart_type = 'line';
              datasets.push({
                label: label,
                data: count,
                yAxisID: position_y_axis,
                fill: false,
                borderColor: serie_colour,
                borderWidth: 4,
                pointRadius: 1,
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

          })

          // Guardamos "options"
          if (chart_type == 'doughnut') { // Doughnut

            var chart_options = {
              animation: false,
              responsive: true,
              title: {
                display: false
              },
              legendCallback: function(chart) {
                var text = [];
                var legs = [];
                for (var j = 0; j < chart.data.datasets.length; j++) {
                  for (var i = 0; i < chart.data.datasets[j].data.length; i++) {
                    var newd = {
                      label: chart.data.datasets[j].labels[i],
                      color: chart.data.datasets[j].backgroundColor[i]
                    };
                    if (!containsObject(newd, legs)) {
                      legs.push(newd);
                    }
                  }
                }
                return legs;
              },
              legend: {
                display: false,
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
                    let dataArr = ctx.dataset.data;
                    dataArr.map(data => {
                      sum += data;
                    });
                    let percentage = (value * 100 / sum).toFixed(2);
                    if (percentage > 4) {
                      return percentage + '%';
                    } else {
                      return null;
                    }
                  },
                  align: 'center',
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

          } else { // Line

            if (title == 'Superficie' || title == 'Vacancia | Rentabilidad') {

              y_axes = [{
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
              }]

            } else {

              y_axes = [{
                id: 'left-y-axis',
                position: 'left',
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
              }, {
                id: 'right-y-axis',
                position: 'right',
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
              }]

            }

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
                  // stacked: true,
                  ticks: {
                    display: true,
                    fontSize: 10,
                    fontColor: '#3d4046'
                  }
                }],
                yAxes: y_axes,
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
          canvas.id = 'report-canvas-' + i;

          $('#chart-report' + i).append(canvas);

          var chart_canvas = document.getElementById('report-canvas-' + i).getContext('2d');
          var final_chart = new Chart(chart_canvas, chart_settings);

          var chart = final_chart.toBase64Image();

          if (i % 2 != 0) {

            // Título del gráfico
            doc.setFontSize(16);
            doc.setFontStyle("bold");
            doc.text(title, 105, 20, null, null, 'center');

            // Gráfico
            doc.addImage(chart, 'JPEG', 9, 30);

            if (title == 'Distribución Programas') {

              // agrega nombre de serie al chart
              var dataset_label = chart_data.datasets
              var lab_y_pos = 28;
              for (var e = 0; e < dataset_label.length; e++) {
                var lab = dataset_label[e]['label']
                doc.setFontSize(10);
                doc.setFontStyle("bold");
                doc.text(lab, 105, lab_y_pos, null, null, 'center');
                lab_y_pos += 32
              }

              // agrega leyendas debajo del chart
              var doughnut_legends = final_chart.generateLegend();
              var rect_x_pos = 60
              var text_x_pos = 65
              for (var a = 0; a < doughnut_legends.length; a++) {
                var leg = doughnut_legends[a]
                var label = leg['label']
                var color = leg['color']
                doc.setFontStyle("normal");
                doc.text(label, text_x_pos, 133);
                doc.setDrawColor(0)
                doc.setFillColor(color)
                doc.rect(rect_x_pos, 130, 3, 3, 'F')
                rect_x_pos += 12
                text_x_pos += 12
              }
            }

          } else {

            // Título del gráfico
            doc.setFontSize(16);
            doc.setFontStyle("bold");
            doc.text(title, 105, 160, null, null, 'center');

            // Gráfico
            doc.addImage(chart, 'JPEG', 9, 170);

            // Agrega nueva página
            doc.addPage('a4', 'portrait')

            // Pie de página
            footer()

          } // Cierra if impar
        } // Cierra for

        // Descarga el archivo PDF
        doc.save("Informe_ICA.pdf");

      }); // Cierra then
    } // Cierra success
  }) // Cierra ajax
} // Cierra function projects_report_pdf


Congo.rent_indicators.action_dashboards = function() {

  var ica_charts_ajax;

  init = function() {
    Congo.map_utils.init();
  }


  indicators = function(nId) {

    Congo.dashboards.action_index.create_overlay_and_filter_card();
    Congo.dashboards.action_index.add_time_slider();

    $('#item-comuna').remove();
    $("#spinner").hide();

    // Mostramos los iconos de Útiles correspondientes
    $("#boost").hide();
    $("#base").hide();
    $("#graph").hide();
    $("#census").hide();
    $("#kml").hide();

    // Mostramos el icono de Puntos/Poligonos correspondiente
    $("#type_point").hide();
    $("#poly_build").hide();
    $("#vor_dem").hide();

    // Mostramos el icono de Puntos Proporcionales correspondiente
    $("#prop-prv").hide();
    $("#prop-cbr").hide();
    $("#prop-em").hide();
    $("#col-ica").show();

    // Mostramos el icono de Heatmap correspondiente
    $("#heat-prv").hide();
    $("#heat-cbr").hide();
    $("#heat-em-dem").hide();

    // Mostramos el icono de colorear polígonos
    $("#col-ica").show();

    // Eliminamos los chart-containter de la capa anterior
    $(".chart-container").remove();

    // Mostramos el filtro de la capa y ocultamos los demás
    $('.filter-building-regulations').hide();
    $('.filter-transactions').hide();
    $('.filter-projects').hide();
    $('.filter-future-projects').hide();

    // Eliminamos el time_slider de cbr y el census_filter
    $('#time_slider_cbr_item').remove()
    $('#census_filter').remove()

    if (nId != undefined) {

      to_year = Congo.dashboards.config.year;
      to_bimester = Congo.dashboards.config.bimester;
      var data = {
        to_year: to_year,
        to_period: to_bimester,
        id: nId
      }

      // TODO: Acá se debería agregar o eliminar el filtro de comuna
      // pero ese código ya no está en este archivo. Revisar

      if (ica_charts_ajax && ica_charts_ajax.readyState != 4) {
        ica_charts_ajax.abort();
      }

      ica_charts_ajax = $.ajax({
        type: 'GET',
        url: '/rent_indicators/rent_indicators_summary.json',
        datatype: 'json',
        data: data,
        beforeSend: function() {
          $("#spinner").show();
        },
        success: function(data) {

          console.log('Datos Dashboard:');
          console.log(data);

          $("#spinner").hide();

          bimester = Congo.dashboards.config.bimester;
          year = Congo.dashboards.config.year;
          periods = `${bimester}/${year}`;
          slider_periods = Congo.dashboards.config.slider_periods
          from = slider_periods.indexOf(periods) || slider_periods - 1;
          $("#time_slider").data("ionRangeSlider").update({
             from: from
           });

          // Separamos la información
          for (var i = 0; i < data.length; i++) {

            var reg = data[i];
            var title = reg['title'];
            var series = reg['series'];

            // Creamos el div contenedor
            var chart_container = document.createElement('div');
            chart_container.className = 'chart-container card text-light bg-primary';
            chart_container.id = 'chart-container' + i;

            // Creamos el card-header
            var card_header = document.createElement('div');
            card_header.className = 'card-header pl-3';
            card_header.id = 'header' + i;

            // Creamos el collapse
            var collapse = document.createElement('div');
            collapse.className = 'collapse show';
            collapse.id = 'collapse' + i;

            // Creamos el card-body
            var card_body = document.createElement('div');
            card_body.className = 'card-body';
            card_body.id = 'body' + i;

            // Creamos handle, título y botones
            var card_handle = '<span class="fas fa-arrows-alt handle border border-dark">'
            var card_header_title = '<b>' + title + '</b>'
            var card_min_button = '<button class="close" data-toggle="collapse" data-target="#collapse' + i + '" aria-expanded="true" aria-controls="collapse' + i + '" aria-label="Minimize"><i class="fas fa-window-minimize" style="width: 24px; height: 12px"></i></button>'
            var card_max_button = '<button class="close" id="card-max-' + i + '" onclick="maxCard(' + i + ')"><i class="fas fa-window-maximize" style="width: 24px; height: 12px"></i></button>'

            // Adjuntamos los elementos
            $('.overlay').append(chart_container);
            $('#chart-container' + i).append(card_header, collapse);
            $('#collapse' + i).append(card_body);
            $('#header' + i).append(card_handle, card_header_title, card_max_button, card_min_button);

            // Resumen Bimestre
            if (title == "Resumen Bimestre") {

              var info = reg['data'];

              // Extraemos los datos y los adjuntamos al div contenedor
              $.each(info, function(y, z) {
                name = z['name'];
                count = z['count']
                count = count.toLocaleString('es-ES')
                item = name + ': ' + count + '<br>';
                $('#body' + i).append(item);
              })

              // Gráficos
            } else {

              var datasets = [];
              var serie_colour;

              // Extraemos las series
              $.each(series, function(a, b) {

                // Gráficos de línea
                // Arriendo #ff0000
                // Venta #5dceaf

                var label = b['label']
                var data = b['data']

                if (a == 0) {
                  position_y_axis = 'right-y-axis'
                } else {
                  position_y_axis = 'left-y-axis'
                }

                // Setea los colores dependiendo de la serie
                if (title == 'Superficie' || title == 'Precio UF' || title == 'Precio UFm2' || title == 'Vacancia | Rentabilidad') {
                  switch (label) {
                    case 'Arriendo':
                    case 'Vacancia':
                      serie_colour = '#ff0000'
                      break;
                    case 'Venta':
                    case 'Rentabilidad':
                      serie_colour = '#5dceaf'
                      break;
                  }
                }

                var name = [];
                var count = [];
                var id = [];
                var name_colour = [];
                var colour;

                // Extraemos los datos de las series
                $.each(data, function(c, d) {
                  name.push(d['name'])
                  count.push(d['count'])
                  id.push(d['id'])

                  // Distribución Programas
                  // 1|1 #4e67c8
                  // 2|1 #5eccf3
                  // 2|2 #a7ea52
                  // 3|1 #5dceaf
                  // 3|2 #ff8021
                  // 4+ #f14124

                  // Setea los colores dependiendo del label
                  if (title == 'Distribución Programas') {
                    switch (d['name']) {
                      case '1|1':
                        colour = '#4e67c8'
                        break;
                      case '2|1':
                        colour = '#5eccf3'
                        break;
                      case '2|2':
                        colour = '#a7ea52'
                        break;
                      case '3|1':
                        colour = '#5dceaf'
                        break;
                      case '3|2':
                        colour = '#ff8021'
                        break;
                      case '4+':
                        colour = '#f14124'
                        break;
                      default:
                        colour = "#" + ((1<<24)*Math.random() | 0).toString(16)
                    }

                    name_colour.push(colour)
                  }

                })

                // Guardamos "datasets" y "chart_type"
                if (title == 'Distribución Programas') {
                  chart_type = 'doughnut';
                  datasets.push({
                    label: label,
                    data: count,
                    id: id,
                    backgroundColor: name_colour,
                  })
                }

                if (title == 'Superficie' || title == 'Vacancia | Rentabilidad') {
                  chart_type = 'line';
                  datasets.push({
                    label: label,
                    data: count,
                    fill: false,
                    backgroundColor: serie_colour,
                    borderColor: serie_colour,
                    borderWidth: 4,
                    pointRadius: 1,
                    lineTension: 0,
                    pointHoverBackgroundColor: '#e8ebef',
                    pointHoverBorderWidth: 3,
                    pointHitRadius: 5,
                  })
                }

                if (title == 'Precio UF' || title == 'Precio UFm2') {
                  chart_type = 'line';
                  datasets.push({
                    label: label,
                    data: count,
                    yAxisID: position_y_axis,
                    fill: false,
                    borderColor: serie_colour,
                    backgroundColor: serie_colour,
                    borderWidth: 4,
                    pointRadius: 1,
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

              })

              // Guardamos "options"
              if (chart_type == 'doughnut') { // Doughnut

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
                        return data.datasets[tooltipItem[0].datasetIndex].label;
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
                        var precentage = ((currentValue / total) * 100).toFixed(2)
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
                        let percentage = (value * 100 / sum).toFixed(2);
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
                      align: 'center',
                    }
                  },
                };

              } else { // Line

                if (title == 'Superficie' || title == 'Vacancia | Rentabilidad') {

                  var y_axes;

                  y_axes = [{
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
                  }]

                } else {

                  y_axes = [{
                    id: 'left-y-axis',
                    position: 'left',
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
                  }, {
                    id: 'right-y-axis',
                    position: 'right',
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
                  }]

                }

                var chart_options = {
                  responsive: true,
                  title: {
                    display: false,
                    text: title
                  },
                  legend: {
                    display: true,
                    position: 'bottom',
                    labels: {
                      fontColor: '#e8ebef',
                      boxWidth: 12,
                      padding: 8,
                    }
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
                    yAxes: y_axes,
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
              canvas.id = 'canvas' + i;
              $('#body' + i).append(canvas);

              var chart_canvas = document.getElementById('canvas' + i).getContext('2d');
              var final_chart = new Chart(chart_canvas, chart_settings);

            } // Cierra if
          } // Cierra for
        } // Cierra success
      }) // Cierra ajax
    } // Cierra if (nId != undefined)
  } // Cierra indicators

  return {
    init: init,
    indicators: indicators
  }
}();
