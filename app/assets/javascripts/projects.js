Congo.namespace('projects.action_dashboards');

Congo.projects.config= {
  county_name: '',
  county_id: '',
  layer_type: 'projects_info'
}

Congo.projects.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_projects = function(){

    $.ajax({
      type: 'GET',
      url: '/projects/projects_summary.json',
      datatype: 'json',
      data: {to_year:"2018", locale:"es", periods_quantity: "5", to_period: "6", county_id:"52" },
      success: function(data){

        // Eliminamos el overlay
        $(".overlay").remove();

        // Creamos y adjuntamos el overlay
        var overlay = document.createElement('div');
        overlay.className = 'overlay';
        $('#map').before(overlay);

        // Separamos la información
        for (var i = 0; i < data.length; i++) {

          var reg = data[i];
          var title = reg['title'];
          var series = reg['series'];

          // Creamos el div contenedor
          var chart_container = document.createElement('div');
          chart_container.className = 'chart-container'+i+' card';

          // Creamos el card-header
          var card_header = document.createElement('div');
          card_header.className = 'card-header';
          card_header.id = 'header'+i;

          // Creamos el collapse
          var collapse = document.createElement('div');
          collapse.className = 'collapse show';
          collapse.id = 'collapse'+i;

          // Creamos el card-body
          var card_body = document.createElement('div');
          card_body.className = 'card-body';
          card_body.id = 'body'+i;

          // TODO: Crear título y boton minimizar dinámicos

          // Creamos título y boton minimizar
          var card_header_button = '<button type="button" class="close" data-toggle="collapse" data-target="#collapse'+i+'" aria-expanded="true" aria-controls="collapse'+i+'" aria-label="Minimize"><i class="fas fa-window-minimize"></i></button>'
          var card_header_title = '<b>'+title+'</b>'

          // Adjuntamos los elementos
          $('.overlay').append(chart_container);
          $('.chart-container'+i).append(card_header, collapse);
          $('#collapse'+i).append(card_body);
          $('#header'+i).append(card_header_button, card_header_title);

          // Información General
          if (title == "Información General") {

            var info = reg['data'];

            // Extraemos los datos y los adjuntamos al div contenedor
            $.each(info, function(y, z){
              name = z['name'];
              label = z['count']
              item = name+': '+label+'<br>';
              $('#body'+i).append(item);
            })

          // Gráficos
          } else {

            var datasets = [];

            // Extraemos las series
            $.each(series, function(a, b){

              var label = b['label']
              var data = b['data']

              if (label == 'Máximo' || label == 'Oferta') {
                serie_colour = '#a5bc4e'
              }
              if (label == 'Mínimo' || label == 'Disponibilidad') {
                serie_colour = '#e48701'
              }
              if (label == 'Promedio' || label == 'Venta' || label == 'Venta Total') {
                serie_colour = '#1b95d9'
              }

              var name = [];
              var count = [];

              // Extraemos los datos de las series
              $.each(data, function(c, d){
                name.push(d['name'])
                count.push(d['count'])
              })

              // Guardamos "datasets" y "chart_type"
              if (title == 'Estado del Proyecto') {
                chart_type = 'pie';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: [
                      '#424949',
                      '#616A6B',
                      '#99A3A4',
                      '#F2F4F4'
                  ],
                })
              }

              if (title == 'Tipo de Propiedad') {
                chart_type = 'pie';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: [
                      '#424949'
                  ],
                })
              }

              if (title == 'Total Distribución por Mix') {
                chart_type = 'bar';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: serie_colour,
                })
              }

              if (title == 'Oferta, Venta y Disponibilidad por Bimestre') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: serie_colour,
                  borderWidth: 4,
                  pointRadius: 1,
                  lineTension: 0,
                  pointHoverBackgroundColor: '#F2F4F4',
                  pointHoverBorderWidth: 3,
                  pointHitRadius: 5,
                })
              }

              if (title == 'Valor UF por Bimestre') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: serie_colour,
                  borderWidth: 4,
                  pointRadius: 1,
                  lineTension: 0,
                  pointHoverBackgroundColor: '#F2F4F4',
                  pointHoverBorderWidth: 3,
                  pointHitRadius: 5,
                })
              }

              if (title == 'UF/m2 por Bimestre') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: serie_colour,
                  borderWidth: 4,
                  pointRadius: 1,
                  lineTension: 0,
                  pointHoverBackgroundColor: '#F2F4F4',
                  pointHoverBorderWidth: 3,
                  pointHitRadius: 5,
                })
              }

              if (title == 'Superficie Útil (m2) por Bimestre') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: serie_colour,
                  borderWidth: 4,
                  pointRadius: 1,
                  lineTension: 0,
                  pointHoverBackgroundColor: '#F2F4F4',
                  pointHoverBorderWidth: 3,
                  pointHitRadius: 5,
                })
              }

              if (title == 'Superficie Terreno/Terraza (m2) por Bimestre') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: serie_colour,
                  borderWidth: 4,
                  pointRadius: 1,
                  lineTension: 0,
                  pointHoverBackgroundColor: '#F2F4F4',
                  pointHoverBorderWidth: 3,
                  pointHitRadius: 5,
                })
              }

              if (title == 'Cantidad de Proyectos por Bimestre') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  fill: false,
                  borderColor: '#f08939',
                  borderWidth: 4,
                  pointBackgroundColor: '#F2F4F4',
                  pointRadius: 3,
                  lineTension: 0,
                  pointHoverBackgroundColor: '#F2F4F4',
                  pointHoverBorderWidth: 3,
                  pointHitRadius: 5,
                })
              }

              if (title == 'Cantidad de Pisos') {
                chart_type = 'bar';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: '#dddb58',
                  borderColor: '#4D5656',
                  borderWidth: 2,
                  hoverBorderWidth: 3,
                })
              }

              if (title == 'Unidades Proyecto por Rango UF') {
                chart_type = 'bar';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: '#dddb58',
                  borderColor: '#4D5656',
                  borderWidth: 2,
                  hoverBorderWidth: 3,
                })
              }

              chart_data = {
                labels: name,
                datasets: datasets
              }

            })

            // Guardamos "options"
            if (chart_type == 'bar') { // Bar

              // Seteamos los ticks
              if (title == 'Total Distribución por Mix') {
                var ticks = {
                  display: false,
                }
              } else {
                var ticks = {
                  autoSkip: false,
                  maxRotation: 12,
                }
              };

              var chart_options = {
                responsive: true,
                title: {
                  display: false,
                },
                legend: {
                  display: false,
                },
                plugins: {
                  datalabels: {
                    display: false,
                  },
                },
                scales: {
                  xAxes: [{
                    stacked: true,
                    ticks: ticks
                  }],
                  yAxes: [{
                    stacked: true,
                    ticks: {
                      beginAtZero: true,
                    },
                  }],
                }
              };

            } else if (chart_type == 'pie') { // Pie

              var chart_options = {
                responsive: true,
                title: {
                  display: false,
                },
                legend: {
                  display: false,
                },
                plugins: {
                  datalabels: {
                    formatter: function(value, context) {
                      return context.chart.data.labels[context.dataIndex];
                    },
                    display: function(context) {
                      var dataset = context.dataset;
                      var count = dataset.data.length;
                      var value = dataset.data[context.dataIndex];
                      return value > count * 1.5;
                    },
                    font: {
                      size: 11,
                    },
                    color: 'white',
                    textStrokeColor: '#616A6B',
                    textStrokeWidth: 1,
                    textShadowColor: '#000000',
                    textShadowBlur: 2,
                    align: 'end',
                  }
                },
              };

            } else { // Line

              var chart_options = {
                responsive: true,
                title: {
                  display: false,
                },
                legend: {
                  display: false,
                },
                plugins: {
                  datalabels: {
                    display: false,
                  },
                },
                scales: {
                  yAxes: [{
                    ticks: {
                      beginAtZero: true,
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
  } // Cierra indicator_future_projects

  return {
    init: init,
    indicator_projects: indicator_projects
  }
}();
