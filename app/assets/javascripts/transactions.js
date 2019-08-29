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

transactions_popup = function(id, latlng){

  bimester = Congo.dashboards.config.bimester;
  year = Congo.dashboards.config.year;
  Congo.dashboards.config.row_id = id;
  lat = latlng['lat'];
  lng = latlng['lng'];
  data = {id: id, bimester: bimester, year: year, lat: lat, lng: lng};
  $.ajax({
    type: 'GET',
    url: '/transactions/index.json',
    datatype: 'json',
    data: data,
    success: function(data) {
      $('#popup_info_transactions').empty();
      $('#popup_info_transactions').append('<div>Bimestre: '+ data.bimester +'</div>');
      $('#popup_info_transactions').append('<div>Año: '+ data.year +'</div>');
      $('#popup_info_transactions').append('<div>Direccion: '+ data.address +'</div>');
      $('#popup_info_transactions').append('<div>Tipo de Propiedad: '+ data.property_types.name +'</div>');
      $('#popup_info_transactions').append('<div>Tipo de Vendedor: '+ data.seller_types.name +'</div>');
      $('#popup_info_transactions').append('<div>Vendedor: '+ data.seller_name +'</div>');
      $('#popup_info_transactions').append('<div>Comprador: '+ data.buyer_name +'</div>');
      $('#popup_info_transactions').append('<div>Foja: '+ data.sheet +'</div>');
      $('#popup_info_transactions').append('<div>Numero: '+ data.number +'</div>');
      $('#popup_info_transactions').append('<div>Fecha de Inscripcion: '+ data.inscription_date +'</div>');
      $('#popup_info_transactions').append('<div>Departamento: '+ data.department +'</div>');
      $('#popup_info_transactions').append('<div>Valor UF: '+ data.uf_value +'</div>');
      $('#popup_info_transactions').append('<div>Plano: '+ data.blueprint +'</div>');
      $('#popup_info_transactions').append('<div>Bodega: '+ data.cellar +'</div>');
      $('#popup_info_transactions').append('<div>Estacionamiento: '+ data.parkingi +'</div>');
      $('#popup_info_transactions').append('<div>Rol: '+ data.role +'</div>');

      $('#leaflet_modal_transactions').modal('show');
    }
  })
    Congo.dashboards.pois();
}

