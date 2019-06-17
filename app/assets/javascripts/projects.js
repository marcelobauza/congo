Congo.namespace('projects.action_dashboards');

Congo.projects.config= {
  county_name: '',
  county_id: '',
  layer_type: 'projects_info',
  project_status_ids: [],
  project_type_ids: [],
  mix_ids: [],
  periods: [],
  years: [],
  from_floor: [],
  to_floor: [],
  from_uf_value: [],
  to_uf_value: [],
  project_agency_ids: []
}

Congo.projects.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_projects = function(){

    county_id = Congo.dashboards.config.county_id;
    to_year = Congo.dashboards.config.year;
    to_bimester = Congo.dashboards.config.bimester;
    radius = Congo.map_utils.radius * 1000;
    centerPoint = Congo.map_utils.centerpt;
    wkt = Congo.map_utils.size_box;
    project_status_ids = Congo.projects.config.project_status_ids;
    project_type_ids = Congo.projects.config.project_type_ids;
    mix_ids = Congo.projects.config.mix_ids;
    periods = Congo.projects.config.periods;
    years = Congo.projects.config.years;
    from_floor = Congo.projects.config.from_floor;
    to_floor = Congo.projects.config.to_floor;
    from_uf_value = Congo.projects.config.from_uf_value;
    to_uf_value = Congo.projects.config.to_uf_value;
    project_agency_ids = Congo.projects.config.project_agency_ids;

    if (county_id != '') {
      data = {
        to_year: to_year,
        to_period: to_bimester,
        periods_quantity: "5",
        project_status_ids: project_status_ids,
        project_type_ids: project_type_ids,
        mix_ids: mix_ids,
        periods: periods,
        years: years,
        from_floor: from_floor,
        to_floor: to_floor,
        from_uf_value: from_uf_value,
        to_uf_value: to_uf_value,
        project_agency_ids: project_agency_ids,
        county_id: county_id
      };
    } else if (centerPoint != '') {
      data = {
        to_year: to_year,
        to_period: to_bimester,
        periods_quantity: "5",
        project_status_ids: project_status_ids,
        project_type_ids: project_type_ids,
        mix_ids: mix_ids,
        periods: periods,
        years: years,
        from_floor: from_floor,
        to_floor: to_floor,
        from_uf_value: from_uf_value,
        to_uf_value: to_uf_value,
        project_agency_ids: project_agency_ids,
        centerpt: centerPoint,
        radius: radius
      };
    } else {
      data = {
        to_year: to_year,
        to_period: to_bimester,
        periods_quantity: "5",
        project_status_ids: project_status_ids,
        project_type_ids: project_type_ids,
        mix_ids: mix_ids,
        periods: periods,
        years: years,
        from_floor: from_floor,
        to_floor: to_floor,
        from_uf_value: from_uf_value,
        to_uf_value: to_uf_value,
        project_agency_ids: project_agency_ids,
        wkt: wkt
      };
    };

    $.ajax({
      type: 'GET',
      url: '/projects/projects_summary.json',
      datatype: 'json',
      data: data,
      beforeSend: function() {
        // Mostramos el spinner
        $("#spinner").show();

        // Establece el nombre de la capa en el navbar
        $('#layer-name').text('Proyectos Residenciales');

        // Eliminamos los chart-containter de la capa anterior
        $(".chart-container").remove();

        // Eliminamos los filtros de la capa anterior
        $('.filter-future-projects').remove();
        $('.filter-transactions').remove();
      },
      success: function(data){

        // Ocultamos el spinner
        $("#spinner").hide();

        // Comprobamos si el overlay no está creado y adjuntado
        if ($('.overlay').length == 0) {

          // Creamos y adjuntamos el overlay
          var overlay = document.createElement('div');
          overlay.className = 'overlay';
          $('#map').before(overlay);

        };

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
              var id = [];

              // Extraemos los datos de las series
              $.each(data, function(c, d){
                name.push(d['name'])
                count.push(d['count'])
                id.push(d['id'])
              })

              // Guardamos "datasets" y "chart_type"
              if (title == 'Estado del Proyecto') {
                chart_type = 'pie';
                datasets.push({
                  label: label,
                  data: count,
                  id: id,
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
                  id: id,
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
                  id: id,
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

              // Armamos las opciones de Total Distribución por Mix por separado
              if (title == 'Total Distribución por Mix') {

                var chart_options = {
                  onClick: function(c, i) {

                    // Almacena los valores del chart
                    var x_tick = this.data.labels[i[0]._index];
                    var x_tick_id = this.data.datasets[0].id[i[0]._index];
                    var title = this.options.title.text;

                    // Crea el filtro
                    var filter_item = document.createElement('div');
                    filter_item.className = 'filter-projects text-white bg-secondary px-2 mb-1 py-1 rounded';
                    var filter_item_id = x_tick.split(",").join("_");
                    filter_item.id = 'item-'+filter_item_id+'-'+x_tick_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    var text_item = title+': '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id+'-'+x_tick_id).length == 0) {

                      // Almacena la variable global
                      Congo.projects.config.mix_ids.push(x_tick_id);

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id+'-'+x_tick_id).append(text_item, close_button_item);
                      indicator_projects();
                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {

                      var active_items = Congo.projects.config.mix_ids;

                      var item_full_id = $('#item-'+filter_item_id+'-'+x_tick_id).attr('id');
                      item_full_id = item_full_id.split("-")
                      var item_id = item_full_id[2]

                      var active_items_updated = $.grep(active_items, function(n, i) {
                        return n != item_id;
                      });

                      Congo.projects.config.mix_ids = active_items_updated;

                      $('#item-'+filter_item_id+'-'+x_tick_id).remove();
                      indicator_projects();

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
                  scales: {
                    xAxes: [{
                      stacked: true,
                      ticks: {
                        display: false,
                      }
                    }],
                    yAxes: [{
                      stacked: true,
                      ticks: {
                        beginAtZero: true,
                      },
                    }],
                  }
                };
              } else {

                var chart_options = {
                  onClick: function(c, i) {

                    // Almacena los valores del chart
                    var x_tick = this.data.labels[i[0]._index];
                    var title = this.options.title.text;

                    // Crea el filtro
                    var filter_item = document.createElement('div');
                    filter_item.className = 'filter-projects text-white bg-secondary px-2 mb-1 py-1 rounded';
                    var filter_item_id = x_tick.split(" ").join("");
                    filter_item.id = 'item-'+filter_item_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    if (title == 'Unidades Proyecto por Rango UF') {
                      title = 'Valor UF';
                    }
                    var text_item = title+': '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id).length == 0) {

                      // Almacena la variable global dependiendo del chart
                      var filter_item_id_split = filter_item_id.split("-");
                      if (title == 'Cantidad de Pisos') {
                        Congo.projects.config.from_floor.push(filter_item_id_split[0]);
                        Congo.projects.config.to_floor.push(filter_item_id_split[1]);
                      } else {
                        Congo.projects.config.from_uf_value.push(filter_item_id_split[0]);
                        Congo.projects.config.to_uf_value.push(filter_item_id_split[1]);
                      };

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id).append(text_item, close_button_item);
                      indicator_projects();
                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {
                      if (title == 'Cantidad de Pisos') {
                        var active_item_from = Congo.projects.config.from_floor;
                        var active_item_to = Congo.projects.config.to_floor;
                      } else {
                        var active_item_from = Congo.projects.config.from_uf_value;
                        var active_item_to = Congo.projects.config.to_uf_value;
                      };

                      var item_full_id = $('#item-'+filter_item_id).attr('id');

                      item_full_id = item_full_id.split("-");
                      var from_floor_id = item_full_id[1];
                      var to_floor_id = item_full_id[2];

                      var active_item_from_updated = $.grep(active_item_from, function(n, i) {
                        return n != from_floor_id;
                      });

                      var active_item_to_updated = $.grep(active_item_to, function(n, i) {
                        return n != to_floor_id;
                      });
                      if (title == 'Cantidad de Pisos') {
                        Congo.projects.config.from_floor = active_item_from_updated;
                        Congo.projects.config.to_floor = active_item_to_updated;
                      } else {
                        Congo.projects.config.from_uf_value = active_item_from_updated;
                        Congo.projects.config.to_uf_value = active_item_to_updated;
                      };

                      $('#item-'+filter_item_id).remove();
                      indicator_projects();

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
                  scales: {
                    xAxes: [{
                      stacked: true,
                      ticks: {
                        autoSkip: false,
                        maxRotation: 12,
                      }
                    }],
                    yAxes: [{
                      stacked: true,
                      ticks: {
                        beginAtZero: true,
                      },
                    }],
                  }
                };
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
                  filter_item.className = 'filter-projects text-white bg-secondary px-2 mb-1 py-1 rounded';
                  var filter_item_id = x_tick.split(" ").join("_");
                  filter_item.id = 'item-'+filter_item_id+'-'+x_tick_id;
                  var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                  var text_item = title+': '+x_tick;

                  // Valida si el item del filtro existe
                  if ($('#item-'+filter_item_id+'-'+x_tick_id).length == 0) {

                    // Almacena la variable global dependiendo del chart
                    if (title == 'Estado del Proyecto') {
                      Congo.projects.config.project_status_ids.push(x_tick_id);
                    } else {
                      Congo.projects.config.project_type_ids.push(x_tick_id);
                    };

                    // Adjunta el item del filtro y recarga los datos
                    $('#filter-body').append(filter_item);
                    $('#item-'+filter_item_id+'-'+x_tick_id).append(text_item, close_button_item);
                    indicator_projects();
                  };

                  // Elimina item del filtro
                  $('#close-'+filter_item_id).click(function() {

                    if (title == 'Estado del Proyecto') {
                      var active_items = Congo.projects.config.project_status_ids;
                    } else {
                      var active_items = Congo.projects.config.project_type_ids;
                    };

                    var item_full_id = $('#item-'+filter_item_id+'-'+x_tick_id).attr('id');
                    item_full_id = item_full_id.split("-")
                    var item_id = item_full_id[2]

                    var active_items_updated = $.grep(active_items, function(n, i) {
                      return n != item_id;
                    });

                    if (title == 'Estado del Proyecto') {
                      Congo.projects.config.project_status_ids = active_items_updated;
                    } else {
                      Congo.projects.config.project_type_ids = active_items_updated;
                    };

                    $('#item-'+filter_item_id+'-'+x_tick_id).remove();
                    indicator_projects();
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

                  // Almacena los valores del chart
                  var x_tick = this.data.labels[i[0]._index];

                  // Crea el filtro
                  var filter_item = document.createElement('div');
                  filter_item.className = 'filter-projects text-white bg-secondary px-2 mb-1 py-1 rounded';
                  var filter_item_id = x_tick.split("/").join("-");
                  filter_item.id = 'item-'+filter_item_id;
                  var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                  var text_item = 'Periodo: '+x_tick;

                  // Valida si el item del filtro existe
                  if ($('#item-'+filter_item_id).length == 0) {

                    // Almacena la variable global
                    var periods_years = x_tick.split("/"); // NOTE: Reveer el uso de x_tick en vez de filter_item_id
                    Congo.projects.config.periods.push(periods_years[0]);
                    Congo.projects.config.years.push(20+periods_years[1]);

                    // Adjunta el item del filtro y recarga los datos
                    $('#filter-body').append(filter_item);
                    $('#item-'+filter_item_id).append(text_item, close_button_item);
                    indicator_projects();
                  };

                  // Elimina item del filtro
                  $('#close-'+filter_item_id).click(function() {

                    var active_periods = Congo.projects.config.periods;
                    var active_years = Congo.projects.config.years;

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

                    Congo.projects.config.periods = periods_updated;
                    Congo.projects.config.years = years_updated;

                    $('#item-'+filter_item_id).remove();
                    indicator_projects();

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
  } // Cierra indicator_projects

  return {
    init: init,
    indicator_projects: indicator_projects
  }
}();
