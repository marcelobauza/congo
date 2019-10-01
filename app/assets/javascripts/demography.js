Congo.namespace('demography.action_dashboards');

Congo.demography.action_dashboards = function(){
  init=function(){
    Congo.map_utils.init();
  }

  indicator_demography = function(){

    county_id = [];
    $.each(Congo.dashboards.config.county_id, function(a,b){
       county_id =b;
    })

    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
    type_geometry = Congo.dashboards.config.typeGeometry;
    layer_type = Congo.dashboards.config.layer_type;
    style_layer = Congo.dashboards.config.style_layer;

    // Creamos el overlay y el census_selector
    Congo.dashboards.action_index.create_overlay_and_filter_card();
    Congo.dashboards.action_index.add_census_selector();

    if (county_id != '') {

      // Agregamos filtro Comuna
      Congo.dashboards.action_index.add_county_filter_item()

      data = {
        county_id: county_id,
        type_geometry:type_geometry,
        layer_type: layer_type,
        style_layer: style_layer
      };
    }

    $.ajax({
      type: 'GET',
      url: '/demography/general.json',
      datatype: 'json',
      data: data,
      beforeSend: function() {

        // Mostramos el spinner y deshabilitamos los botones
        $("#spinner").show();
        $('.btn').addClass('disabled')
        $('.close').prop('disabled', true);

        // Establece el nombre de la capa en el navbar
        $('#layer-name').text('Demografía & Gasto');

        // Mostramos los iconos de Útiles correspondientes
        $("#boost").hide();
        $("#base").hide();
        $("#graph").hide();

        // Mostramos el icono de Puntos Proporcionales correspondiente
        $("#prop-prv").hide();
        $("#prop-cbr").hide();
        $("#prop-em").hide();

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
        $('.filter-future-projects').hide();

        // Eliminamos el time_slider
        $('#time_slider_item').remove()

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
          if (title == 'Resumen') {

            var info = reg['data'];

            // Extraemos y adjuntamos los datos al card-body
            $.each(info, function(y, z) {
              name = z['name'];
              count = z['count']
              count = count.toLocaleString('es-ES')
              item = name + ': ' + count + '<br>';
              $('#body' + i).append(item);
            })

          // Gráficos
          } else {

            var info = reg['data']
            var datasets = [];
            var name = [];
            var count = [];

            // Extraemos los datos de las series
            $.each(info, function(c, d){
              name.push(d['name'])
              count.push(d['count'])
            })

            // Guardamos "datasets" y "chart_type"
            chart_type = 'pie';
            datasets.push({
              data: count,
              backgroundColor: [
                'rgb(39,174,96)',
                'rgb(231,76,60)',
                'rgb(211,84,0)',
                'rgb(41,128,185)',
                'rgb(241,196,15)',
                '#8E44AD',
                '#EC7063'
              ],
            })

            chart_data = {
              labels: name,
              datasets: datasets
            }

            // Guardamos "options"
            var chart_options = {
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

          } // Cierra else
        } // Cierra for
      } // Cierra success
    }) // Cierra ajax
  } // Cierra indicator_demography
  return {
    init: init,
    indicator_demography: indicator_demography
  }
}();
