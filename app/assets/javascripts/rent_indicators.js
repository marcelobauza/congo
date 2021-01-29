Congo.namespace('rent_indicators.action_dashboards');

Congo.projects.config = {
  county_name: '',
  county_id: '',
  layer_type: 'rent_indicators_info',
  project_status_ids: [],
  project_type_ids: [],
  mix_ids: [],
  periods: [],
  years: [],
  from_floor: [],
  to_floor: [],
  from_uf_value: [],
  to_uf_value: [],
  project_agency_ids: [],
  legends: []
}



function rent_indicators_report_pdf() {

  $.ajax({
    type: 'GET',
    url: '/reports/rent_indicators_pdf.json',
    datatype: 'json',
    data: data,
    success: function(data) {

      console.log('data que llega');
      console.log(data);

      data = '{"charts":[{"title":"Distribución Programas","series":[{"label":"Parque","data":[{"name":"1|1","count":23,"id":28},{"name":"2|1","count":18,"id":31},{"name":"2|2","count":28,"id":30},{"name":"3|1","count":9,"id":29},{"name":"3|2","count":21,"id":29},{"name":"4+","count":1,"id":29}]},{"label":"Oferta","data":[{"name":"1|1","count":48,"id":28},{"name":"2|1","count":10,"id":31},{"name":"2|2","count":26,"id":30},{"name":"3|1","count":1,"id":29},{"name":"3|2","count":13,"id":29},{"name":"4+","count":2,"id":29}]}]},{"title":"Superficie","series":[{"label":"Arriendo","data":[{"name":"6/19","count":54},{"name":"1/20","count":54},{"name":"2/20","count":53},{"name":"3/20","count":59},{"name":"4/20","count":60},{"name":"5/20","count":54}]},{"label":"Venta","data":[{"name":"6/19","count":55},{"name":"1/20","count":49},{"name":"2/20","count":55},{"name":"3/20","count":61},{"name":"4/20","count":56},{"name":"5/20","count":54}]}]},{"title":"Precio UF mes","series":[{"label":"Arriendo","data":[{"name":"6/19","count":13.5},{"name":"1/20","count":14},{"name":"2/20","count":15.1},{"name":"3/20","count":15},{"name":"4/20","count":14},{"name":"5/20","count":15}]},{"label":"Venta","data":[{"name":"6/19","count":2000},{"name":"1/20","count":2200},{"name":"2/20","count":2000},{"name":"3/20","count":2500},{"name":"4/20","count":1900},{"name":"5/20","count":2100}]}]},{"title":"UFm2 mes","series":[{"label":"Arriendo","data":[{"name":"6/19","count":0.27},{"name":"1/20","count":0.27},{"name":"2/20","count":0.28},{"name":"3/20","count":0.28},{"name":"4/20","count":0.27},{"name":"5/20","count":0.27}]},{"label":"Venta","data":[{"name":"6/19","count":38},{"name":"1/20","count":48},{"name":"2/20","count":38},{"name":"3/20","count":40},{"name":"4/20","count":36},{"name":"5/20","count":41}]}]},{"title":"Relación Precios | Vacancia","series":[{"label":"Arriendo/Venta","data":[{"name":"6/19","count":0.72},{"name":"1/20","count":0.58},{"name":"2/20","count":0.76},{"name":"3/20","count":0.7},{"name":"4/20","count":0.78},{"name":"5/20","count":0.62}]},{"label":"Vacancia","data":[{"name":"6/19","count":2.6},{"name":"1/20","count":1.8},{"name":"2/20","count":1.7},{"name":"3/20","count":1.2},{"name":"4/20","count":1.1},{"name":"5/20","count":1.2}]}]}]}'

      data = JSON.parse(data)

      console.log(data);

      // Creamos el doc
      var doc = new jsPDF();

      doc.page = 1;

      // Pie de página
      function footer() {
        doc.setFontStyle("bold");
        doc.setFontSize(12);
        doc.text('Fuente:', 20, 290);
        doc.setFontStyle("normal");
        doc.text('Preguntar a Marce cuál es la fuente', 37, 290);
        doc.setFontSize(10);
        doc.text('p. ' + doc.page, 194, 290);
        doc.page++;
      };

      // Título
      doc.setFontStyle("bold");
      doc.setFontSize(22);
      doc.text('Informe de Indicadores Claves de Arriendo', 105, 20, null, null, 'center');

      // Subtítulo
      doc.setFontSize(16);
      doc.text('Información General', 105, 35, null, null, 'center');

      // Validamos si hay algún filtro aplicado
      if (periods == '') {

        // Periodo Actual
        doc.setFontSize(12);
        doc.setFontStyle("bold");
        doc.text('Periodo de tiempo seleccionado:', 10, 49);
        doc.setFontStyle("normal");
        doc.text(to_bimester + '° bimestre del ' + to_year, 78, 49);

      } else {

        // Periodos Filtrados
        doc.setFontSize(12);
        doc.setFontStyle("bold");
        doc.text('Periodos de tiempo seleccionados:', 10, 49);
        doc.setFontStyle("normal");
        var tab = 83
        for (var i = 0; i < periods.length; i++) {
          doc.text(periods[i] + '/' + years[i] + ', ', tab, 49);
          tab = tab + 16
        }

      }

      // Pie de página
      footer()

      // Agrega nueva página
      doc.addPage('a4', 'portrait')

      $.each(data, function(key, value) {

        if (key == 'charts') {

          for (var i = 0; i < value.length; i++) {

            var reg = value[i];
            var title = reg['title'];
            var series = reg['series'];
            var datasets = [];
            var serie_colour;

            // Extraemos las series
            $.each(series, function(a, b) {

              var label = b['label']
              var data = b['data']

              if (a == 0) {
                position_y_axis = 'right-y-axis'
              } else {
                position_y_axis = 'left-y-axis'
              }

              // Setea los colores dependiendo de la serie
              if (title == 'Superficie' || title == 'Precio UF mes' || title == 'UFm2 mes' || title == 'Relación Precios | Vacancia') {

                switch (label) {
                  case 'Arriendo':
                  case 'Arriendo/Venta':
                    serie_colour = '#ff0000'
                    break;
                  case 'Promedio':
                  case 'Venta':
                  case 'Vacancia':
                    serie_colour = '#5dceaf'
                    break;
                }
              }

              var name = [];
              var count = [];
              var id = [];
              var name_colour = [];
              var colour;

              // Extraemos los datos de las series
              $.each(data, function(c, d) {
                name.push(d['name'])
                count.push(d['count'])
                id.push(d['id'])

                // Setea los colores dependiendo del label
                if (title == 'Distribución Programas') {
                  switch (d['name']) {
                    case '1|1':
                      colour = '#4e67c8'
                      break;
                    case '2|1':
                      colour = '#5eccf3'
                      break;
                    case '2|2':
                      colour = '#a7ea52'
                      break;
                    case '3|1':
                      colour = '#5dceaf'
                      break;
                    case '3|2':
                      colour = '#ff8021'
                      break;
                    case '4+':
                      colour = '#f14124'
                      break;
                  }

                  name_colour.push(colour)
                }

              })

              // Guardamos "datasets" y "chart_type"
              if (title == 'Distribución Programas') {
                chart_type = 'doughnut';
                datasets.push({
                  label: label,
                  data: count,
                  id: id,
                  backgroundColor: name_colour,
                })
              }

              if (title == 'Superficie') {
                chart_type = 'line';
                position_y_axis =
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

              if (title == 'Precio UF mes' || title == 'UFm2 mes' || title == 'Relación Precios | Vacancia') {
                chart_type = 'line';
                position_y_axis =
                  datasets.push({
                    label: label,
                    data: count,
                    yAxisID: position_y_axis,
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
            if (chart_type == 'doughnut') { // Doughnut

              var chart_options = {
                animation: false,
                responsive: true,
                title: {
                  display: false
                },
                legend: {
                  display: true,
                  position: 'bottom',
                  labels: {
                    fontColor: '#3d4046',
                    fontSize: 12,
                    usePointStyle: true,
                  }
                },
                plugins: {
                  datalabels: {
                    formatter: (value, ctx) => {
                      // Mustra sólo los valores (en porcentajes) que estén por encima del 3%
                      let sum = 0;
                      let dataArr = ctx.chart.data.datasets[0].data;
                      dataArr.map(data => {
                        sum += data;
                      });
                      let percentage = (value * 100 / sum).toFixed(2);
                      if (percentage > 4) {
                        return percentage + '%';
                      } else {
                        return null;
                      }
                    },
                    align: 'center',
                    anchor: 'center',
                    color: '#FFFFFF',
                    font: {
                      weight: 'bold'
                    },
                    textStrokeColor: '#3d4046',
                    textStrokeWidth: 1,
                    textShadowColor: '#000000',
                    textShadowBlur: 3,
                  }
                },
              };

            } else { // Line

              if (title != 'Superficie') {

                y_axes = [{
                  id: 'left-y-axis',
                  position: 'left',
                  ticks: {
                    callback: function(label, index, labels) {
                      label = label.toLocaleString('es-ES')
                      return label;
                    },
                    beginAtZero: true,
                    display: true,
                    fontSize: 10,
                    fontColor: '#3d4046'
                  },
                }, {
                  id: 'right-y-axis',
                  position: 'right',
                  ticks: {
                    callback: function(label, index, labels) {
                      label = label.toLocaleString('es-ES')
                      return label;
                    },
                    beginAtZero: true,
                    display: true,
                    fontSize: 10,
                    fontColor: '#3d4046'
                  },
                }]

              } else {

                y_axes = [{
                  ticks: {
                    callback: function(label, index, labels) {
                      label = label.toLocaleString('es-ES')
                      return label;
                    },
                    beginAtZero: true,
                    display: true,
                    fontSize: 10,
                    fontColor: '#3d4046'
                  },
                }]

              }

              var chart_options = {
                animation: false,
                responsive: true,
                title: {
                  display: false
                },
                legend: {
                  display: true,
                  position: 'bottom',
                  labels: {
                    fontColor: '#3d4046',
                    fontSize: 12,
                    usePointStyle: true,
                  }
                },
                plugins: {
                  datalabels: {
                    formatter: function(value, context) {
                      if (value > 0) {
                        return value.toLocaleString('es-ES')
                      } else {
                        return null
                      }
                    },
                    align: 'start',
                    anchor: 'start',
                    color: '#3d4046',
                    font: {
                      size: 10
                    },
                  }
                },
                scales: {
                  xAxes: [{
                    // stacked: true,
                    ticks: {
                      display: true,
                      fontSize: 10,
                      fontColor: '#3d4046'
                    }
                  }],
                  yAxes: y_axes,
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
            canvas.id = 'report-canvas-' + i;

            $('#chart-report' + i).append(canvas);

            var chart_canvas = document.getElementById('report-canvas-' + i).getContext('2d');
            var final_chart = new Chart(chart_canvas, chart_settings);

            var chart = final_chart.toBase64Image();

            if (i % 2 != 1) {

              // Título del gráfico
              doc.setFontSize(16);
              doc.setFontStyle("bold");
              doc.text(title, 105, 20, null, null, 'center');

              // Gráfico
              doc.addImage(chart, 'JPEG', 9, 30);

            } else {

              // Título del gráfico
              doc.setFontSize(16);
              doc.setFontStyle("bold");
              doc.text(title, 105, 160, null, null, 'center');

              // Gráfico
              doc.addImage(chart, 'JPEG', 9, 170);

              // Agrega nueva página
              doc.addPage('a4', 'portrait')

              // Pie de página
              footer()

            } // Cierra if impar
          }
        }
      })

      // Descarga el archivo PDF
      doc.save("Informe_ICA.pdf");

    } // Cierra success
  }) // Cierra ajax
} // Cierra function projects_report_pdf


Congo.rent_indicators.action_dashboards = function() {

  init = function() {
    Congo.map_utils.init();
  }


  indicators = function(nId) {

    console.log(nId);

    Congo.dashboards.action_index.create_overlay_and_filter_card();
    Congo.dashboards.action_index.add_time_slider();
    $("#spinner").hide();

    // Establece el nombre de la capa en el navbar
    $('#layer-name').text('Indicadores Clave de Arriendo');

    // Mostramos los iconos de Útiles correspondientes
    $("#boost").hide();
    $("#base").hide();
    $("#graph").hide();
    $("#census").hide();
    $("#kml").hide();

    // Mostramos el icono de Puntos/Poligonos correspondiente
    $("#type_point").hide();
    $("#poly_build").hide();
    $("#vor_dem").hide();

    // Mostramos el icono de Puntos Proporcionales correspondiente
    $("#prop-prv").hide();
    $("#prop-cbr").hide();
    $("#prop-em").hide();

    // Mostramos el icono de Heatmap correspondiente
    $("#heat-prv").hide();
    $("#heat-cbr").hide();
    $("#heat-em-dem").hide();

    // Mostramos el icono de colorear polígonos
    $("#col-ica").show();

    // Eliminamos los chart-containter de la capa anterior
    $(".chart-container").remove();

    // Mostramos el filtro de la capa y ocultamos los demás
    $('.filter-building-regulations').hide();
    $('.filter-transactions').hide();
    $('.filter-projects').hide();
    $('.filter-future-projects').hide();

    // Eliminamos el time_slider de cbr y el census_filter
    $('#time_slider_cbr_item').remove()
    $('#census_filter').remove()


    if (nId != undefined) {

      console.log('-- Sin selección');


      to_year = Congo.dashboards.config.year;
      to_bimester = Congo.dashboards.config.bimester;
      var data = {
        to_year: to_year,
        to_period: to_bimester,
        id: nId
      }


      // TODO: Acá se debería agregar o eliminar el filtro de comuna
      // pero ese código ya no está en este archivo. Revisar

      $.ajax({
        type: 'GET',
        url: '/rent_indicators/rent_indicators_summary.json',
        datatype: 'json',
        data: data,
        beforeSend: function() {

          // Mostramos el spinner y deshabilitamos los botones
          $("#spinner").show();
          $('.btn').addClass('disabled')
          $('.close').prop('disabled', true);
          // $("#time_slider").data("ionRangeSlider").update({
          //   block: true
          // });

        },
        success: function(data) {

          console.log('Data de ICA:');
          console.log(data);

          // Ocultamos el spinner y habilitamos los botones
          $("#spinner").hide();
          $('.btn').removeClass('disabled')
          $('.close').prop('disabled', false);

          bimester = Congo.dashboards.config.bimester;
          year = Congo.dashboards.config.year;
          periods = `${bimester}/${year}`;
          slider_periods = Congo.dashboards.config.slider_periods
          from = slider_periods.indexOf(periods) || slider_periods - 1;

          // $("#time_slider").data("ionRangeSlider").update({
          //    block: false,
          //    from: from
          //  });

          // data = '[{"title":"Resumen Bimestre","data":[{"name":"Total Viviendas","count":53867},{"name":"Total Departamentos","count":15663},{"name":"Tenencia Arriendo","count":7504},{"name":"Oferta Arriendo","count":197},{"name":"Tasa de Vacancia","count":2.6},{"name":"Rentabilidad Bruta Anual (al 2B 2020)*","count":8.2},{"name":"Superficie Util Oferta Arriendo","count":54},{"name":"Superficie Util Compraventas (al 3B 2020)*","count":55.2},{"name":"Superficie Terraza Oferta Arriendo","count":4.3},{"name":"Precio Compraventas | UF (al 3B 2020)*","count":1993},{"name":"Precio Oferta Arriendo | UF mensual","count":13.5},{"name":"Precio Oferta Arriendo | UFm2 mensual","count":0.27},{"name":"PxQ Mensual | UF miles","count":98.4}]},{"title":"Distribución Programas","series":[{"label":"Parque","data":[{"name":"1|1","count":23,"id":28},{"name":"2|1","count":18,"id":31},{"name":"2|2","count":28,"id":30},{"name":"3|1","count":9,"id":29},{"name":"3|2","count":21,"id":29},{"name":"4+","count":1,"id":29}]},{"label":"Oferta","data":[{"name":"1|1","count":48,"id":28},{"name":"2|1","count":10,"id":31},{"name":"2|2","count":26,"id":30},{"name":"3|1","count":1,"id":29},{"name":"3|2","count":13,"id":29},{"name":"4+","count":2,"id":29}]}]},{"title":"Superficie","series":[{"label":"Arriendo","data":[{"name":"6/19","count":54},{"name":"1/20","count":54},{"name":"2/20","count":53},{"name":"3/20","count":59},{"name":"4/20","count":60},{"name":"5/20","count":54}]},{"label":"Venta","data":[{"name":"6/19","count":55},{"name":"1/20","count":49},{"name":"2/20","count":55},{"name":"3/20","count":61},{"name":"4/20","count":56},{"name":"5/20","count":54}]}]},{"title":"Precio UF mes","series":[{"label":"Arriendo","data":[{"name":"6/19","count":13.5},{"name":"1/20","count":14},{"name":"2/20","count":15.1},{"name":"3/20","count":15},{"name":"4/20","count":14},{"name":"5/20","count":15}]},{"label":"Venta","data":[{"name":"6/19","count":2000},{"name":"1/20","count":2200},{"name":"2/20","count":2000},{"name":"3/20","count":2500},{"name":"4/20","count":1900},{"name":"5/20","count":2100}]}]},{"title":"UFm2 mes","series":[{"label":"Arriendo","data":[{"name":"6/19","count":0.27},{"name":"1/20","count":0.27},{"name":"2/20","count":0.28},{"name":"3/20","count":0.28},{"name":"4/20","count":0.27},{"name":"5/20","count":0.27}]},{"label":"Venta","data":[{"name":"6/19","count":38},{"name":"1/20","count":48},{"name":"2/20","count":38},{"name":"3/20","count":40},{"name":"4/20","count":36},{"name":"5/20","count":41}]}]},{"title":"Relación Precios | Vacancia","series":[{"label":"Arriendo/Venta","data":[{"name":"6/19","count":0.72},{"name":"1/20","count":0.58},{"name":"2/20","count":0.76},{"name":"3/20","count":0.7},{"name":"4/20","count":0.78},{"name":"5/20","count":0.62}]},{"label":"Vacancia","data":[{"name":"6/19","count":2.6},{"name":"1/20","count":1.8},{"name":"2/20","count":1.7},{"name":"3/20","count":1.2},{"name":"4/20","count":1.1},{"name":"5/20","count":1.2}]}]}]'

          // data = JSON.parse(data)

          // Separamos la información
          for (var i = 0; i < data.length; i++) {

            var reg = data[i];
            var title = reg['title'];
            var series = reg['series'];

            // Creamos el div contenedor
            var chart_container = document.createElement('div');
            chart_container.className = 'chart-container card text-light bg-primary';
            chart_container.id = 'chart-container' + i;

            // Creamos el card-header
            var card_header = document.createElement('div');
            card_header.className = 'card-header pl-3';
            card_header.id = 'header' + i;

            // Creamos el collapse
            var collapse = document.createElement('div');
            collapse.className = 'collapse show';
            collapse.id = 'collapse' + i;

            // Creamos el card-body
            var card_body = document.createElement('div');
            card_body.className = 'card-body';
            card_body.id = 'body' + i;

            // Creamos handle, título y botones
            var card_handle = '<span class="fas fa-arrows-alt handle border border-dark">'
            var card_header_title = '<b>' + title + '</b>'
            var card_min_button = '<button class="close" data-toggle="collapse" data-target="#collapse' + i + '" aria-expanded="true" aria-controls="collapse' + i + '" aria-label="Minimize"><i class="fas fa-window-minimize" style="width: 24px; height: 12px"></i></button>'
            var card_max_button = '<button class="close" id="card-max-' + i + '" onclick="maxCard(' + i + ')"><i class="fas fa-window-maximize" style="width: 24px; height: 12px"></i></button>'

            // Adjuntamos los elementos
            $('.overlay').append(chart_container);
            $('#chart-container' + i).append(card_header, collapse);
            $('#collapse' + i).append(card_body);
            $('#header' + i).append(card_handle, card_header_title, card_max_button, card_min_button);

            // Resumen Bimestre
            if (title == "Resumen Bimestre") {

              var info = reg['data'];

              // Extraemos los datos y los adjuntamos al div contenedor
              $.each(info, function(y, z) {
                name = z['name'];
                count = z['count']
                count = count.toLocaleString('es-ES')
                item = name + ': ' + count + '<br>';
                $('#body' + i).append(item);
              })

              // Gráficos
            } else {

              var datasets = [];
              var serie_colour;

              // Extraemos las series
              $.each(series, function(a, b) {

                // Gráficos de línea
                // Arriendo #ff0000
                // Venta #5dceaf

                var label = b['label']
                var data = b['data']

                // Setea los colores dependiendo de la serie
                if (title == 'Superficie' || title == 'Precio UF mes' || title == 'UFm2 mes' || title == 'Relación Precios | Vacancia') {

                  switch (label) {
                    case 'Arriendo':
                    case 'Arriendo/Venta':
                      serie_colour = '#ff0000'
                      break;
                    case 'Promedio':
                    case 'Venta':
                    case 'Vacancia':
                      serie_colour = '#5dceaf'
                      break;
                  }
                }

                var name = [];
                var count = [];
                var id = [];
                var name_colour = [];
                var colour;

                // Extraemos los datos de las series
                $.each(data, function(c, d) {
                  name.push(d['name'])
                  count.push(d['count'])
                  id.push(d['id'])

                  // Distribución Programas
                  // 1|1 #4e67c8
                  // 2|1 #5eccf3
                  // 2|2 #a7ea52
                  // 3|1 #5dceaf
                  // 3|2 #ff8021
                  // 4+ #f14124

                  // Setea los colores dependiendo del label
                  if (title == 'Distribución Programas') {
                    switch (d['name']) {
                      case '1|1':
                        colour = '#4e67c8'
                        break;
                      case '2|1':
                        colour = '#5eccf3'
                        break;
                      case '2|2':
                        colour = '#a7ea52'
                        break;
                      case '3|1':
                        colour = '#5dceaf'
                        break;
                      case '3|2':
                        colour = '#ff8021'
                        break;
                      case '4+':
                        colour = '#f14124'
                        break;
                    }

                    name_colour.push(colour)
                  }

                })

                // Guardamos "datasets" y "chart_type"
                if (title == 'Distribución Programas') {
                  chart_type = 'doughnut';
                  datasets.push({
                    label: label,
                    data: count,
                    id: id,
                    backgroundColor: name_colour,
                  })
                }

                if (title == 'Superficie') {
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

                if (title == 'Precio UF mes') {
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

                if (title == 'UFm2 mes') {
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

                if (title == 'Relación Precios | Vacancia') {
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
              if (chart_type == 'doughnut') { // Doughnut

                var chart_options = {
                  onClick: function(c, i) {

                    // Almacena los valores del chart
                    var x_tick = this.data.labels[i[0]._index];
                    var x_tick_id = this.data.datasets[0].id[i[0]._index];
                    var title = this.options.title.text;

                    // Crea el filtro
                    var filter_item = document.createElement('div');
                    filter_item.className = 'filter-projects text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split(" ").join("_");
                    filter_item.id = 'item-' + filter_item_id + '-' + x_tick_id;
                    var close_button_item = '<button type="button" class="close" id="close-' + filter_item_id + '">&times;</button>';
                    var text_item = title + ': ' + x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-' + filter_item_id + '-' + x_tick_id).length == 0) {

                      // Almacena la variable global dependiendo del chart
                      if (title == 'Estado Obra') {
                        Congo.projects.config.project_status_ids.push(x_tick_id);
                      } else {
                        Congo.projects.config.project_type_ids.push(x_tick_id);
                      };

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-' + filter_item_id + '-' + x_tick_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();
                    };

                    // Elimina item del filtro
                    $('#close-' + filter_item_id).click(function() {

                      if (title == 'Estado Obra') {
                        var active_items = Congo.projects.config.project_status_ids;
                      } else {
                        var active_items = Congo.projects.config.project_type_ids;
                      };

                      var item_full_id = $('#item-' + filter_item_id + '-' + x_tick_id).attr('id');
                      item_full_id = item_full_id.split("-")
                      var item_id = item_full_id[2]

                      var active_items_updated = $.grep(active_items, function(n, i) {
                        return n != item_id;
                      });

                      if (title == 'Estado Obra') {
                        Congo.projects.config.project_status_ids = active_items_updated;
                      } else {
                        Congo.projects.config.project_type_ids = active_items_updated;
                      };

                      $('#item-' + filter_item_id + '-' + x_tick_id).remove();
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
                        var precentage = ((currentValue / total) * 100).toFixed(2)
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
                        let percentage = (value * 100 / sum).toFixed(2);
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

              } else { // Line

                var chart_options = {
                  onClick: function(c, i) {

                    // Almacena los valores del chart
                    var x_tick = this.data.labels[i[0]._index];

                    // Crea el filtro
                    var filter_item = document.createElement('div');
                    filter_item.className = 'filter-projects text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
                    var filter_item_id = x_tick.split("/").join("-");
                    filter_item.id = 'item-' + filter_item_id;
                    var close_button_item = '<button type="button" class="close" id="close-' + filter_item_id + '">&times;</button>';
                    var text_item = 'Periodo: ' + x_tick;

                    // Valida si el item del filtro existe
                    if ($('#item-' + filter_item_id).length == 0) {

                      // Almacena la variable global
                      var periods_years = x_tick.split("/"); // NOTE: Reveer el uso de x_tick en vez de filter_item_id
                      Congo.projects.config.periods.push(periods_years[0]);
                      Congo.projects.config.years.push(20 + periods_years[1]);

                      // Adjunta el item del filtro y recarga los datos
                      $('#filter-body').append(filter_item);
                      $('#item-' + filter_item_id).append(text_item, close_button_item);
                      Congo.map_utils.counties();
                    };

                    // Elimina item del filtro
                    $('#close-' + filter_item_id).click(function() {

                      var active_periods = Congo.projects.config.periods;
                      var active_years = Congo.projects.config.years;

                      var item_full_id = $('#item-' + filter_item_id).attr('id');

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

                      $('#item-' + filter_item_id).remove();
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
                  tooltips: {
                    callbacks: {
                      label: function(tooltipItem, data) {
                        var dataset = data.datasets[tooltipItem.datasetIndex];
                        var currentValue = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                        return currentValue.toLocaleString('es-ES');
                      }
                    },
                    mode: 'point',
                  },
                  hover: {
                    mode: 'point',
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
                        callback: function(label, index, labels) {
                          label = label.toLocaleString('es-ES')
                          return label;
                        },
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
              canvas.id = 'canvas' + i;
              $('#body' + i).append(canvas);

              var chart_canvas = document.getElementById('canvas' + i).getContext('2d');
              var final_chart = new Chart(chart_canvas, chart_settings);

            } // Cierra if
          } // Cierra for
        } // Cierra success
      }) // Cierra ajax
    }

  } // Cierra indicators

  return {
    init: init,
    indicators: indicators
  }
}();