function transactions_report_pdf(){

  $.ajax({
    type: 'GET',
    url: '/reports/transactions_pdf.json',
    datatype: 'json',
    data: data,
    success: function(data) {

      data = data['data']

      // Levantamos los datos
      var info = data[0]['info'][0]
      var transactions_count = info['transactions_count']
      var avg_uf = info['average']
      var avg_land = info['avg_lands']
      var avg_build = info['avg_surface_line_build']
      var avg_uf_m2_land = info['avg_uf_m2_land']
      var avg_uf_m2_build = info['avg_uf_m2_u']
      var deviation_uf = info['deviation']
      var deviation_land = info['deviation_lands']
      var deviation_build = info['deviation_surface_line_build']
      var deviation_uf_m2_land = info['deviation_uf_m2_land']
      var deviation_uf_m2_build = info['deviation_uf_m2_u']
      var up_limit_uf = info['li_uf']
      var up_limit_land = info['li_sup_land']
      var up_limit_build = info['li_surface_line_build']
      var up_limit_uf_m2_land = info['li_uf_m2_land']
      var up_limit_uf_m2_build = info['li_uf_m2_u']
      var low_limit_uf = info['ls_uf']
      var low_limit_land = info['ls_sup_land']
      var low_limit_build = info['ls_surface_line_build']
      var low_limit_uf_m2_land = info['ls_uf_m2_land']
      var low_limit_uf_m2_build = info['ls_uf_m2_u']
      var max_val_uf = info['uf_max_value']
      var max_val_land = info['max_lands']
      var max_val_build = info['max_surface_line_build']
      var max_val_uf_m2_land = info['max_uf_m2_land']
      var max_val_uf_m2_build = info['max_uf_m2_u']
      var min_val_uf = info['uf_min_value']
      var min_val_land = info['min_lands']
      var min_val_build = info['min_surface_line_build']
      var min_val_uf_m2_land = info['min_uf_m2_land']
      var min_val_uf_m2_build = info['min_uf_m2_u']

      // Cambiamos a string los valores que llegan como integer
      transactions_count = transactions_count.toString()

      // Creamos el doc
      var doc = new jsPDF();

      // Título
      doc.setFontStyle("bold");
      doc.setFontSize(22);
      doc.text('Informe de Transacciones', 105, 20, null, null, 'center');

      // Subtítulo
      doc.setFontSize(16);
      doc.text('Información General', 105, 35, null, null, 'center');

      // Validamos si hay algún filtro aplicado
      if (periods == '') {

        // Calculamos el bimestre de incio a partir del bimetre final
        var bim = to_bimester
        var year = to_year
        for (var i = 0; i < 5; i++) {
          bim = bim - 1
          if (bim < 1) {
            year = year - 1
            bim = 6
          }
        }

        // Periodos Actuales
        doc.setFontSize(12);
        doc.setFontStyle("bold");
        doc.text('Periodos de tiempo seleccionados:', 10, 49);
        doc.setFontStyle("normal");
        doc.text('Desde el '+bim+'° bimestre del '+year+' al '+to_bimester+'° bimestre del '+to_year, 83, 49);

      } else {

        // Periodos Filtrados
        doc.setFontSize(12);
        doc.setFontStyle("bold");
        doc.text('Periodos de tiempo seleccionados:', 10, 49);
        doc.setFontStyle("normal");
        var tab = 83
        for (var i = 0; i < periods.length; i++) {
          doc.text(periods[i]+'/'+years[i]+', ', tab, 49);
          tab = tab + 16
        }

      }

      // Cantidad
      doc.setFontSize(12);
      doc.setFontStyle("bold");
      doc.text('Cantidad de Transacciones:', 10, 57);
      doc.setFontStyle("normal");
      doc.text(transactions_count, 68, 57);

      // Líneas Tabla
      doc.line(10, 65, 200, 65);
      doc.line(10, 75, 200, 75);
      doc.line(10, 85, 200, 85);
      doc.line(10, 95, 200, 95);
      doc.line(10, 105, 200, 105);
      doc.line(10, 115, 200, 115);
      doc.line(10, 125, 200, 125);
      doc.line(10, 135, 200, 135);
      doc.line(10, 65, 10, 135);
      doc.line(200, 65, 200, 135);
      doc.line(45, 65, 45, 135);

      // Columna Ítem
      doc.text('Ítem', 28, 72, null, null, 'center');
      doc.text('Promedio', 13, 82);
      doc.text('Desviación', 13, 92);
      doc.text('Límite Superior', 13, 102);
      doc.text('Límite Inferior', 13, 112);
      doc.text('Valor Máximo', 13, 122);
      doc.text('Valor Mínimo', 13, 132);

      // Columna Precio UF
      doc.text('Precio UF', 62, 72, null, null, 'center');
      doc.text(avg_uf, 62, 82, null, null, 'center');
      doc.text(deviation_uf, 62, 92, null, null, 'center');
      doc.text(up_limit_uf, 62, 102, null, null, 'center');
      doc.text(low_limit_uf, 62, 112, null, null, 'center');
      doc.text(max_val_uf, 62, 122, null, null, 'center');
      doc.text(min_val_uf, 62, 132, null, null, 'center');


      // Columna Terreno
      doc.text('Terreno', 91, 72, null, null, 'center');
      doc.text(avg_land, 91, 82, null, null, 'center');
      doc.text(deviation_land, 91, 92, null, null, 'center');
      doc.text(up_limit_land, 91, 102, null, null, 'center');
      doc.text(low_limit_land, 91, 112, null, null, 'center');
      doc.text(max_val_land, 91, 122, null, null, 'center');
      doc.text(min_val_land, 91, 132, null, null, 'center');

      // Columna Útil
      doc.text('Útil', 120, 72, null, null, 'center');
      doc.text(avg_build, 120, 82, null, null, 'center');
      doc.text(deviation_build, 120, 92, null, null, 'center');
      doc.text(up_limit_build, 120, 102, null, null, 'center');
      doc.text(low_limit_build, 120, 112, null, null, 'center');
      doc.text(max_val_build, 120, 122, null, null, 'center');
      doc.text(min_val_build, 120, 132, null, null, 'center');

      // Columna UF m² Terreno
      doc.text('UF m² Terreno', 149, 72, null, null, 'center');
      doc.text(avg_uf_m2_land, 149, 82, null, null, 'center');
      doc.text(deviation_uf_m2_land, 149, 92, null, null, 'center');
      doc.text(up_limit_uf_m2_land, 149, 102, null, null, 'center');
      doc.text(low_limit_uf_m2_land, 149, 112, null, null, 'center');
      doc.text(max_val_uf_m2_land, 149, 122, null, null, 'center');
      doc.text(min_val_uf_m2_land, 149, 132, null, null, 'center');

      // Columna UF m² Útil
      doc.text('UF m² Útil', 181, 72, null, null, 'center');
      doc.text(avg_uf_m2_build, 181, 82, null, null, 'center');
      doc.text(deviation_uf_m2_build, 181, 92, null, null, 'center');
      doc.text(up_limit_uf_m2_build, 181, 102, null, null, 'center');
      doc.text(low_limit_uf_m2_build, 181, 112, null, null, 'center');
      doc.text(max_val_uf_m2_build, 181, 122, null, null, 'center');
      doc.text(min_val_uf_m2_build, 181, 132, null, null, 'center');

      // Pie de página
      doc.setFontStyle("bold");
      doc.setFontSize(12);
      doc.text('Fuente:', 10, 284);
      doc.setFontStyle("normal");
      doc.text('Compraventas inscritas en los Conservadores de Bienes Raíces de la Región Metropolitana', 27, 284);
      doc.text('(Santiago, San Miguel, Puente Alto y San Bernardo) y planchetas de predios municipales', 10, 290);

      // Agregamos un página
      doc.addPage('a4', 'portrait')

      // Separamos la información
      for (var i = 1; i < data.length; i++) {

        var reg = data[i];
        var title = reg['title'];
        var series = reg['series'];
        var datasets = [];

        // Extraemos las series
        $.each(series, function(a, b){

          if (title == 'Transacciones / Bimestre') {

            var data = b['data']

            // Separamos las comunas
            for (var i = 1; i < data.length; i++) {

              var reg = data[i];

              var label = reg[0]

              var name = [];
              var count = [];

              // Separamos los bimestres de la comuna
              for (var a = 1; a < reg.length; a++) {
                var bim = reg[a]

                var cantidad = bim[0]
                var periodo = bim[1]
                var año = bim[2]
                var nombre = periodo+'/'+año

                name.push(nombre)
                count.push(cantidad)

              } // Cierra for bimestre

              if (title == 'Transacciones / Bimestre') { // Line
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

              chart_data = {
                labels: name,
                datasets: datasets
              }

            } // Cierra for comunas

          } else {

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
                backgroundColor: ['#E74C3C', '#9B59B6', '#3498DB', '#1ABC9C', '#2ECC71', '#F1C40F', '#E67E22'],
              })
            }

            if (title == 'Tipo de Vendedor') { // Pie
              chart_type = 'pie';
              datasets.push({
                label: label,
                data: count,
                backgroundColor: ['#E74C3C', '#3498DB', '#1ABC9C', '#F39C12'],
              })
            }

            if (title == 'Transacciones / Bimestre') { // Line
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

            if (title == 'Volumen Venta Total UF por Bimestre') { // Line
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

            if (title == 'Superficie Linea Construcción (útil m2) por Bimestre') { // Line
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

            if (title == 'Precio UFm2 en base Util por Bimestre') { // Line
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

            if (title == 'Superficie Terreno (m2) por Bimestre') { // Line
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

            if (title == 'Precio UFm2 en base Terreno por Bimestre') { // Line
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

            chart_data = {
              labels: name,
              datasets: datasets
            }

          } // Cierra else

        }) // Cierra each series

        // Guardamos "options"
        if (chart_type == 'pie') { // Pie

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
              display: false,
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
          doc.text('Fuente:', 10, 284);
          doc.setFontStyle("normal");
          doc.text('Compraventas inscritas en los Conservadores de Bienes Raíces de la Región Metropolitana', 27, 284);
          doc.text('(Santiago, San Miguel, Puente Alto y San Bernardo) y planchetas de predios municipales', 10, 290);

        } else {

          // Título del gráfico
          doc.setFontSize(16);
          doc.text(title, 105, 160, null, null, 'center');

          // Gráfico
          doc.addImage(chart, 'JPEG', 9, 170);

          // Agrega nueva página
          doc.addPage('a4', 'portrait')

        } // Cierra else impar
      } // Cierra for

      // Descarga el archivo PDF
      doc.save("Reporte_Transacciones.pdf");

    } // Cierra success

  }) // Cierra ajax

} // Cierra transactions_report_pdf

Congo.transactions.action_graduated_points = function(){

  init=function(){
    var env1='';

    $.each(Congo.dashboards.config.county_id, function(a,b){
       county_id =b;
    })
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

function maxCard(i){
  $('#chart-container'+i).toggleClass('card-max fixed-top')
}

Congo.transactions.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_transactions = function(){
    county_id = []
    $.each(Congo.dashboards.config.county_id, function(a,b){
       county_id =b;
    })
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
    boost = Congo.dashboards.config.boost;

    // Sino se realizó la selección muestra un mensaje de alerta
    if (county_id.length == 0 && centerPoint == '' && wkt.length == 0) {

      Congo.dashboards.action_index.empty_selection_alert();

    // Si se realizó la selección, añade los elementos al dashboard
    } else {

      // Creamos el overlay y el time_slider
      Congo.dashboards.action_index.create_overlay_and_filter_card();
      Congo.dashboards.action_index.add_time_slider();

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

 if (boost == true){
               data['boost'] =  boost;
             }
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

          // Mostramos el icono de Puntos Proporcionales correspondiente
          $("#prop-prv").hide();
          $("#prop-cbr").show();
          $("#prop-em").hide();

          // Mostramos el icono de Heatmap correspondiente
          $("#heat-prv").hide();
          $("#heat-cbr").show();
          $("#heat-em-norm-dem").hide();

          // Eliminamos los chart-containter de la capa anterior
          $(".chart-container").remove();

          // Mostramos el filtro de la capa y ocultamos los demás
          $('.filter-building-regulations').hide();
          $('.filter-transactions').show();
          $('.filter-projects').hide();
          $('.filter-future-projects').hide();

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

                if (title == 'Transacciones / Bimestre') {

                  var data = b['data']

                  // ACA SEPARAMOS TODAS LAS COMUNAS
                  for (var i = 1; i < data.length; i++) {

                    var reg = data[i];

                    var label = reg[0]

                    var name = [];
                    var count = [];

                    // Separamos los bimestres de la comuna
                    for (var a = 1; a < reg.length; a++) {
                      var bim = reg[a]

                      var cantidad = bim[0]
                      var periodo = bim[1]
                      var año = bim[2]
                      var nombre = periodo+'/'+año

                      name.push(nombre)
                      count.push(cantidad)

                    } // Cierra for bimestre

                    if (title == 'Transacciones / Bimestre') { // Line
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

                    chart_data = {
                      labels: name,
                      datasets: datasets
                    }

                  } // Cierra for comunas

                } else {

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
                          colour = '#3498DB'
                          break;
                        case 'Inmobiliaria':
                          colour = '#1ABC9C'
                          break;
                        case 'Empresa':
                          colour = '#F5B041'
                          break;
                        case 'Banco':
                          colour = '#8E44AD'
                          break;
                        case 'Cooperativa':
                          colour = '#EC7063'
                          break;
                        case 'Municipalidad':
                          colour = '#27AE60'
                          break;
                        case 'Sin informacion':
                          colour = '#C0392B'
                          break;
                        case 'Departamento':
                          colour = '#3498DB'
                          break;
                        case 'Casa':
                          colour = '#1ABC9C'
                          break;
                        case 'Estacionamiento':
                          colour = '#DC7633'
                          break;
                        case 'Bodega':
                          colour = '#F5B041'
                          break;
                        case 'Local comercial':
                          colour = '#8E44AD'
                          break;
                        case 'Oficina':
                          colour = '#EC7063'
                          break;
                        case 'Sitio':
                          colour = '#7F8C8D'
                          break;
                        case 'Industria':
                          colour = '#ECF0F1'
                          break;
                        case 'Otro':
                          colour = '#Otro'
                          break;
                        case 'Parcela':
                          colour = '#C0392B'
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

                  if (title == 'Precio Promedio / UF m² Útil') { // Line
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
                      if (title =! 'Transacciones / Bimestre') {
                        Congo.transactions.config.years.push(20+periods_years[1]);
                      } else {
                        Congo.transactions.config.years.push(periods_years[1]);
                      }

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
                  tooltips: {
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
