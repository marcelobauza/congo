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
  years: []
}

Congo.future_projects.action_heatmap = function(){

  init=function(){

        Congo.dashboards.config.style_layer= 'heatmap_test_future_projects';
        Congo.map_utils.counties();
  }
  return {
    init: init,
  }
}();

Congo.future_projects.action_graduated_points = function(){

  init=function(){
    var env1='';
    county_id = Congo.dashboards.config.county_id;
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

    if (county_id != '') {
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

    $.ajax({
      type: 'GET',
      url: '/future_projects/graduated_points.json',
      datatype: 'json',
      data: data ,
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
    if (county_id == '' && centerPoint == '' && wkt.length == 0) {

      Congo.dashboards.action_index.empty_selection_alert();

    // Si se realizó la selección, añade los elementos al dashboard
    } else {

      // Creamos el overlay
      Congo.dashboards.action_index.create_overlay_and_filter_card();

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

          // Establece el nombre de la capa en el navbar
          $('#layer-name').text('Expedientes Municipales');

          // Eliminamos los chart-containter de la capa anterior
          $(".chart-container").remove();

          // Eliminamos los filtros de la capa anterior
          $('.filter-projects').remove();
          $('.filter-transactions').remove();
          $('.filter-building-regulations').remove();
        },
        success: function(data) {

          // Ocultamos el spinner y habilitamos los botones
          $("#spinner").hide();
          $('.btn').removeClass('disabled')
          $('.close').prop('disabled', false);

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

            // TODO: Crear título y boton minimizar dinámicos

            // Creamos título y boton minimizar
            var card_handle = '<span class="fas fa-arrows-alt handle border border-dark">'
            var card_header_button = '<button type="button" class="close" data-toggle="collapse" data-target="#collapse'+i+'" aria-expanded="true" aria-controls="collapse'+i+'" aria-label="Minimize"><i class="fas fa-window-minimize"></i></button>'
            var card_header_title = '<b>'+title+'</b>'

            // Adjuntamos los elementos
            $('.overlay').append(chart_container);
            $('#chart-container'+i).append(card_header, collapse);
            $('#collapse'+i).append(card_body);
            $('#header'+i).append(card_handle, card_header_button, card_header_title);

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
                      serie_colour = '#42d964'
                      break;
                    case 'Permiso de Edificación':
                      serie_colour = '#58b9e2'
                      break;
                    case 'Recepción Municipal':
                      serie_colour = '#f99c00'
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
                  if (title == 'Tipo de Expendiente' || title == 'Tipo de Destino') {
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
                        colour = '#42d964'
                        break;
                      case 'Permiso de edificacion':
                        colour = '#58b9e2'
                        break;
                      case 'Recepcion municipal':
                        colour = '#f99c00'
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

                if (title == 'Tipo de Destino') {
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
