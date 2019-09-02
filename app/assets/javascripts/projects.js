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

projects_popup = function(id){

  bimester = Congo.dashboards.config.bimester;
  year = Congo.dashboards.config.year;
  Congo.dashboards.config.row_id = id;

  data = {id: id, bimester: bimester, year: year};
  $.ajax({
    type: 'GET',
    url: '/projects/index.json',
    datatype: 'json',
    data: data,
    success: function(data) {

      // Detalle Proyecto
      $('#popup_info_projects').empty();
      $('#popup_info_projects').append('<div>Bimestre: '+ data.bimester +'</div>');
      $('#popup_info_projects').append('<div>Año: '+ data.year +'</div>');
      $('#popup_info_projects').append('<div>Direccion: '+ data.address +'</div>');
      $('#popup_info_projects').append('<div>Nombre: '+ data.name +'</div>');
      $('#popup_info_projects').append('<div>Estado: '+ data.project_status.name  +'</div>');
      $('#popup_info_projects').append('<div>Total de Unidades: '+ data.total_units  +'</div>');
      $('#popup_info_projects').append('<div>Disponibilidad Total: '+ data.stock_units  +'</div>');
      $('#popup_info_projects').append('<div>Venta Total: '+ data.sold_units  +'</div>');
      $('#popup_info_projects').append('<div>Cantidad de Pisos: '+ data.floors  +'</div>');
      $('#popup_info_projects').append('<div>UF/m2: '+ data.uf_m2  +'</div>');
      $('#popup_info_projects').append('<div>Fecha Inicio Construcción: '+ data.build_date  +'</div>');
      $('#popup_info_projects').append('<div>Fecha Inicio Ventas:  '+ data.sale_date  +'</div>');
      $('#popup_info_projects').append('<div>Fecha Entrega '+ data.transfer_date  +'</div>');
      $('#leaflet_modal_projects').modal('show');

      // Oferta vs. Demanda
      var charts_data = data['charts']

      // Separamos los datos de los gráficos
      $.each(charts_data, function(i, reg) {

        var name = [];
        var count = [];
        var datasets = [];

        // Seteamos los títulos
        if (i == 'offer_mix') {
          title = 'Mix Oferta'
        }

        if (i == 'sale_mix') {
          title = 'Mix Venta'
        }

        // Extraemos los datos de la serie
        $.each(reg, function(a, b) {
          name.push(b[1])
          count.push(b[0])
        })

        // Guardamos "datasets"
        datasets.push({
          data: count,
          backgroundColor: [
            '#3498DB',
            '#1ABC9C',
            '#F5B041',
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
          animation: false,
          responsive: true,
          title: {
            display: true,
            text: title,
            fontColor: '#e8ebef'
          },
          legend: {
            display: true,
            position: 'bottom',
            labels: {
              fontColor: '#e8ebef',
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
                if (percentage > 3) {
                  return percentage + '%';
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

        var chart_settings = {
          type: 'pie',
          data: chart_data,
          options: chart_options
        }

        var chart_canvas = document.getElementById(i + '_canvas').getContext('2d');
        var final_chart = new Chart(chart_canvas, chart_settings);

      }) // Cierra each charts_data
    } // Cierra success
  }) // Cierra ajax
    Congo.dashboards.pois();
} // Cierra projects_popup

Congo.projects.action_graduated_points = function(){

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
      data['widget'] = Congo.dashboards.config.widget;
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

      // Título
      doc.setFontStyle("bold");
      doc.setFontSize(22);
      doc.text('Proyectos Residenciales en Venta', 105, 20, null, null, 'center');

      // Periodo
      doc.setFontSize(14);
      doc.setFontStyle("bold");
      doc.text('Periodo de tiempo seleccionado:', 105, 40, null, null, 'center');
      doc.setFontStyle("normal");
      doc.text(to_bimester+'° Bimestre '+to_year, 105, 48, null, null, 'center');

      // Polígono
      doc.setFontStyle("bold");
      doc.setFontSize(14);
      doc.text('Polígono seleccionado:', 105, 60, null, null, 'center');

      // Pie de página
      doc.setFontStyle("bold");
      doc.setFontSize(12);
      doc.text('Fuente:', 20, 290);
      doc.setFontStyle("normal");
      doc.text('Levantamiento bimestral en salas de ventas por Equipo de Catastro Inciti', 37, 290);

      // Separamos la información
      for (var i = 0; i < data.length; i++) {

        if (i == 0) { // Listado de Proyectos

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

          var list_projet = data[i]['list_projet'];

          var line_num = 30

          $.each(list_projet, function(a, b) {

            var code = '' // TODO: Falta levantar el dato cuando llegue en el array
            var name = b['name']
            var real_estate_agent = '' // TODO: Falta levantar el dato cuando llegue en el array
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
            doc.text(code, 22, line_num);

            // Nombre
            doc.setFontStyle("bold");
            doc.text('Nombre:', 62, line_num);
            doc.setFontStyle("normal");
            doc.text(name, 80, line_num);

            line_num = line_num+8

            // Inmobiliaria
            doc.setFontStyle("bold");
            doc.text('Inmobiliaria:', 10, line_num);
            doc.setFontStyle("normal");
            doc.text(real_estate_agent, 38, line_num);

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
        } else if (i == 1) { // Información General Departamentos

          doc.addPage('a4', 'portrait')

          // Levantamos los valores de departamento
          var info_department = data[i]['info_department'][0];

          var min_historical_monthly_sale = info_department['min_selling_speed1'];
          var max_historical_monthly_sale = info_department['max_selling_speed1'];
          var avg_historical_monthly_sale = info_department['avg_selling_speed1'];
          var total_units = info_department['total_units1'];
          var sold_units = info_department['total_sold'];
          var stock_units = info_department['total_stock1']
          var months_to_sell_out_stock = info_department['spend_stock_months1'];
          var min_uf_m2_value = info_department['min_uf_m21'];
          var max_uf_m2_value = info_department['max_uf_m21'];
          var avg_uf_m2_value = info_department['avg_uf_m2'];

          var min_usable_square_m2 = info_department['min_usable_square_m21'];
          var max_usable_square_m2 = info_department['max_usable_square_m21'];
          var avg_usable_square_m2 = info_department['avg_usable_square_m21'];
          var min_terrace_square_m2 = info_department['min_terrace_square_m21'];
          var max_terrace_square_m2 = info_department['max_terrace_square_m21'];
          var avg_terrace_square_m2 = info_department['avg_terrace_square_m21'];
          var min_uf_value = info_department['min_uf1'];
          var max_uf_value = info_department['max_uf1'];
          var avg_uf_value = info_department['avg_uf1'];

          // Cambiamos a string los valores que llegan como integer
          min_historical_monthly_sale = min_historical_monthly_sale.toString()
          max_historical_monthly_sale = max_historical_monthly_sale.toString()

          // Subtítulo
          doc.setFontStyle("bold");
          doc.setFontSize(14);
          doc.text('Información General Departamentos', 105, 20, null, null, 'center');

          // Labels columna izquierda
          doc.setFontSize(12);
          doc.text('Venta Mensual Histórica Mín.:', 74, 40, null, null, 'right');
          doc.text('Venta Mensual Histórica Máx.:', 74, 50, null, null, 'right');
          doc.text('Venta Mensual Histórica Prom.:', 74, 60, null, null, 'right');
          doc.text('Oferta:', 74, 70, null, null, 'right');
          doc.text('Venta:', 74, 80, null, null, 'right');
          doc.text('Disponibilidad:', 74, 90, null, null, 'right');
          doc.text('Meses para agotar stock:', 74, 100, null, null, 'right');
          doc.text('Valor UF/m² Mín.:', 74, 110, null, null, 'right');
          doc.text('Valor UF/m² Máx.:', 74, 120, null, null, 'right');
          doc.text('Valor UF/m² Prom.:', 74, 130, null, null, 'right');

          // Valores columna izquierda
          doc.setFontStyle("normal");
          doc.text(min_historical_monthly_sale, 76, 40);
          doc.text(max_historical_monthly_sale, 76, 50);
          doc.text(avg_historical_monthly_sale, 76, 60);
          doc.text(total_units, 76, 70);
          doc.text(sold_units, 76, 80);
          doc.text(stock_units, 76, 90);
          doc.text(months_to_sell_out_stock, 76, 100);
          doc.text(min_uf_m2_value, 76, 110);
          doc.text(max_uf_m2_value, 76, 120);
          doc.text(avg_uf_m2_value, 76, 130);

          // Labels columna derecha
          doc.setFontStyle("bold");
          doc.text('Superficie Útil Mín. (m²):', 168, 40, null, null, 'right');
          doc.text('Superficie Útil Máx. (m²):', 168, 50, null, null, 'right');
          doc.text('Superficie Útil Prom. (m²):', 168, 60, null, null, 'right');
          doc.text('Superficie Terraza Mín. (m²):', 168, 70, null, null, 'right');
          doc.text('Superficie Terraza Máx. (m²):', 168, 80, null, null, 'right');
          doc.text('Superficie Terraza Prom. (m²):', 168, 90, null, null, 'right');
          doc.text('Valor UF Mín.:', 168, 110, null, null, 'right');
          doc.text('Valor UF Máx.:', 168, 120, null, null, 'right');
          doc.text('Valor UF Prom.:', 168, 130, null, null, 'right');

          // Valores columna derecha
          doc.setFontStyle("normal");
          doc.text(min_usable_square_m2, 170, 40);
          doc.text(max_usable_square_m2, 170, 50);
          doc.text(avg_usable_square_m2, 170, 60);
          doc.text(min_terrace_square_m2, 170, 70);
          doc.text(max_terrace_square_m2, 170, 80);
          doc.text(avg_terrace_square_m2, 170, 90);
          doc.text(min_uf_value, 170, 110);
          doc.text(max_uf_value, 170, 120);
          doc.text(avg_uf_value, 170, 130);

        } else if (i == 2) { // Información General Casas

          // Levantamos los valores de casas
          var info_house = data[i]['info_house'][0];

          var project_count = info_house['project_count'];

          // Validamos si existen proyectos de casas
          if (project_count > 0) {

            var min_historical_speed = info_house['min_selling_speed'];
            var max_historical_speed = info_house['max_selling_speed'];
            var avg_historical_speed = info_house['avg_selling_speed'];
            var total_stock = info_house['total_units'];
            var total_sale = info_house['total_sold'];
            var total_availability = info_house['total_stock'];
            var months_to_sell_out_stock = info_house['spend_stock_months1'];
            var min_uf_m2_value = info_house['min_uf_m2'];
            var max_uf_m2_value = info_house['max_uf_m2'];
            var avg_uf_m2_value = info_house['avg_uf_m2'];

            var min_usable_square_m2 = info_house['min_usable_square_m2'];
            var max_usable_square_m2 = info_house['max_usable_square_m2'];
            var avg_usable_square_m2 = info_house['avg_usable_square_m2'];
            var min_land_area_m2 = info_house['min_m2_field'];
            var max_land_area_m2 = info_house['max_m2_field'];
            var avg_land_area_m2 = info_house['avg_m2_field'];
            var min_uf_value = info_house['min_uf'];
            var max_uf_value = info_house['max_uf'];
            var avg_uf_value = info_house['avg_uf'];

            // Cambiamos a string los valores que llegan como integer
            max_land_area_m2 = max_land_area_m2.toString()
            max_historical_speed = max_historical_speed.toString()
            min_land_area_m2 = min_land_area_m2.toString()
            min_historical_speed = min_historical_speed.toString()
            total_stock = total_stock.toString()

            // Subtítulo
            doc.setFontStyle("bold");
            doc.setFontSize(14);
            doc.text('Información General Casas', 105, 160, null, null, 'center');

            // Labels columna izquierda
            doc.setFontSize(12);
            doc.text('Velocidad Histórica Mín:', 74, 180, null, null, 'right');
            doc.text('Velocidad Histórica Máx:', 74, 190, null, null, 'right');
            doc.text('Velocidad Histórica Prom.:', 74, 200, null, null, 'right');
            doc.text('Stock Total:', 74, 210, null, null, 'right');
            doc.text('Venta Total:', 74, 220, null, null, 'right');
            doc.text('Disponibilidad Total:', 74, 230, null, null, 'right');
            doc.text('Meses para agotar stock:', 74, 240, null, null, 'right');
            doc.text('Valor UF/m² Mín.:', 74, 250, null, null, 'right');
            doc.text('Valor UF/m² Máx.:', 74, 260, null, null, 'right');
            doc.text('Valor UF/m² Prom.:', 74, 270, null, null, 'right');

            // Valores columna izquierda
            doc.setFontStyle("normal");
            doc.text(min_historical_speed, 76, 180);
            doc.text(max_historical_speed, 76, 190);
            doc.text(avg_historical_speed, 76, 200);
            doc.text(total_stock, 76, 210);
            doc.text(total_sale, 76, 220);
            doc.text(total_availability, 76, 230);
            doc.text(months_to_sell_out_stock, 76, 240);
            doc.text(min_uf_m2_value, 76, 250);
            doc.text(max_uf_m2_value, 76, 260);
            doc.text(avg_uf_m2_value, 76, 270);

            // Labels columna derecha
            doc.setFontStyle("bold");
            doc.text('Superficie Útil Mín. (m²):', 168, 180, null, null, 'right');
            doc.text('Superficie Útil Máx. (m²):', 168, 190, null, null, 'right');
            doc.text('Superficie Útil Prom. (m²):', 168, 200, null, null, 'right');
            doc.text('Superficie Terreno Mín. (m²):', 168, 210, null, null, 'right');
            doc.text('Superficie Terreno Máx. (m²):', 168, 220, null, null, 'right');
            doc.text('Superficie Terreno Prom. (m²):', 168, 230, null, null, 'right');
            doc.text('Valor UF Mín.:', 168, 250, null, null, 'right');
            doc.text('Valor UF Máx.:', 168, 260, null, null, 'right');
            doc.text('Valor UF Prom.:', 168, 270, null, null, 'right');

            // Valores columna derecha
            doc.setFontStyle("normal");
            doc.text(min_usable_square_m2, 170, 180);
            doc.text(max_usable_square_m2, 170, 190);
            doc.text(avg_usable_square_m2, 170, 200);
            doc.text(min_land_area_m2, 170, 210);
            doc.text(max_land_area_m2, 170, 220);
            doc.text(avg_land_area_m2, 170, 230);
            doc.text(min_uf_value, 170, 250);
            doc.text(max_uf_value, 170, 260);
            doc.text(avg_uf_value, 170, 270);

            // Pie de página
            doc.setFontStyle("bold");
            doc.setFontSize(12);
            doc.text('Fuente:', 20, 290);
            doc.setFontStyle("normal");
            doc.text('Levantamiento bimestral en salas de ventas por Equipo de Catastro Inciti', 37, 290);

          }

          doc.addPage('a4', 'portrait')

        } else { // Gráficos

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

        } // Cierra if

      } // Cierra for

      // Descarga el archivo PDF
      doc.save("ProjectosResidenciales.pdf");

    } // Cierra success
  }) // Cierra ajax
} // Cierra function projects_report_pdf

function addInmoFilter(id, name) {

  if ($('#item-inmo-'+id).length == 0) {

    Congo.projects.config.project_agency_ids.push(id);

    $('#filter-body').append(
      $('<div>', {
          'class': 'filter-projects text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow',
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

function maxCard(i){
  $('#chart-container'+i).toggleClass('card-max fixed-top')
}

Congo.projects.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_projects = function(){

    county_id = [];
    $.each(Congo.dashboards.config.county_id, function(a,b){
       county_id =b;
    })
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

        // Eliminamos filtro comuna
        $('#item-comuna').remove();

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

        // Eliminamos filtro comuna
        $('#item-comuna').remove();

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

          // Mostramos el spinner y deshabilitamos los botones
          $("#spinner").show();
          $('.btn').addClass('disabled')
          $('.close').prop('disabled', true);
          $("#time_slider").data("ionRangeSlider").update({
            block: true
          });

          // Establece el nombre de la capa en el navbar
          $('#layer-name').text('Proyectos Residenciales');

          // Mostramos el icono de Puntos Proporcionales correspondiente
          $("#prop-prv").show();
          $("#prop-cbr").hide();
          $("#prop-em").hide();

          // Mostramos el icono de Heatmap correspondiente
          $("#heat-prv").show();
          $("#heat-cbr").hide();
          $("#heat-em-norm-dem").hide();

          // Eliminamos los chart-containter de la capa anterior
          $(".chart-container").remove();

          // Mostramos el filtro de la capa y ocultamos los demás
          $('.filter-building-regulations').hide();
          $('.filter-transactions').hide();
          $('.filter-projects').show();
          $('.filter-future-projects').hide();

        },
        success: function(data){

          // Ocultamos el spinner y habilitamos los botones
          $("#spinner").hide();
          $('.btn').removeClass('disabled')
          $('.close').prop('disabled', false);
          $("#time_slider").data("ionRangeSlider").update({
            block: false
          });

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

              // Extraemos los datos y los adjuntamos al div contenedor
              $.each(info, function(y, z){
                name = z['name'];
                count = z['count']
                count = count.toLocaleString('es-ES')
                item = name+': '+count+'<br>';
                $('#body'+i).append(item);
              })

            // Gráficos
            } else if (title != "Inmobiliarias") {

              var datasets = [];
              var serie_colour;

              // Extraemos las series
              $.each(series, function(a, b){

                var label = b['label']
                var data = b['data']

                // Setea los colores dependiendo de la serie
                if (title == 'Total Distribución por Mix' || title == 'Oferta, Venta y Disponibilidad por Bimestre' || title == 'Valor UF por Bimestre' || title == 'UF/m2 por Bimestre' || title == 'Superficie Útil (m2) por Bimestre' || title == 'Superficie Terreno/Terraza (m2) por Bimestre') {

                  switch (label) {
                    case 'Máximo':
                    case 'Oferta':
                      serie_colour = '#42d964'
                      break;
                    case 'Promedio':
                    case 'Venta':
                    case 'Venta Total':
                      serie_colour = '#58b9e2'
                      break;
                    case 'Mínimo':
                    case 'Disponibilidad':
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
                  if (title == 'Estado del Proyecto' || title == 'Tipo de Propiedad') {
                    switch (d['name']) {
                      case 'No iniciado':
                        colour = '#3498DB'
                        break;
                      case 'Excavaciones':
                        colour = '#D6EAF8'
                        break;
                      case 'Obra gruesa':
                        colour = '#2874A6'
                        break;
                      case 'Terminaciones':
                        colour = '#1B4F72'
                        break;
                      case 'Finalizado':
                        colour = '#85C1E9'
                        break;
                      case 'Departamentos':
                        colour = '#58b9e2'
                        break;
                      case 'Casas':
                        colour = '#1B4F72'
                        break;
                    }

                    name_colour.push(colour)
                  }

                })

                // Guardamos "datasets" y "chart_type"
                if (title == 'Estado del Proyecto') {
                  chart_type = 'pie';
                  datasets.push({
                    label: label,
                    data: count,
                    id: id,
                    backgroundColor: name_colour,
                  })
                }

                if (title == 'Tipo de Propiedad') {
                  chart_type = 'pie';
                  datasets.push({
                    label: label,
                    data: count,
                    id: id,
                    backgroundColor: name_colour,
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
                    pointHoverBackgroundColor: '#e8ebef',
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
                    pointHoverBackgroundColor: '#e8ebef',
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
                    pointHoverBackgroundColor: '#e8ebef',
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
                    pointHoverBackgroundColor: '#e8ebef',
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
                    pointHoverBackgroundColor: '#e8ebef',
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

                if (title == 'Cantidad de Pisos') {
                  chart_type = 'bar';
                  datasets.push({
                    label: label,
                    data: count,
                    backgroundColor: '#58b9e2',
                  })
                }

                if (title == 'Unidades Proyecto por Rango UF') {
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
                      filter_item.className = 'filter-projects text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
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
                } else {

                  var chart_options = {
                    onClick: function(c, i) {

                      // Almacena los valores del chart
                      var x_tick = this.data.labels[i[0]._index];
                      var title = this.options.title.text;

                      // Crea el filtro
                      var filter_item = document.createElement('div');
                      filter_item.className = 'filter-projects text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
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
                    filter_item.className = 'filter-projects text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
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
                    filter_item.className = 'filter-projects text-light bg-secondary px-2 mb-1 py-1 rounded border border-dark shadow';
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

            // Inmobiliarias
            } else if (title == "Inmobiliarias") {

              $("<div>", {
                  'id': 'list-inmo',
                  'class': 'list-group list-overflow border'
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
                }).appendTo('#list-inmo')

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
