Congo.namespace('transactions.action_graduated_points');
Congo.namespace('transactions.action_dashboards');

Congo.transactions.config= {
  county_name: '',
  county_id: '',
  layer_type: 'transactions_info',
  property_type_ids: [],
  seller_type_ids: [],
  periods: [],
  years: [],
  from_calculated_value: [],
  to_calculated_value: []
}

Congo.transactions.action_graduated_points = function(){

  init=function(){
    var env1='';

    county_id = Congo.dashboards.config.county_id;
    to_year = Congo.dashboards.config.year;
    to_bimester = Congo.dashboards.config.bimester;
    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
    property_type_ids = Congo.transactions.config.property_type_ids;
    seller_type_ids = Congo.transactions.config.seller_type_ids;
    periods = Congo.transactions.config.periods;
    years = Congo.transactions.config.years;
    from_calculated_value = Congo.transactions.config.from_calculated_value;
    to_calculated_value = Congo.transactions.config.to_calculated_value;
    type_geometry = Congo.dashboards.config.typeGeometry;
    layer_type = Congo.dashboards.config.layer_type;
    style_layer = Congo.dashboards.config.style_layer;


    if (county_id != '') {
      data = {
        to_year: to_year,
        to_period: to_bimester,
        property_type_ids: property_type_ids,
        seller_type_ids: seller_type_ids,
        periods: periods,
        years: years,
        from_calculated_value: from_calculated_value,
        to_calculated_value: to_calculated_value,
        county_id: county_id,
        type_geometry:type_geometry,
        layer_type: layer_type,
        style_layer: style_layer
      };
    } else if (centerPoint != '') {

      data = {
        to_year: to_year,
        to_period: to_bimester,
        property_type_ids: property_type_ids,
        seller_type_ids: seller_type_ids,
        periods: periods,
        years: years,
        from_calculated_value: from_calculated_value,
        to_calculated_value: to_calculated_value,
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
        property_type_ids: property_type_ids,
        seller_type_ids: seller_type_ids,
        periods: periods,
        years: years,
        from_calculated_value: from_calculated_value,
        to_calculated_value: to_calculated_value,
        wkt: JSON.stringify(wkt),
        type_geometry:type_geometry,
        layer_type: layer_type,
        style_layer: style_layer

      };
    }

    $.ajax({
      type: 'GET',
      url: '/transactions/graduated_points.json',
      datatype: 'json',
      data: data,
      success: function(data){
        $.each(data['data'], function(index, value){
          str = 'interval'+index+':'+value+';';
          env1 = env1.concat(str);
        })
        env1 = env1.concat(';color0:ffff00;color1:62d642;color2:3db868;color3:216e9e;color4:090c5e;color5:121CD1;color6:656CED;color7:9196F2;color8:9546F4');
        Congo.dashboards.config.style_layer= 'transaction_calculated_value_graduated_points';
        Congo.dashboards.config.env= env1;

        Congo.map_utils.counties();
      }
    })
  }
  return {
    init: init,
  }
}();

