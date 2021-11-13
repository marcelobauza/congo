Chart.pluginService.register({
  beforeDraw: function (chart, easing) {
    if (chart.config.options.chartArea && chart.config.options.chartArea.backgroundColor) {
      var helpers = Chart.helpers;
      var ctx = chart.chart.ctx;
      var chartArea = chart.chartArea;

      ctx.save();
      ctx.fillStyle = chart.config.options.chartArea.backgroundColor;
      ctx.fillRect(chartArea.left, chartArea.top, chartArea.right - chartArea.left, chartArea.bottom - chartArea.top);
      ctx.restore();
    }
  }
});

function genCharts(flex_report_id) {

  $("#table .form-check-input").each(function() {
    if ($(this).is(":checked")) {
      dataFromTable.push($(this).val()); //variable que captura los datos de la tabla
    }
  });
  $(".user_data").each(function() {
    userData.push([$(this).attr('name'), $(this).val()]); //variable que captura los datos ingresados por el usuario
  })

  data = {
    flex_report_id: flex_report_id,
    transactions: dataFromTable
  };

  console.log('PARAMS search_data_for_charts');
  console.log(data);

  $.ajax({
    async: false,
    type: 'POST',
    url: 'search_data_for_charts.json',
    datatype: 'json',
    data: data,
    success: function(data) {

      console.log('RESPONSE search_data_for_charts');
      console.log(data);

      charts = data

    },
    error: function(jqxhr, textstatus, errorthrown) {
      console.log("algo malo paso");
    }
  });

  var cantidadChart = $("#chartCantidad");
  var supUtilChart = $("#chartSupUtil");
  var precioChart = $("#chartPrecio");
  var precioUnitarioChart = $("#chartPrecioUnitario");
  var volMercadoChart = $("#chartVolMercado");
  var supUtilBarrasChart = $("#chartSupUtil-barras");
  var precioBarrasChart = $("#chartPrecio-barras");
  var precioUnitarioBarrasChart = $("#chartPrecioUnitario-barras");
  var supUFChart = $("#chartSupUF");
  var charts;
  var chart;

  $.each(charts, function(i, chart) {

    var title = chart['title'];
    var series = chart['series'];
    var datasets = [];
    var serie_colour;

    $.each(series, function(a, b) {

      var label = b['name']
      var data = b['data']
      var name = [];
      var count = [];
      var radius = []
      var id = [];
      var name_colour = [];
      var colour;

      // Setea los colores dependiendo de la serie
      switch (label) {
          case 'Cantidad':
          case 'Promedio Bimestre':
            serie_colour = 'rgba(61, 64, 70, 0.9)'
            break;
          case 'Registros Base':
            serie_colour = 'rgba(44, 46, 52, 0.6)'
            break;
          case 'Promedio':
          case 'Promedio Muestra':
          case 'Registros Usuario':
            serie_colour = 'rgba(238, 95, 91, 0.9)'
            break;
          default:
            serie_colour = 'rgba(44, 46, 52, 0.6)'
            break;
        }


      if (title == 'Superficie por UF') {

        $.each(data, function(c, d) {
          name.push(d['name'])
          count.push({
            x: d['name'],
            y: d['count'],
            r: d['radius'] * 6
          });
        })

      } else {

        $.each(data, function(c, d) {
          name.push(d['name'])
          count.push(d['count'])
        })

      }


      if (title == 'Cantidad' || title == 'Superficie Útil' || title == 'Precio' || title == 'Precio Unitario' || title == 'Volúmen Mercado') {
        chart_type = 'line';
        datasets.push({
          label: label,
          data: count,
          fill: false,
          borderColor: serie_colour,
          borderWidth: 4,
          pointRadius: 0,
          pointStyle: 'line',
          lineTension: 0,
        })
      }

      if (title == 'Superficie Útil (barras)' || title == 'Precio (barras)' || title == 'Precio Unitario (barras)') {
        if (label == 'Registros Base') {
          datalabels = {
            anchor: 'center',
            align: 'center'
          }
        } else {
          datalabels = {
            anchor: 'end',
            align: 'end',
            offset: -5,
          }
        }
        chart_type = 'bar';
        datasets.push({
          label: label,
          data: count,
          borderColor: '#3d4046',
          borderWidth : 2,
          backgroundColor: serie_colour,
          datalabels: datalabels
        })
      }

      if (title == 'Superficie por UF') {
        chart_type = 'bubble';
        datasets.push({
          label: label,
          data: count,
          borderColor: '#3d4046',
          borderWidth : 1,
          backgroundColor: serie_colour,
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
        chartArea: {
					backgroundColor: '#E3E3E3'
				},
        title: {
          display: false,
        },
        legend: {
          display: false,
        },
        tooltips: {
          callbacks: {
            label: function(tooltipItem, data) {
              var dataset = data.datasets[tooltipItem.datasetIndex];
              var currentValue = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
              return currentValue.toLocaleString('es-ES');
            }
          }
        },
        plugins: {
          datalabels: {
            font: {
              weight: 'bold'
            },
            color: '#E3E3E3',
            textStrokeColor: '#1B2631',
            textStrokeWidth: 1,
            textShadowColor: '#000000',
            textShadowBlur: 5,
            display: function(context) {
              return context.dataset.data[context.dataIndex] > 0;
            },
          }
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
              color: "#798088"
            },
          }],
          yAxes: [{
            stacked: true,
            ticks: {
              callback: function(label, index, labels) {
                label = label.toLocaleString('es-ES')
                return label;
              },
              beginAtZero: true,
              fontColor: '#e8ebef'
            },
            gridLines: {
              color: "#798088"
            },
          }],
        }
      };

    } else if (chart_type == 'line') { // Line

      var chart_options = {
        responsive: true,
        chartArea: {
          backgroundColor: '#E3E3E3'
        },
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
              color: "#798088"
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
              color: "#798088"
            },
          }],
        }
      };

    } else { // Bubble

      var chart_options = {
        chartArea: {
          backgroundColor: '#E3E3E3'
        },
        legend: {
          display: false
        },
        tooltips: {
          enabled: false
        },
        scales: {
          xAxes: [{
            ticks: {
              fontColor: '#e8ebef'
            },
            gridLines: {
              color: "#798088"
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
              color: "#798088"
            },
          }],
        },
        plugins: {
          datalabels: {
            display: false
          }
        }
      };


    } // Cierra else ("options")

    var chart_settings = {
      type: chart_type,
      data: chart_data,
      options: chart_options
    }

    var cantidadChart = $("#chartCantidad");
    var supUtilChart = $("#chartSupUtil");
    var precioChart = $("#chartPrecio");
    var precioUnitarioChart = $("#chartPrecioUnitario");
    var volMercadoChart = $("#chartVolMercado");
    var supUtilBarrasChart = $("#chartSupUtil-barras");
    var precioBarrasChart = $("#chartPrecio-barras");
    var precioUnitarioBarrasChart = $("#chartPrecioUnitario-barras");
    var supUFChart = $("#chartSupUF");

    switch (i) {
      case 0:
        ccanvas = cantidadChart;
        break;
      case 1:
        ccanvas = supUtilChart;
        break;
      case 2:
        ccanvas = precioChart;
        break;
      case 3:
        ccanvas = precioUnitarioChart;
        break;
      case 4:
        ccanvas = volMercadoChart;
        break;
      case 5:
        ccanvas = supUtilBarrasChart;
        break;
      case 6:
        ccanvas = precioBarrasChart;
        break;
      case 7:
        ccanvas = precioUnitarioBarrasChart;
        break;
      case 8:
        ccanvas = supUFChart;
        break;
    }

    var final_chart = new Chart(ccanvas, chart_settings);

  });
}
