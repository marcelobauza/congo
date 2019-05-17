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

        // Creamos y adjuntamos el overlay
        var overlay = document.createElement('div');
        overlay.className = 'overlay';
        $('#map').append(overlay);
        
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
                cantidad = count.length;
                rancolor = randomColor({
                  count: cantidad,
                  hue: 'monochrome',
                  format: 'rgb',
                  seed: 1,
                })
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: rancolor,
                })
              }

              if (title == 'Tipo de Propiedad') {
                chart_type = 'pie';
                cantidad = count.length;
                rancolor = randomColor({
                  count: cantidad,
                  hue: 'monochrome',
                  format: 'rgb',
                  seed: 1,
                })
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: rancolor,
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
                  borderColor: serie_colour,
                  lineTension: 0,
                  pointRadius: 0,
                  borderWidth: 3,
                  fill: false,
                })
              }

              if (title == 'Valor UF por Bimestre') {
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

              if (title == 'UF/m2 por Bimestre') {
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

              if (title == 'Superficie Útil (m2) por Bimestre') {
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

              if (title == 'Superficie Terreno/Terraza (m2) por Bimestre') {
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

              if (title == 'Cantidad de Proyectos por Bimestre') {
                chart_type = 'line';
                datasets.push({
                  label: label,
                  data: count,
                  borderColor: '#f08939',
                  lineTension: 0,
                  pointRadius: 0,
                  borderWidth: 3,
                  fill: false,
                })
              }

              if (title == 'Cantidad de Pisos') {
                chart_type = 'bar';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: '#dddb58',
                })
              }

              if (title == 'Unidades Proyecto por Rango UF') {
                chart_type = 'bar';
                datasets.push({
                  label: label,
                  data: count,
                  backgroundColor: '#dddb58',
                })
              }

              chart_data = {
                labels: name,
                datasets: datasets
              }

            })

            // TODO: Habría que organizar las opciones por tipo de gráfico.
            // TODO: Agregar beginAtZero y autoSkip

            // Guardamos "options"
            if (title == 'Total Distribución por Mix') {
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
                    ticks: {
                      display: false
                    },
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
    indicator_projects: indicator_projects
  }
}();
