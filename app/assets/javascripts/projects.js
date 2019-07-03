Congo.namespace('projects.action_heatmap');
Congo.namespace('projects.action_graduated_points');
Congo.namespace('projects.action_dashboards');


Congo.projects.config= {
  county_name: '',
  county_id: '',
  layer_type: 'projects_feature_info',
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

Congo.projects.action_graduated_points = function(){

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
    //style_layer = Congo.dashboards.config.style_layer;

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
      };
    };

    $.ajax({
      type: 'GET',
      url: '/projects/graduated_points.json',
      datatype: 'json',
      data: data ,
      success: function(data){
        $.each(data['data'], function(index, value){
          str = 'interval'+index+':'+value+';';
          env1 = env1.concat(str);
        })
        Congo.dashboards.config.style_layer= 'stock_units_graduated_points';
        Congo.dashboards.config.env= env1;
        Congo.map_utils.counties();
      }
    })
  }
  return {
    init: init,
  }
}();


function projects_report_pdf(){

  $.ajax({
    type: 'GET',
    url: '/reports/projects_pdf.json',
    datatype: 'json',
    data: data,
    success: function(data){

      data = data['data']

      // Creamos el doc
      var doc = new jsPDF();

      // ---------- PÁGINA UNO ---------- //

      // Título
      doc.setFontStyle("bold");
      doc.setFontSize(22);
      doc.text('Proyectos Residenciales en Venta', 105, 20, null, null, 'center');

      // Subtítulo
      doc.setFontSize(16);
      doc.text('Polígono Seleccionado', 105, 30, null, null, 'center');

      // Pie de página
      doc.setFontStyle("bold");
      doc.setFontSize(12);
      doc.text('Fuente:', 20, 290);
      doc.setFontStyle("normal");
      doc.text('Levantamiento bimestral en salas de ventas por Equipo de Catastro Inciti', 37, 290);

      // ---------- PÁGINA DOS ---------- //

      // Agregamos una página
      doc.addPage('a4', 'portrait')

      // Subtítulo
      doc.setFontStyle("bold");
      doc.setFontSize(16);
      doc.text('Listado de Proyectos', 105, 20, null, null, 'center');

      // Pie de página
      doc.setFontStyle("bold");
      doc.setFontSize(12);
      doc.text('Fuente:', 20, 290);
      doc.setFontStyle("normal");
      doc.text('Levantamiento bimestral en salas de ventas por Equipo de Catastro Inciti', 37, 290);

      doc.line(10, 25, 200, 25);

      for (var i = 0; i < 3; i++) {

        var reg = data[i];

        var list_projet = reg['list_projet'];

        var line_num = 30

        $.each(list_projet, function(a, b) {

          var name = b['name']
          var address = b['address']
          var sold_units = b['sold_units']
          var stock_units = b['stock_units']
          var total_units = b['total_units']
          var vhmud = b['vhmud']

          // Convertimos integer a varchar
          sold_units = sold_units.toString()
          stock_units = stock_units.toString()
          total_units = total_units.toString()
          vhmud = vhmud.toString()

          if (line_num > 260) {
            doc.addPage('a4', 'portrait')
            line_num = 25

            doc.line(10, 20, 200, 20);

            // Pie de página
            doc.setFontStyle("bold");
            doc.setFontSize(12);
            doc.text('Fuente:', 20, 290);
            doc.setFontStyle("normal");
            doc.text('Levantamiento bimestral en salas de ventas por Equipo de Catastro Inciti', 37, 290);
          }

          // Cod
          doc.setFontSize(12);
          doc.setFontStyle("bold");
          doc.text('Cod:', 10, line_num);
          doc.setFontStyle("normal");
          doc.text('', 22, line_num);

          // Nombre
          doc.setFontStyle("bold");
          doc.text('Nombre:', 60, line_num);
          doc.setFontStyle("normal");
          doc.text(name, 80, line_num);

          line_num = line_num+8

          // Inmobiliaria
          doc.setFontStyle("bold");
          doc.text('Inmobiliaria:', 10, line_num);
          doc.setFontStyle("normal");
          doc.text('GRUPO MAGAL', 38, line_num);

          line_num = line_num+8

          // Dirección
          doc.setFontStyle("bold");
          doc.text('Dirección:', 10, line_num);
          doc.setFontStyle("normal");
          doc.text(address, 33, line_num);

          line_num = line_num+8

          // Oferta
          doc.setFontStyle("bold");
          doc.text('Oferta:', 10, line_num);
          doc.setFontStyle("normal");
          doc.text(total_units, 26, line_num);

          // Venta
          doc.setFontStyle("bold");
          doc.text('Venta:', 62, line_num);
          doc.setFontStyle("normal");
          doc.text(sold_units, 77, line_num);

          // Disponible
          doc.setFontStyle("bold");
          doc.text('Disponible:', 114, line_num);
          doc.setFontStyle("normal");
          doc.text(stock_units, 139, line_num);

          // Velocidad
          doc.setFontStyle("bold");
          doc.text('Velocidad:', 169, line_num);
          doc.setFontStyle("normal");
          doc.text(vhmud, 193, line_num);

          line_num = line_num+5

          doc.line(10, line_num, 200, line_num);

          line_num = line_num+8

        }) // Cierra each

      } // Cierra for

      // ---------- PÁGINA TRES ---------- //

      doc.addPage('a4', 'portrait')

      doc.setFontStyle("bold");
      doc.setFontSize(14);
      doc.text('Información General Departamentos', 105, 20, null, null, 'center');

      // ---------- PÁGINAS CHARTS ---------- //

      doc.addPage('a4', 'portrait')

      // Separamos la información
      for (var i = 3; i < data.length; i++) {

        var reg = data[i];
        var title = reg['title'];
        var series = reg['series'];
        var datasets = [];

        // Extraemos las series
        $.each(series, function(a, b){

          var label = b['label']
          var data = b['data']

          // Setea los colores dependiendo de la serie
          switch (label) {
            case 'UF Máximo':
            case 'Oferta Total':
            case 'Disponibles':
              rgba_color = 'rgba(165, 188, 78, 0.5)'
              rgb_colour = 'rgb(165, 188, 78)'
              break;
            case 'UF Mínimo':
            case 'Disponibilidad Total':
            case 'Vendidas':
              rgba_color = 'rgba(228, 135, 1, 0.5)'
              rgb_colour = 'rgb(228, 135, 1)'
              break;
            case 'UF Promedio':
            case 'Ventas Total':
              rgba_color = 'rgba(27, 149, 217, 0.5)'
              rgb_colour = 'rgb(27, 149, 217)'
              break;
          }

          var name = [];
          var count = [];

          // Extraemos los datos de las series
          $.each(data, function(c, d){
            name.push(d['name'])
            count.push(d['count'])
          })

          // Guardamos "datasets" y "chart_type"
          if (title == 'Mix de Unidades') {
            chart_type = 'bar';
            datasets.push({
              label: label,
              data: count,
              backgroundColor: rgba_color,
              borderColor: rgb_colour,
              borderWidth: 1,
            })
          }

          if (title == 'Evolución Stock Total, Venta y Disponibilidad') {
            chart_type = 'line';
            datasets.push({
              label: label,
              data: count,
              fill: false,
              borderColor: rgb_colour,
              borderWidth: 3,
              pointRadius: 0,
              pointStyle: 'line',
              lineTension: 0,
            })
          }

          if (title == 'Evolución Precio en UF') {
            chart_type = 'line';
            datasets.push({
              label: label,
              data: count,
              fill: false,
              borderColor: rgb_colour,
              borderWidth: 3,
              pointRadius: 0,
              pointStyle: 'line',
              lineTension: 0,
            })
          }

          if (title == 'Evolución Precio en UF/m2') {
            chart_type = 'line';
            datasets.push({
              label: label,
              data: count,
              fill: false,
              borderColor: rgb_colour,
              borderWidth: 3,
              pointRadius: 0,
              pointStyle: 'line',
              lineTension: 0,
            })
          }

          if (title == 'Estado de los Proyectos') {
            chart_type = 'pie';
            datasets.push({
              label: label,
              data: count,
              backgroundColor: [
                'rgb(39,174,96)',
                'rgb(231,76,60)',
                'rgb(211,84,0)',
                'rgb(41,128,185)',
                'rgb(241,196,15)'
              ],
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
            animation: false,
            responsive: true,
            title: {
              display: false
            },
            legend: {
              display: true,
              position: 'bottom',
              labels: {
                fontColor: '#444',
                fontSize: 12,
              }
            },
            plugins: {
              datalabels: {
                align: 'center',
                anchor: 'center',
                color: '#444',
                font: {
                  size: 10
                },
                formatter: (value, ctx) => {
                  // Mustra sólo los valores que estén por encima del 3%
                  let sum = 0;
                  let dataArr = ctx.chart.data.datasets[0].data;
                  dataArr.map(data => {
                      sum += data;
                  });
                  let percentage = (value*100 / sum).toFixed(2);
                  if (percentage > 3) {
                    return value;
                  } else {
                    return null;
                  }
                },
              }
            },
            scales: {
              xAxes: [{
                stacked: true,
                ticks: {
                  display: true,
                  fontSize: 10,
                  fontColor: '#444'
                }
              }],
              yAxes: [{
                stacked: true,
                ticks: {
                  beginAtZero: true,
                  display: true,
                  fontSize: 10,
                  fontColor: '#444'
                },
              }],
            }
          };

        } else if (chart_type == 'pie') { // Pie

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
                fontColor: '#444',
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
                  let percentage = (value*100 / sum).toFixed(2);
                  if (percentage > 3) {
                    return percentage+'%';
                  } else {
                    return null;
                  }
                },
                align: 'center',
                anchor: 'center',
    						color: 'white',
    						font: {
    							weight: 'bold'
    						},
    					}
            },
          };

        } else { // Line

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
                fontColor: '#444',
                fontSize: 12,
                usePointStyle: true,
              }
            },
            plugins: {
              datalabels: {
                align: 'start',
                anchor: 'start',
                color: '#444',
                display: function(context) {
                  return context.dataset.data[context.dataIndex] > 0;
                },
                font: {
                  size: 10
                },
                formatter: Math.round
              }
            },
            scales: {
              xAxes: [{
                stacked: true,
                ticks: {
                  display: true,
                  fontSize: 10,
                  fontColor: '#444'
                }
              }],
              yAxes: [{
                ticks: {
                  beginAtZero: true,
                  display: true,
                  fontSize: 10,
                  fontColor: '#444'
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
        canvas.id = 'report-canvas-'+i;
        $('#chart-report'+i).append(canvas);

        var chart_canvas = document.getElementById('report-canvas-'+i).getContext('2d');
        var final_chart = new Chart(chart_canvas, chart_settings);

        var chart = final_chart.toBase64Image();

        if (i % 2 == 1) {

          // Título del gráfico
          doc.setFontSize(16);
          doc.text(title, 105, 20, null, null, 'center');

          // Gráfico
          doc.addImage(chart, 'JPEG', 9, 30);

          // Pie de página
          doc.setFontStyle("bold");
          doc.setFontSize(12);
          doc.text('Fuente:', 20, 290);
          doc.setFontStyle("normal");
          doc.text('Levantamiento bimestral en salas de ventas por Equipo de Catastro Inciti', 37, 290);

        } else {

          // Título del gráfico
          doc.setFontSize(16);
          doc.text(title, 105, 160, null, null, 'center');

          // Gráfico
          doc.addImage(chart, 'JPEG', 9, 170);

          // Agrega nueva página
          doc.addPage('a4', 'portrait')

        } // Cierra if impar

      } // Cierra for

      // Descarga el archivo PDF
      doc.save("ProjectosResidenciales.pdf");

    }
  })

}

function addInmoFilter(id, name) {

  Congo.projects.config.project_agency_ids.push(id);

  $('#filter-body').append(
    $('<div>', {
        'class': 'filter-projects text-white bg-secondary px-2 mb-1 py-1 rounded',
        'id': 'item-inmo-'+id,
        'text': 'Inmobiliaria: '+name
    }).append(
      $('<button>', {
          'type': 'button',
          'class': 'close',
          'id': 'close-inmo-'+id,
          'text': '×',
          'onclick': 'delInmoFilter('+id+', "'+name+'")'
      })
    )
  );
  Congo.map_utils.counties();
};

function delInmoFilter(id, name) {

  var active_inmo = Congo.projects.config.project_agency_ids;

  var inmo_updated = $.grep(active_inmo, function(n, i) {
    return n != id;
  });

  Congo.projects.config.project_agency_ids = inmo_updated;

  $('#item-inmo-'+id).remove();
  Congo.map_utils.counties();

}

Congo.projects.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_projects = function(){

    county_id = Congo.dashboards.config.county_id;
    to_year = Congo.dashboards.config.year;
    to_bimester = Congo.dashboards.config.bimester;
    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
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

      // Si se realizó la selección por comuna/punto, agregamos el item al filtro
      if (county_id != '') {
        Congo.dashboards.action_index.add_county_filter_item()
      }

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
          county_id: county_id,
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer

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
          radius: radius,
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer

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
          wkt: JSON.stringify(wkt),
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer

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
            } else if (title != "Inmobiliarias") {

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
                      Congo.map_utils.counties();
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
                      Congo.map_utils.counties();
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
                      Congo.map_utils.counties();
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
                      Congo.map_utils.counties();
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

            // Inmobiliarias
            } else if (title == "Inmobiliarias") {

              $("<div>", {
                  'class': 'list-group border'
              }).appendTo('#body'+i)

              var info = reg['data'];

              // Extraemos los datos y los adjuntamos al div contenedor
              $.each(info, function(y, z){
                name = z['name'];
                id = z['id']

                $("<button>", {
                    'type': 'button',
                    'id': 'inmo-'+id,
                    'onclick': 'addInmoFilter('+id+', "'+name+'")',
                    'class': 'list-group-item list-group-item-action',
                    'text': name
                }).appendTo('.list-group')

              }) // Cierra each
            } // Cierra if
          } // Cierra for
        } // Cierra success
      }) // Cierra ajax
    } // Cierra if alert
  } // Cierra indicator_projects

  return {
    init: init,
    indicator_projects: indicator_projects
  }
}();
