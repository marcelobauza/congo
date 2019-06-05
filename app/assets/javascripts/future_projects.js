Congo.namespace('future_projects.action_graduated_points');
Congo.namespace('future_projects.action_dashboards');

Congo.future_projects.config = {
  county_name: '',
  county_id: '',
  layer_type: 'future_projects_info',
  future_project_type_ids: [],
  project_type_ids: [],
  periods: [],
  years: []
}

Congo.future_projects.action_graduated_points = function(){

  init=function(){
    var env1='';
    $.ajax({
      type: 'GET',
      url: '/future_projects/graduated_points.json',
      datatype: 'json',
      data: {county_id:"52" },
      success: function(data){
        $.each(data['data'], function(index, value){
          str = 'interval'+index+':'+value+';';
          env1 = env1.concat(str);
        })
        Congo.dashboards.config.style_layer= 'graduated_points_calculated_value';
        Congo.dashboards.config.env= env1;
        Congo.map_utils.counties();
      }
    })
  }
  return {
    init: init,
  }
}();

Congo.future_projects.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_future_projects = function(){

    county_id = Congo.dashboards.config.county_id;
    to_year = Congo.dashboards.config.year;
    to_bimester = Congo.dashboards.config.bimester;
    radius = Congo.map_utils.radius * 1000;
    centerPoint = Congo.map_utils.centerpt;
    wkt = Congo.map_utils.size_box;
    future_project_type_ids = Congo.future_projects.config.future_project_type_ids;
    project_type_ids = Congo.future_projects.config.project_type_ids;
    periods = Congo.future_projects.config.periods;
    years = Congo.future_projects.config.years;

    if (county_id != '') {
      data = {
        to_year: to_year,
        to_period: to_bimester,
        future_project_type_ids: future_project_type_ids,
        project_type_ids: project_type_ids,
        periods: periods,
        years: years,
        county_id: county_id
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
        radius: radius
      };
    } else {
      data = {
        to_year: to_year,
        to_period: to_bimester,
        future_project_type_ids: future_project_type_ids,
        project_type_ids: project_type_ids,
        periods: periods,
        years: years,
        wkt: wkt
      };
    };

    $.ajax({
      type: 'GET',
      url: '/future_projects/future_projects_summary.json',
      datatype: 'json',
      data: data,
      success: function(data){

        // Comprobamos si el overlay no está creado y adjuntado
        if ($('.overlay').length == 0) {

          // Creamos y adjuntamos el overlay
          var overlay = document.createElement('div');
          overlay.className = 'overlay';
          $('#map').before(overlay);

        };

        // Eliminamos los chart-containter de la capa anterior
        $(".chart-container").remove();

        // Separamos la información
        for (var i = 0; i < data.length; i++) {

          var reg = data[i];
          var title = reg['title'];
          var series = reg['series'];

          // Creamos el div contenedor
          var chart_container = document.createElement('div');
          chart_container.className = 'chart-container card';
          chart_container.id = 'chart-container'+i;

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
          $('#chart-container'+i).append(card_header, collapse);
          $('#collapse'+i).append(card_body);
          $('#header'+i).append(card_header_button, card_header_title);

          // Información General
          if (title == "Información General") {

            var info = reg['data'];

            // Extraemos y adjuntamos los datos al card-body
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

              if (label == 'Anteproyecto') {
                serie_colour = '#60c843'
              }
              if (label == 'Permiso Edif.' || label == 'Tasa Permiso / Anteproyecto') {
                serie_colour = '#0f115b'
              }
              if (label == 'Recep. Munic.' || label == 'Tasa Recepciones / Permisos') {
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
                  id: [0,1,2],
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
                  id: [3,4,5,6,7,8,9,10,11],
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
                  pointHoverBackgroundColor: '#F2F4F4',
                  pointHoverBorderWidth: 3,
                  pointHitRadius: 5,
                })
              }

              if (title == 'Tasas') {
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
                  filter_item.className = 'text-white bg-secondary px-2 mb-1 py-1 rounded';
                  var filter_item_id = x_tick.split(" ").join("_");
                  filter_item.id = 'item-'+filter_item_id;
                  var close_button_item = '<button type="button" class="close">&times;</button>';
                  var text_item = title+': '+x_tick;

                  // Valida si el item del filtro existe
                  if ($('#item-'+filter_item_id).length == 0) {

                    // Almacena la variable global dependiendo del chart
                    if (title == 'Tipo de Expendiente') {
                      Congo.future_projects.config.future_project_type_ids.push(x_tick_id);
                    } else {
                      Congo.future_projects.config.project_type_ids.push(x_tick_id);
                    };

                    // Adjunta el item del filtro y recarga los datos
                    $('#filter-body').append(filter_item);
                    $('#item-'+filter_item_id).append(text_item, close_button_item);
                    indicator_future_projects();
                  };
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
                onClick: function(c, i) {
                  console.log(x_value);
                  var title = this.options.title.text;

                  // Almacena los valores del chart
                  var x_tick = this.data.labels[i[0]._index];

                  // Crea el filtro
                  var filter_item = document.createElement('div');
                  filter_item.className = 'text-white bg-secondary px-2 mb-1 py-1 rounded';
                  console.log(filter_item);
                  var filter_item_id = x_tick.split("/").join("_");
                  filter_item.id = 'item-'+filter_item_id;
                  console.log(filter_item_id);
                  var close_button_item = '<button type="button" class="close">&times;</button>';
                  console.log(text_item);
                  var text_item = 'Periodo: '+x_tick;

                  // Valida si el item del filtro existe
                  if ($('#item-'+filter_item_id).length == 0) {

                    // Almacena la variable global
                    var periods_years = x_tick.split("/");
                    Congo.future_projects.config.periods.push(periods_years[0]);
                    Congo.future_projects.config.years.push(periods_years[1]);

                    // Adjunta el item del filtro y recarga los datos
                    $('#filter-body').append(filter_item);
                    $('#item-'+filter_item_id).append(text_item, close_button_item);
                    indicator_future_projects();
                  };
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

        // Drag and Drop
        var boxArray = document.getElementsByClassName("overlay");
        var boxes = Array.prototype.slice.call(boxArray);
        dragula({ containers: boxes });

      } // Cierra success
    }) // Cierra ajax
  } // Cierra indicator_future_projects

  return {
    init: init,
    indicator_future_projects: indicator_future_projects
  }
}();
