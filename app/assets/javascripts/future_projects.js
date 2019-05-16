Congo.namespace('future_projects.action_dashboards');

Congo.future_projects.config= {
  county_name: '',
  county_id: '',
  layer_type: 'future_projects_info'
}

Congo.future_projects.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_future_projects = function(){

    $.ajax({
      type: 'GET',
      url: '/future_projects/future_projects_summary.json',
      datatype: 'json',
      data: {to_year:"2018", locale:"es", periods_quantity: "5", to_period: "6", county_id:"52" },
      success: function(data){

        console.log(data);

        // Extraemos los charts
        for (var i = 0; i < data.length; i++) {

          var reg = data[i];

          var title = reg['title'];
          var series = reg['series'];

          //Extraemos los datos de "Información General" para tratarlos por separado
          if (title == "Información General") {

            var info = reg['data'];

            // Creamos y adjuntamos el div contenedor
            var chart_container = document.createElement('div');
            chart_container.className = 'chart-container'+i+' card';
            $('.overlay').append(chart_container);

            // Extraemos los datos y los adjuntamos al div contenedor
            $.each(info, function(y, z){
              name = z['name'];
              label = z['count']
              item = name+': '+label+'<br>';
              $('.chart-container'+i).append(item);
            })

          // Extraemos y publicamos los gráficos
          } else {

            var datasets = [];

            // Extraemos las series
            $.each(series, function(a, b){

              var label = b['label']
              var data = b['data']

              if (label == 'Anteproyecto') {
                serie_colour = '#60c843'
              }
              if (label == 'Permiso de Edif.' || label == 'Tasa Permiso / Anteproyecto') {
                serie_colour = '#0f115b'
              }
              if (label == 'Recep. Municipal' || label == 'Tasa Recepciones / Permisos') {
                serie_colour = '#eb2817'
              }

              var name = [];
              var count = [];

              // Extraemos los datos de las series
              $.each(data, function(c, d){
                name.push(d['name'])
                count.push(d['count'])
              })


              // Guardamos "datasets" y "chart_type"
              if (title == 'Tipo de Expendiente') {
                chart_type = 'pie';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: [
                      '#424949',
                      '#7F8C8D',
                      '#E5E8E8'
                  ],
                })
              }

              if (title == 'Tipo de Destino Pie') {
                chart_type = 'pie';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: [
                      '#4D5656',
                      '#5F6A6A',
                      '#717D7E',
                      '#839192',
                      '#95A5A6',
                      '#AAB7B8',
                      '#BFC9CA',
                      '#D5DBDB',
                      '#F4F6F6'
                  ],
                })
              }

              if (title == 'Tipo de Destino Bar') {
                chart_type = 'bar';
                cantidad = count.length;
                rancolor = randomColor({
                  luminosity: 'light',
                })
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: rancolor,
                })
              }

              if (title == 'Cantidad de Nuevas Unidades / Bimestre') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  borderColor: serie_colour,
                  lineTension: 0,
                  pointRadius: 0,
                  borderWidth: 3,
                  fill: false,
                })
              }

              if (title == 'Superficie Edificada Por Expediente') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  borderColor: serie_colour,
                  lineTension: 0,
                  pointRadius: 0,
                  borderWidth: 3,
                  fill: false,
                })
              }

              if (title == 'Tasas') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  borderColor: serie_colour,
                  lineTension: 0,
                  pointRadius: 0,
                  borderWidth: 3,
                  fill: false,
                })
              }

              chart_data = {
                labels: name,
                datasets: datasets
              }

            })

            // Guardamos "options"
            if (chart_type == 'bar') {

              var chart_options = {
                responsive: true,
                title: {
                  display: true,
                  text: title,
                  fontSize: 15
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
                    ticks: {
                      autoSkip: false,
                      maxRotation: 0,
                    },
                  }],
                  yAxes: [{
                    stacked: true,
                    ticks: {
                      beginAtZero: true,
                    },
                  }],
                }
              }

            } else if (chart_type == 'pie') {

              var chart_options = {
                responsive: true,
                title: {
                  display: true,
                  text: title,
                  fontSize: 15
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
              }

            } else {

              var chart_options = {
                responsive: true,
                title: {
                  display: true,
                  text: title,
                  fontSize: 15
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
              }

            }

            var chart_settings = {
              type: chart_type,
              data: chart_data,
              options: chart_options
            }

            // TODO: Adjuntar las clases card-header y card-body

            // Creamos el div contenedor
            var chart_container = document.createElement('div');
            chart_container.className = 'chart-container'+i+' card';

            // Creamos el canvas
            var canvas = document.createElement('canvas');
            var canvas_id = 'canvas'+i;
            canvas.id = canvas_id;

            // Adjuntamos los elementos
            $('.overlay').append(chart_container);
            $('.chart-container'+i).append(canvas);

            var chart_canvas = document.getElementById('canvas'+i).getContext('2d');
            var final_chart = new Chart(chart_canvas, chart_settings);

          } // Cierra if
        } // Cierra for
      } // Cierra success
    }) // Cierra ajax
  } // Cierra indicator_future_projects

  return {
    init: init,
    indicator_future_projects: indicator_future_projects
  }
}();