Congo.transactions.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_transactions = function(){

    county_id = Congo.dashboards.config.county_id;
    to_year = Congo.dashboards.config.year;
    to_bimester = Congo.dashboards.config.bimester;
    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
    property_type_ids = Congo.transactions.config.property_type_ids;
    seller_type_ids = Congo.transactions.config.seller_type_ids;
    periods = Congo.transactions.config.periods;
    years = Congo.transactions.config.years;
    from_calculated_value = Congo.transactions.config.from_calculated_value;
    to_calculated_value = Congo.transactions.config.to_calculated_value;
    type_geometry = Congo.dashboards.config.typeGeometry;
    layer_type = Congo.dashboards.config.layer_type;
    style_layer = Congo.dashboards.config.style_layer;

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
          property_type_ids: property_type_ids,
          seller_type_ids: seller_type_ids,
          periods: periods,
          years: years,
          from_calculated_value: from_calculated_value,
          to_calculated_value: to_calculated_value,
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
          property_type_ids: property_type_ids,
          seller_type_ids: seller_type_ids,
          periods: periods,
          years: years,
          from_calculated_value: from_calculated_value,
          to_calculated_value: to_calculated_value,
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
          property_type_ids: property_type_ids,
          seller_type_ids: seller_type_ids,
          periods: periods,
          years: years,
          from_calculated_value: from_calculated_value,
          to_calculated_value: to_calculated_value,
          wkt: JSON.stringify(wkt),
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer
        };

      };

      $.ajax({
        type: 'GET',
        url: '/transactions/transactions_summary.json',
        datatype: 'json',
        data: data,
        beforeSend: function() {
          // Mostramos el spinner y deshabilitamos los botones
          $("#spinner").show();
          $('.btn').addClass('disabled')
          $('.close').prop('disabled', true);

          // Establece el nombre de la capa en el navbar
          $('#layer-name').text('Compraventas CBR');

          // Eliminamos los chart-containter de la capa anterior
          $(".chart-container").remove();

          // Eliminamos los filtros de la capa anterior
          $('.filter-future-projects').remove();
          $('.filter-projects').remove();
          $('.filter-building-regulations').remove();
        },
        success: function(data){

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
                count = z['count']
                count = count.toLocaleString('es-ES')
                item = name+': '+count+'<br>';
                $('#body'+i).append(item);
              })

            // Gráficos
            } else {

              var datasets = [];

              // Extraemos las series
              $.each(series, function(a, b){

                var label = b['label']
                var data = b['data']

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
                  if (title == 'Tipo de Propiedad' || title == 'Tipo de Vendedor') {
                    switch (d['name']) {
                      case 'Propietario':
                        colour = '#85C1E9'
                        break;
                      case 'Inmobiliaria':
                        colour = '#5DADE2'
                        break;
                      case 'Empresa':
                        colour = '#3498DB'
                        break;
                      case 'Banco':
                        colour = '#2E86C1'
                        break;
                      case 'Cooperativa':
                        colour = '#2874A6'
                        break;
                      case 'Municipalidad':
                        colour = '#21618C'
                        break;
                      case 'Sin informacion':
                        colour = '#1B4F72'
                        break;
                    }

                    name_colour.push(colour)
                  }

                })

                // Guardamos "datasets" y "chart_type"
                if (title == 'Tipo de Propiedad') { // Pie
                  chart_type = 'pie';
                  datasets.push({
                    label: label,
                    data: count,
                    id: id,
                    backgroundColor: name_colour,
                  })
                }

                if (title == 'Tipo de Vendedor') { // Pie
                  chart_type = 'pie';
                  datasets.push({
                    label: label,
                    data: count,
                    id: id,
                    backgroundColor: name_colour,
                  })
                }

                // TODO: Falta agregar el chart de Transacciones / Bimestre (line)
                // TODO: Organizar los colores en variables

                if (title == 'UF / Bimestre') { // Line
                  chart_type = 'line';
                  datasets.push({
                    label: label,
                    data: count,
                    fill: false,
                    borderColor: '#58b9e2',
                    borderWidth: 4,
                    pointBackgroundColor: '#e8ebef',
                    pointRadius: 3,
                    lineTension: 0,
                    pointHoverBackgroundColor: '#e8ebef',
                    pointHoverBorderWidth: 3,
                    pointHitRadius: 5,
                  })
                }

                if (title == 'Precio Promedio en UF / Bimestre') { // Line
                  chart_type = 'line';
                  datasets.push({
                    label: label,
                    data: count,
                    fill: false,
                    borderColor: '#58b9e2',
                    borderWidth: 4,
                    pointBackgroundColor: '#e8ebef',
                    pointRadius: 3,
                    lineTension: 0,
                    pointHoverBackgroundColor: '#e8ebef',
                    pointHoverBorderWidth: 3,
                    pointHitRadius: 5,
                  })
                }

                if (title == 'Transacciones / UF') { // Bar
                  chart_type = 'bar';
                  datasets.push({
                    label: label,
                    data: count,
                    backgroundColor: '#58b9e2',
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
                  onClick: function(c, i) {

                    // Almacena los valores del chart
                    var x_tick = this.data.labels[i[0]._index];
                    var title = this.options.title.text;

                    // Crea el filtro
                    var filter_item = document.createElement('div');
                    filter_item.className = 'filter-transactions text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split(" ").join("").split(".").join("");
                    filter_item.id = 'item-'+filter_item_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    var text_item = title+': '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id).length == 0) {

                      // Almacena la variable global dependiendo del chart
                      var filter_item_id_split = filter_item_id.split("-");
                      Congo.transactions.config.from_calculated_value.push(filter_item_id_split[0]);
                      Congo.transactions.config.to_calculated_value.push(filter_item_id_split[1]);

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();
                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {
                      var active_item_from = Congo.transactions.config.from_calculated_value;
                      var active_item_to = Congo.transactions.config.to_calculated_value;

                      var item_full_id = $('#item-'+filter_item_id).attr('id');

                      item_full_id = item_full_id.split("-");
                      var from_item_id = item_full_id[1];
                      var to_item_id = item_full_id[2];

                      var active_item_from_updated = $.grep(active_item_from, function(n, i) {
                        return n != from_item_id;
                      });

                      var active_item_to_updated = $.grep(active_item_to, function(n, i) {
                        return n != to_item_id;
                      });

                      Congo.transactions.config.from_calculated_value = active_item_from_updated;
                      Congo.transactions.config.to_calculated_value = active_item_to_updated;

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
                      stacked: true,
                      ticks: {
                        autoSkip: false,
                        maxRotation: 30,
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

                // TODO: Configurar los datalabels utilizando el valor total

                var chart_options = {
                  onClick: function(c, i) {

                    // Almacena los valores del chart
                    var x_tick = this.data.labels[i[0]._index];
                    var x_tick_id = this.data.datasets[0].id[i[0]._index];
                    var title = this.options.title.text;

                    // Crea el filtro
                    var filter_item = document.createElement('div');
                    filter_item.className = 'filter-transactions text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split(" ").join("_");
                    filter_item.id = 'item-'+filter_item_id+'-'+x_tick_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    var text_item = title+': '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id+'-'+x_tick_id).length == 0) {

                      // Almacena la variable global dependiendo del chart
                      if (title == 'Tipo de Propiedad') {
                        Congo.transactions.config.property_type_ids.push(x_tick_id);
                      } else {
                        Congo.transactions.config.seller_type_ids.push(x_tick_id);
                      };

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id+'-'+x_tick_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();
                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {

                      if (title == 'Tipo de Propiedad') {
                        var active_items = Congo.transactions.config.property_type_ids;
                      } else {
                        var active_items = Congo.transactions.config.seller_type_ids;
                      };

                      var item_full_id = $('#item-'+filter_item_id+'-'+x_tick_id).attr('id');
                      item_full_id = item_full_id.split("-")
                      var item_id = item_full_id[2]

                      var active_items_updated = $.grep(active_items, function(n, i) {
                        return n != item_id;
                      });

                      if (title == 'Tipo de Propiedad') {
                        Congo.transactions.config.property_type_ids = active_items_updated;
                      } else {
                        Congo.transactions.config.seller_type_ids = active_items_updated;
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
                        return value > 1000;
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
                    filter_item.className = 'filter-transactions text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split("/").join("-");
                    filter_item.id = 'item-'+filter_item_id;
                    var close_button_item = '<button type="button" class="close" id="close-'+filter_item_id+'">&times;</button>';
                    var text_item = 'Periodo: '+x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-'+filter_item_id).length == 0) {

                      // Almacena la variable global
                      var periods_years = x_tick.split("/");
                      Congo.transactions.config.periods.push(periods_years[0]);
                      Congo.transactions.config.years.push(20+periods_years[1]);

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-'+filter_item_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();
                    };

                    // Elimina item del filtro
                    $('#close-'+filter_item_id).click(function() {

                      var active_periods = Congo.transactions.config.periods;
                      var active_years = Congo.transactions.config.years;

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

                      Congo.transactions.config.periods = periods_updated;
                      Congo.transactions.config.years = years_updated;

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
        } // Cierra success
      }) // Cierra ajax
    } // Cierra if alert
  } // Cierra indicator_transactions

  return {
    init: init,
    indicator_transactions: indicator_transactions
  }
}();
