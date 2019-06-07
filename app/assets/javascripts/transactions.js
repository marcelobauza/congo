Congo.namespace('transactions.action_graduated_points');
Congo.namespace('transactions.action_dashboards');

Congo.transactions.config= {
  county_name: '',
  county_id: '',
  layer_type: 'transactions_info'
}

Congo.transactions.action_graduated_points = function(){

  init=function(){
    var env1='';
    $.ajax({
      type: 'GET',
      url: '/transactions/graduated_points.json',
      datatype: 'json',
      data: {county_id:"52" },
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
    radius = Congo.map_utils.radius * 1000;
    centerPoint = Congo.map_utils.centerpt;
    wkt = Congo.map_utils.size_box;

    if (county_id != ''){
          data ={to_year: to_year, to_period: to_bimester, county_id: county_id};
    }else if(centerPoint !=''){
      data = {to_year: to_year, to_period: to_bimester, centerpt: centerPoint, radius: radius};
    }else{
      data = {to_year: to_year, to_period: to_bimester, wkt: wkt};
    }

    $.ajax({
      type: 'GET',
      url: '/transactions/transactions_summary.json',
      datatype: 'json',
      data: data,
      beforeSend: function() {
        // Mostramos el spinner
        $("#spinner").show();

        // Establece el nombre de la capa en el navbar
        $('#layer-name').text('Compraventas CBR');

        // Eliminamos los chart-containter de la capa anterior
        $(".chart-container").remove();
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

              var name = [];
              var count = [];

              // Extraemos los datos de las series
              $.each(data, function(c, d){
                name.push(d['name'])
                count.push(d['count'])
              })

              // Guardamos "datasets" y "chart_type"
              if (title == 'Tipo de Propiedad') { // Pie
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
                      '#EAEDED',
                      '#F4F6F6'
                  ],
                })
              }

              if (title == 'Tipo de Vendedor') { // Pie
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
                    '#EAEDED',
                    '#F4F6F6'
                  ],
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

              if (title == 'Precio Promedio en UF / Bimestre') { // Line
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

              if (title == 'Transacciones / UF') { // Bar
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

              var chart_options = {
                onClick: function(c, i) {
                  var x_value = this.data.labels[i[0]._index];
                  var title = this.options.title.text;
                  var filter_item = document.createElement('div');
                  filter_item.className = 'text-white bg-secondary px-2 mb-1 py-1 rounded';
                  var filter_item_id = x_value.split(" ").join("_");
                  filter_item.id = 'item-'+filter_item_id;
                  var close_button_item = '<button type="button" class="close">&times;</button>';
                  var text_item = title+': '+x_value;
                  if ($('#item-'+filter_item_id).length == 0) {
                    $('#filter-body').append(filter_item);
                    $('#item-'+filter_item_id).append(text_item, close_button_item);
                  };
                },
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

            } else if (chart_type == 'pie') { // Pie

              // TODO: Configurar los datalabels utilizando el valor total

              var chart_options = {
                onClick: function(c, i) {
                  var x_value = this.data.labels[i[0]._index];
                  var title = this.options.title.text;
                  var filter_item = document.createElement('div');
                  filter_item.className = 'text-white bg-secondary px-2 mb-1 py-1 rounded';
                  var filter_item_id = x_value.split(" ").join("_");
                  filter_item.id = 'item-'+filter_item_id;
                  var close_button_item = '<button type="button" class="close">&times;</button>';
                  var text_item = title+': '+x_value;
                  if ($('#item-'+filter_item_id).length == 0) {
                    $('#filter-body').append(filter_item);
                    $('#item-'+filter_item_id).append(text_item, close_button_item);
                  };
                },
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
                  var x_value = this.data.labels[i[0]._index];
                  var title = this.options.title.text;
                  var filter_item = document.createElement('div');
                  filter_item.className = 'text-white bg-secondary px-2 mb-1 py-1 rounded';
                  var filter_item_id = x_value.split("/").join("_");
                  filter_item.id = 'item-'+filter_item_id;
                  var close_button_item = '<button type="button" class="close">&times;</button>';
                  var text_item = title+': '+x_value;
                  if ($('#item-'+filter_item_id).length == 0) {
                    $('#filter-body').append(filter_item);
                    $('#item-'+filter_item_id).append(text_item, close_button_item);
                  };
                },
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
  } // Cierra indicator_transactions

  return {
    init: init,
    indicator_transactions: indicator_transactions
  }
}();
