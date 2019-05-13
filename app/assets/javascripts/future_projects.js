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

          //Extraemos los datos de "Informacion General" para tratarlos por separado
          if (title == "Informacion General") {

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

              if (label == 'ANTEPROYECTO') {
                serie_colour = '#60c843'
              }
              if (label == 'PERMISO DE EDIFICACION') {
                serie_colour = '#0f115b'
              }
              if (label == 'RECEPCION MUNICIPAL') {
                serie_colour = '#eb2817'
              }
              if (label == 'Tasa Permiso / Anteproyecto') {
                serie_colour = '#0f115b'
              }
              if (label == 'Tasa Recepciones / Permisos') {
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
                cantidad = count.length;
                rancolor = randomColor({
                  count: cantidad,
                  format: 'rgb',
                  seed: 1,
                })
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: rancolor,
                })
              }

              if (title == 'Tipos de destino') {
                chart_type = 'pie';
                cantidad = count.length;
                rancolor = randomColor({
                  count: cantidad,
                  format: 'rgb',
                  seed: 1,
                })
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: rancolor,
                })
              }

              if (title == 'Tipo de Destino') {
                chart_type = 'bar';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: serie_colour,
                })
              }

              if (title == 'Cantidad de unidades nuevas / bimestre') {
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

              if (title == 'Superficie edificada por expediente') {
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
            if (title == 'Tipo de Destino') {
              var chart_options = {
                responsive: true,
                title: {
                  display: true,
                  text: title,
                  fontSize:15
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
                  }],
                  yAxes: [{
                    stacked: true,
                  }],
                }
              }
            } else {
              var chart_options = {
                responsive: true,
                title: {
                  display: true,
                  text: title,
                  fontSize:15
                },
                legend: {
                  display: false,
                },
                plugins: {
                  datalabels: {
                    display: false,
                  },
                },
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
