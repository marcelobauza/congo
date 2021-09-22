Congo.namespace('future_projects.action_heatmap');
Congo.namespace('future_projects.action_graduated_points');
Congo.namespace('future_projects.action_dashboards');

Congo.future_projects.config = {
  county_name: '',
  county_id: '',
  layer_type: 'future_projects_info',
  future_project_type_ids: [],
  project_type_ids: [],
  periods: [],
  years: [],
  legends: []
}

future_projects_report_pdf = function() {

  county_id = [];
  $.each(Congo.dashboards.config.county_id, function(a, b) {
    county_id = b;
  })
  to_year = Congo.dashboards.config.year;
  to_bimester = Congo.dashboards.config.bimester;
  radius = Congo.dashboards.config.radius;
  centerPoint = Congo.dashboards.config.centerpt;
  wkt = Congo.dashboards.config.size_box;
  future_project_type_ids = Congo.future_projects.config.future_project_type_ids;
  project_type_ids = Congo.future_projects.config.project_type_ids;
  periods = Congo.future_projects.config.periods;
  years = Congo.future_projects.config.years;
  type_geometry = Congo.dashboards.config.typeGeometry;
  layer_type = Congo.dashboards.config.layer_type;
  style_layer = Congo.dashboards.config.style_layer;
  boost = Congo.dashboards.config.boost;

  if (county_id != '') {

    data = {
      to_year: to_year,
      to_period: to_bimester,
      future_project_type_ids: future_project_type_ids,
      project_type_ids: project_type_ids,
      periods: periods,
      years: years,
      county_id: county_id,
      type_geometry: type_geometry,
      layer_type: layer_type,
      style_layer: style_layer
    };

  } else if (centerPoint != '') {

    data = {
      to_year: to_year,
      to_period: to_bimester,
      future_project_type_ids: future_project_type_ids,
      project_type_ids: project_type_ids,
      periods: periods,
      years: years,
      centerpt: centerPoint,
      radius: radius,
      type_geometry: type_geometry,
      layer_type: layer_type,
      style_layer: style_layer
    };

  } else {

    data = {
      to_year: to_year,
      to_period: to_bimester,
      future_project_type_ids: future_project_type_ids,
      project_type_ids: project_type_ids,
      periods: periods,
      years: years,
      wkt: JSON.stringify(wkt),
      type_geometry: type_geometry,
      layer_type: layer_type,
      style_layer: style_layer
    };

  };

  $.ajax({
    type: 'GET',
    url: '/future_projects/future_projects_summary.json',
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
      $("#time_slider").data("ionRangeSlider").update({
        block: true
      });

    },
    success: function(data) {

      var mapContainer = document.getElementById('map');
      $('.leaflet-top').addClass('d-none');
      $('.leaflet-right').addClass('d-none');
      $('.leaflet-html-legend').addClass('d-none');

      html2canvas(mapContainer, {
        useCORS: true,
      }).then(function(canvas) {

        var img = document.createElement('img');
        var dimensions = map.getSize();
        img.width = dimensions.x;
        img.height = dimensions.y;
        img.src = canvas.toDataURL();

        // Oculta elementos leaflet para sacar la captura
        $('.leaflet-top').removeClass('d-none');
        $('.leaflet-right').removeClass('d-none');
        $('.leaflet-html-legend').removeClass('d-none');

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
        $("#time_slider").data("ionRangeSlider").update({
          block: false,
        });

        // Creamos el doc
        var doc = new jsPDF();

        doc.page = 1;

        // Pie de página
        function footer() {
          doc.setFontStyle("bold");
          doc.setFontSize(12);
          doc.text('Fuente:', 20, 290);
          doc.setFontStyle("normal");
          doc.text('Levantamiento Bimestral en Direcciones de Obras Municipales', 37, 290);
          doc.setFontSize(10);
          doc.text('p. ' + doc.page, 194, 290);
          doc.page++;
        };

        // Título
        doc.setFontStyle("bold");
        doc.setFontSize(22);
        doc.text('Informe de Expedientes Municipales', 105, 20, null, null, 'center');

        // Subtítulo
        doc.setFontSize(16);
        doc.text('Información General', 105, 35, null, null, 'center');

        // Validamos si hay algún filtro aplicado
        if (periods == '') {

          // Periodo Actual
          doc.setFontSize(12);
          doc.setFontStyle("bold");
          doc.text('Periodo de tiempo seleccionado:', 10, 49);
          doc.setFontStyle("normal");
          doc.text(to_bimester+'° bimestre del '+to_year, 78, 49);

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

        // Agrega mapa
        img_height = (img.height * 190) / img.width
        doc.addImage(img, 'JPEG', 9, 55, 190, img_height);

        // Agrega leyenda
        map_legends = Congo.future_projects.config.legends
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
          var serie_colour;

          // Extraemos las series
          $.each(series, function(a, b){

            var label = b['label']
            var data = b['data']

            // Setea los colores dependiendo de la serie
            if (title == 'Tipo de Expediente / Destino' || title == 'Cantidad de Unidades / Bimestre' || title == 'Superficie Edificada Por Expediente') {

              switch (label) {
                case 'Departamento y Local Comercial':
                  serie_colour = '#E74C3C'
                  break;
                case 'Equipamiento':
                  serie_colour = '#BB8FCE'
                  break;
                case 'Departamentos':
                  serie_colour = '#85C1E9'
                  break;
                case 'Local Comercial':
                  serie_colour = '#16A085'
                  break;
                case 'Oficinas':
                  serie_colour = '#F39C12'
                  break;
                case 'Oficina y Local Comercial':
                  serie_colour = '#F1C40F'
                  break;
                case 'Departamento, Oficina y Local Comercial':
                  serie_colour = '#D35400'
                  break;
                case 'Casas':
                  serie_colour = '#BDC3C7'
                  break;
                case 'Bodega, Oficina, Comercio':
                  serie_colour = '#34495E'
                  break;
                case 'Departamento y Oficinas':
                  serie_colour = '#27AE60'
                  break;
                case 'Industria':
                  serie_colour = '#C0392B'
                  break;
                case 'Bodega-Oficina':
                  serie_colour = '#9B59B6'
                  break;
                case 'Bodega':
                  serie_colour = '#2980B9'
                  break;
                case 'Vivienda-Oficina':
                  serie_colour = '#1ABC9C'
                  break;
                case 'Vivienda-Comercio':
                  serie_colour = '#F0B27A'
                  break;
                case 'Hotel & Restaurante':
                  serie_colour = '#ECF0F1'
                  break;
                case 'Bodega, Comercio':
                  serie_colour = '#7F8C8D'
                  break;
                case 'Hotel, Oficina':
                  serie_colour = '#82E0AA'
                  break;
                case 'Anteproyecto':
                  serie_colour = '#ffab00'
                  break;
                case 'Permiso de Edificación':
                  serie_colour = '#e81900'
                  break;
                case 'Recepción Municipal':
                  serie_colour = '#2619d1'
                  break;
              }
            }

            var name = [];
            var count = [];
            var id = [];
            var name_colour = [];
            var colour;

            // Extraemos los datos de las series
            $.each(data, function(c, d){
              name.push(d['name'])
              count.push(d['count'])

              // Setea los colores dependiendo del label
              if (title == 'Tipo de Expendiente' || title == 'Destino Obra') {
                switch (d['name']) {
                  case 'Departamento y Local Comercial':
                    colour = '#E74C3C'
                    break;
                  case 'Equipamiento':
                    colour = '#BB8FCE'
                    break;
                  case 'Departamentos':
                    colour = '#85C1E9'
                    break;
                  case 'Local Comercial':
                    colour = '#16A085'
                    break;
                  case 'Oficinas':
                    colour = '#F39C12'
                    break;
                  case 'Oficina y Local Comercial':
                    colour = '#F1C40F'
                    break;
                  case 'Departamento, Oficina y Local Comercial':
                    colour = '#D35400'
                    break;
                  case 'Casas':
                    colour = '#BDC3C7'
                    break;
                  case 'Bodega, Oficina, Comercio':
                    colour = '#34495E'
                    break;
                  case 'Departamento y Oficinas':
                    colour = '#27AE60'
                    break;
                  case 'Industria':
                    colour = '#C0392B'
                    break;
                  case 'Bodega-Oficina':
                    colour = '#9B59B6'
                    break;
                  case 'Bodega':
                    colour = '#2980B9'
                    break;
                  case 'Vivienda-Oficina':
                    colour = '#1ABC9C'
                    break;
                  case 'Vivienda-Comercio':
                    colour = '#F0B27A'
                    break;
                  case 'Hotel & Restaurante':
                    colour = '#ECF0F1'
                    break;
                  case 'Bodega, Comercio':
                    colour = '#7F8C8D'
                    break;
                  case 'Hotel, Oficina':
                    colour = '#82E0AA'
                    break;
                  case 'Anteproyecto':
                    colour = '#ffab00'
                    break;
                  case 'Permiso de edificacion':
                    colour = '#e81900'
                    break;
                  case 'Recepcion municipal':
                    colour = '#2619d1'
                    break;
                }

                name_colour.push(colour)
              }

            })

            // Guardamos "datasets" y "chart_type"
            if (title == 'Tipo de Expendiente') {
              chart_type = 'pie';
              datasets.push({
                label: label,
                data: count,
                backgroundColor: name_colour,
              })
            }

            if (title == 'Destino Obra') {
              chart_type = 'pie';
              datasets.push({
                label: label,
                data: count,
                id: id,
                backgroundColor: name_colour,
              })
            }

            if (title == 'Tipo de Expediente / Destino') {
              chart_type = 'bar';
              datasets.push({
                label: label,
                data: count,
                backgroundColor: serie_colour,
              })
              // Renombramos los name para evitar superposición en el chart
              name = ["Anteproyecto", "Permiso de Edificación", "Recepción Municipal"];
            }

            if (title == 'Cantidad de Unidades / Bimestre') {
              chart_type = 'line';
              datasets.push({
                label: label,
                data: count,
                fill: false,
                borderColor: serie_colour,
                borderWidth: 4,
                pointRadius: 0,
                pointStyle: 'line',
                lineTension: 0,
              })
            }

            if (title == 'Superficie Edificada Por Expediente') {
              chart_type = 'line';
              datasets.push({
                label: label,
                data: count,
                fill: false,
                borderColor: serie_colour,
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

          })

          // Guardamos "options"
          if (chart_type == 'bar') { // Bar

            var chart_options = {
              animation: false,
              responsive: true,
              title: {
                display: false,
              },
              legend: {
                display: true,
                position: 'bottom',
                labels: {
                  fontColor: '#3d4046',
                  fontSize: 12,
                  filter: function(legendItem, chartData) {
                    // Solo muestra el legend si algunos de sus valores es diferente a 0
                    if (chartData.datasets[legendItem.datasetIndex].data[0] != 0
                      || chartData.datasets[legendItem.datasetIndex].data[1] != 0
                      || chartData.datasets[legendItem.datasetIndex].data[2] != 0) {
                      return legendItem.text
                    }
                  }
                }
              },
              plugins: {
                datalabels: {
                  align: 'center',
                  anchor: 'center',
                  color: '#3d4046',
                  font: {
                    size: 10
                  },
                  formatter: (value, ctx) => {
                    // Mustra sólo los valores que estén por encima del 3%
                    let sum = 0;
                    let dataArr = ctx.chart.data.datasets[0].data;
                    dataArr.map(data => {
                        sum += data;
                    });
                    let percentage = (value*100 / sum).toFixed(2);
                    if (percentage > 4) {
                      return value.toLocaleString('es-ES');
                    } else {
                      return null;
                    }
                  },
                },
              },
              scales: {
                xAxes: [{
                  stacked: true,
                  ticks: {
                    display: true,
                    fontSize: 12,
                    fontColor: '#3d4046'
                  }
                }],
                yAxes: [{
                  stacked: true,
                  ticks: {
                    callback: function(label, index, labels) {
                      label = label.toLocaleString('es-ES')
                      return label;
                    },
                    beginAtZero: true,
                    display: true,
                    fontSize: 10,
                    fontColor: '#3d4046'
                  }
                }],
              }
            };

          } else if (chart_type == 'pie') { // Pie

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

          } else { // Line

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
              layout: {
                padding: {
                  right: 40
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
        } // Cierra for

        // Descarga el archivo PDF
        doc.save("Informe_ExpedientesMunicipales.pdf");

      }); // Cierra then
    } // Cierra success
  }) // Cierra ajax
} // Cierra future_projects_report_pdf

Congo.future_projects.action_heatmap = function(){

  init=function(){

        Congo.future_projects.config.legends = [];
        Congo.dashboards.config.style_layer= 'heatmap_test_future_projects';
        Congo.future_projects.config.legends.push({'name':'Alto', 'color':'9d2608'});
        Congo.future_projects.config.legends.push({'name':'Medio Alto', 'color':'f94710'});
        Congo.future_projects.config.legends.push({'name':'Medio', 'color':'fa7c16'});
        Congo.future_projects.config.legends.push({'name':'Medio Bajo', 'color':'fda821'});
        Congo.future_projects.config.legends.push({'name':'Bajo', 'color':'fcd930'});
        Congo.map_utils.counties();
  }
  return {
    init: init,
  }
}();

Congo.future_projects.action_graduated_points = function(){

  init=function(){
        Congo.dashboards.config.style_layer= 'future_projects_point_graduated_m2_built';
        Congo.future_projects.config.legends =[];
        Congo.future_projects.config.legends.push({'name':'Menor a 2.499', 'color':'d73027'});
        Congo.future_projects.config.legends.push({'name':'2.500 a 6.499', 'color':'fc8d59'});
        Congo.future_projects.config.legends.push({'name':'6.500 a 10.999', 'color':'fee090'});
        Congo.future_projects.config.legends.push({'name':'11.000 a 19.999', 'color':'e0f3f8'});
        Congo.future_projects.config.legends.push({'name':'20.000 a 39.999', 'color':'91bfdb'});
        Congo.future_projects.config.legends.push({'name':'Mayor a 40.000', 'color':'4575b4'});
        Congo.map_utils.counties();
      }

  return {
    init: init,
  }
}();

function maxCard(i){
  $('#chart-container'+i).toggleClass('card-max fixed-top')
}

future_projects_popup= function(id){

  bimester = Congo.dashboards.config.bimester;
  year = Congo.dashboards.config.year;
  Congo.dashboards.config.row_id = id;

  data = {id: id, bimester: bimester, year: year};
  $.ajax({
    type: 'GET',
    url: '/future_projects/index.json',
    datatype: 'json',
    data: data,
    success: function(data) {
      $('.feedback_future_project_id').empty();
      $('.feedback_future_project_id').val(data.id);
      $('#popup_info_future_projects').empty();

      // Agregamos la información general
      $('#popup_info_future_projects').append(
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
              'text': data.bimester
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
              'text': data.year
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
              'text': data.address
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Expediente:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.future_project_type.name
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Destino:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.project_type.name
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Nombre:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.name
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Número de Expediente:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.file_number
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Fecha de Expediente:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.file_date
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Propietario:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.owner
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Represtentante Legal:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.legal_agent
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Arquitecto:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.architect
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Cantidad de Pisos:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.floors
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Total de Subterráneos:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.undergrounds
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Total de Unidades:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.total_units
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Total de Estacionamientos:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.total_parkings
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Total de Locales Comerciales:'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.total_commercials
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Superficie Aprobada (m²):'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.m2_approved
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Superficie Edificada (m²):'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.m2_built
            }),
          ),
          $('<div>', {
            'class': 'row'
          }).append(
            $('<div>', {
              'class': 'col-md-6 text-right',
              'text': 'Superficie Terreno (m²):'
            }),
            $('<div>', {
              'class': 'col-md-6',
              'text': data.m2_field
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
      )

      $('#leaflet_modal_future_projects').modal();

      // Vuelve a activar el primer tab cuando se cierra el modal del popup
      $('#leaflet_modal_future_projects').on('hidden.bs.modal', function (e) {
        $('#list-tab a:first-child').tab('show')
      })

    }
  });

    Congo.dashboards.pois();
} // Cierra future_projects_popup

Congo.future_projects.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_future_projects = function(){
    county_id = [];
    $.each(Congo.dashboards.config.county_id, function(a,b){
       county_id =b;
    })
    to_year = Congo.dashboards.config.year;
    to_bimester = Congo.dashboards.config.bimester;
    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
    future_project_type_ids = Congo.future_projects.config.future_project_type_ids;
    project_type_ids = Congo.future_projects.config.project_type_ids;
    periods = Congo.future_projects.config.periods;
    years = Congo.future_projects.config.years;
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
      Congo.dashboards.action_index.add_time_slider();

      if (county_id != '') {

        // Agregamos filtro Comuna
        Congo.dashboards.action_index.add_county_filter_item()

        data = {
          to_year: to_year,
          to_period: to_bimester,
          future_project_type_ids: future_project_type_ids,
          project_type_ids: project_type_ids,
          periods: periods,
          years: years,
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
          future_project_type_ids: future_project_type_ids,
          project_type_ids: project_type_ids,
          periods: periods,
          years: years,
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
          future_project_type_ids: future_project_type_ids,
          project_type_ids: project_type_ids,
          periods: periods,
          years: years,
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
        url: '/future_projects/future_projects_summary.json',
        datatype: 'json',
        data: data,
        beforeSend: function() {

          // Mostramos el spinner y deshabilitamos los botones
          $("#spinner").show();
          $('.btn').addClass('disabled')
          $('.close').prop('disabled', true);
          $("#time_slider").data("ionRangeSlider").update({
            block: true
          });

          // Establece el nombre de la capa en el navbar
          $('#layer-name').text('EXPEDIENTES MUNICIPALES');

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
          $("#prop-cbr").hide();
          $("#prop-em").show();

          // Mostramos el icono de Heatmap correspondiente
          $("#heat-prv").hide();
          $("#heat-cbr").hide();
          $("#heat-em-dem").show();

          // Eliminamos los chart-containter de la capa anterior
          $(".chart-container").remove();

          // Mostramos el filtro de la capa y ocultamos los demás
          $('.filter-building-regulations').hide();
          $('.filter-transactions').hide();
          $('.filter-projects').hide();
          $('.filter-future-projects').show();

          // Eliminamos el time_slider de cbr y el census_filter
          $('#time_slider_cbr_item').remove()
          $('#census_filter').remove()

        },
        success: function(data) {

          // Ocultamos el spinner y habilitamos los botones
          $("#spinner").hide();
          $('.btn').removeClass('disabled')
          $('.close').prop('disabled', false);
          bimester = Congo.dashboards.config.bimester;
          year = Congo.dashboards.config.year;
          periods = `${bimester}/${year}`;
          slider_periods = Congo.dashboards.config.slider_periods
          from = slider_periods.indexOf(periods) || slider_periods - 1;
          $("#time_slider").data("ionRangeSlider").update({
            block: false,
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
            if (title == "Resumen") {

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
              var serie_colour;

              // Extraemos las series
              $.each(series, function(a, b){

                var label = b['label']
                var data = b['data']

                // Setea los colores dependiendo de la serie
                if (title == 'Tipo de Expediente / Destino' || title == 'Cantidad de Unidades / Bimestre' || title == 'Superficie Edificada Por Expediente') {

                  switch (label) {
                    case 'Departamento y Local Comercial':
                      serie_colour = '#E74C3C'
                      break;
                    case 'Equipamiento':
                      serie_colour = '#BB8FCE'
                      break;
                    case 'Departamentos':
                      serie_colour = '#85C1E9'
                      break;
                    case 'Local Comercial':
                      serie_colour = '#16A085'
                      break;
                    case 'Oficinas':
                      serie_colour = '#F39C12'
                      break;
                    case 'Oficina y Local Comercial':
                      serie_colour = '#F1C40F'
                      break;
                    case 'Departamento, Oficina y Local Comercial':
                      serie_colour = '#D35400'
                      break;
                    case 'Casas':
                      serie_colour = '#BDC3C7'
                      break;
                    case 'Bodega, Oficina, Comercio':
                      serie_colour = '#34495E'
                      break;
                    case 'Departamento y Oficinas':
                      serie_colour = '#27AE60'
                      break;
                    case 'Industria':
                      serie_colour = '#C0392B'
                      break;
                    case 'Bodega-Oficina':
                      serie_colour = '#9B59B6'
                      break;
                    case 'Bodega':
                      serie_colour = '#2980B9'
                      break;
                    case 'Vivienda-Oficina':
                      serie_colour = '#1ABC9C'
                      break;
                    case 'Vivienda-Comercio':
                      serie_colour = '#F0B27A'
                      break;
                    case 'Hotel & Restaurante':
                      serie_colour = '#ECF0F1'
                      break;
                    case 'Bodega, Comercio':
                      serie_colour = '#7F8C8D'
                      break;
                    case 'Hotel, Oficina':
                      serie_colour = '#82E0AA'
                      break;
                    case 'Anteproyecto':
                      serie_colour = '#ffab00'
                      break;
                    case 'Permiso de Edificación':
                      serie_colour = '#e81900'
                      break;
                    case 'Recepción Municipal':
                      serie_colour = '#2619d1'
                      break;
                  }
                }

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
                  if (title == 'Tipo de Expendiente' || title == 'Destino Obra') {
                    switch (d['name']) {
                      case 'Departamento y Local Comercial':
                        colour = '#E74C3C'
                        break;
                      case 'Equipamiento':
                        colour = '#BB8FCE'
                        break;
                      case 'Departamentos':
                        colour = '#85C1E9'
                        break;
                      case 'Local Comercial':
                        colour = '#16A085'
                        break;
                      case 'Oficinas':
                        colour = '#F39C12'
                        break;
                      case 'Oficina y Local Comercial':
                        colour = '#F1C40F'
                        break;
                      case 'Departamento, Oficina y Local Comercial':
                        colour = '#D35400'
                        break;
                      case 'Casas':
                        colour = '#BDC3C7'
                        break;
                      case 'Bodega, Oficina, Comercio':
                        colour = '#34495E'
                        break;
                      case 'Departamento y Oficinas':
                        colour = '#27AE60'
                        break;
                      case 'Industria':
                        colour = '#C0392B'
                        break;
                      case 'Bodega-Oficina':
                        colour = '#9B59B6'
                        break;
                      case 'Bodega':
                        colour = '#2980B9'
                        break;
                      case 'Vivienda-Oficina':
                        colour = '#1ABC9C'
                        break;
                      case 'Vivienda-Comercio':
                        colour = '#F0B27A'
                        break;
                      case 'Hotel & Restaurante':
                        colour = '#ECF0F1'
                        break;
                      case 'Bodega, Comercio':
                        colour = '#7F8C8D'
                        break;
                      case 'Hotel, Oficina':
                        colour = '#82E0AA'
                        break;
                      case 'Anteproyecto':
                        colour = '#ffab00'
                        break;
                      case 'Permiso de edificacion':
                        colour = '#e81900'
                        break;
                      case 'Recepcion municipal':
                        colour = '#2619d1'
                        break;
                    }

                    name_colour.push(colour)
                  }

                })

                // Guardamos "datasets" y "chart_type"
                if (title == 'Tipo de Expendiente') {
                  chart_type = 'pie';
                  datasets.push({
                    label: label,
                    data: count,
                    id: id,
                    backgroundColor: name_colour,
                  })
                }

                if (title == 'Destino Obra') {
                  chart_type = 'pie';
                  datasets.push({
                    label: label,
                    data: count,
                    id: id,
                    backgroundColor: name_colour,
                  })
                }

                if (title == 'Tipo de Expediente / Destino') {
                  chart_type = 'bar';
                  datasets.push({
                    label: label,
                    data: count,
                    backgroundColor: serie_colour,
                  })
                  // Renombramos los name para evitar superposición en el chart
                  name = ["Anteproyecto", "Permiso Edif.", "Recep. Munic."];
                }

                if (title == 'Cantidad de Unidades / Bimestre') {
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

                if (title == 'Superficie Edificada Por Expediente') {
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

                chart_data = {
                  labels: name,
                  datasets: datasets
                }

              })

              // Guardamos "options"
              if (chart_type == 'bar') { // Bar

                var chart_options = {
                  responsive: true,
                  title: {
                    display: false,
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
                        maxRotation: 0,
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
                    filter_item.className = 'filter-future-projects text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split(" ").join("_");
                    filter_item.id = 'item-'+filter_item_id+'-'+x_tick_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    var text_item = title+': '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id+'-'+x_tick_id).length == 0) {

                      // Almacena la variable global dependiendo del chart
                      if (title == 'Tipo de Expendiente') {
                        Congo.future_projects.config.future_project_type_ids.push(x_tick_id);
                      } else {
                        Congo.future_projects.config.project_type_ids.push(x_tick_id);
                      };

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id+'-'+x_tick_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();
                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {

                      if (title == 'Tipo de Expendiente') {
                        var active_items = Congo.future_projects.config.future_project_type_ids;
                      } else {
                        var active_items = Congo.future_projects.config.project_type_ids;
                      };

                      var item_full_id = $('#item-'+filter_item_id+'-'+x_tick_id).attr('id');
                      item_full_id = item_full_id.split("-")
                      var item_id = item_full_id[2]

                      var active_items_updated = $.grep(active_items, function(n, i) {
                        return n != item_id;
                      });

                      if (title == 'Tipo de Expendiente') {
                        Congo.future_projects.config.future_project_type_ids = active_items_updated;
                      } else {
                        Congo.future_projects.config.project_type_ids = active_items_updated;
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
                    filter_item.className = 'filter-future-projects text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split("/").join("-");
                    filter_item.id = 'item-'+filter_item_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    var text_item = 'Periodo: '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id).length == 0) {

                      // Almacena la variable global
                      var periods_years = x_tick.split("/");
                      Congo.future_projects.config.periods.push(periods_years[0]);
                      Congo.future_projects.config.years.push(20+periods_years[1]);

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();

                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {

                      var active_periods = Congo.future_projects.config.periods;
                      var active_years = Congo.future_projects.config.years;

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

                      Congo.future_projects.config.periods = periods_updated;
                      Congo.future_projects.config.years = years_updated;

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
        }, // Cierra success
        error: function(jqXHR, textStatus, errorThrown) {
        } // Cierra error
      }) // Cierra ajax
    } // Cierra if alert
  } // Cierra indicator_future_projects

  return {
    init: init,
    indicator_future_projects: indicator_future_projects
  }
}();
