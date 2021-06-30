function genCharts() {
    $("#table .form-check-input").each(function () {
        if ($(this).is(":checked")) {
            dataFromTable.push($(this).val()); //variable que captura los datos de la tabla
        }
    });
    $(".user_data").each(function () {
        userData.push([$(this).attr('name'), $(this).val()]); //variable que captura los datos ingresados por el usuario
    })

    data = {transactions: dataFromTable};

    console.log('Parámetros charts');
    console.log(data);

    $.ajax({
        async: false,
        type: 'POST',
        url: 'search_data_for_charts.json',
        datatype: 'json',
        data: data,
        success: function (data) {

            console.log('Datos charts');
            console.log(data);

            charts = data

            // Ejemplo:
            // charts = JSON.parse('[{"title":"Cantidad","series":[{"data":[{"name":"1/2018","count":1},{"name":"1/2019","count":6},{"name":"1/2020","count":2},{"name":"2/2018","count":4},{"name":"2/2019","count":4},{"name":"2/2020","count":6},{"name":"3/2018","count":5},{"name":"3/2019","count":7},{"name":"3/2020","count":1},{"name":"4/2018","count":4},{"name":"4/2019","count":1},{"name":"4/2020","count":1},{"name":"5/2018","count":2},{"name":"5/2019","count":1},{"name":"6/2018","count":3},{"name":"6/2019","count":1},{"name":"6/2020","count":2}]}]},{"title":"Superficie Útil","series":[{"data":[{"name":"1/2018","count":"126.0"},{"name":"1/2019","count":"129.3333333333333333"},{"name":"1/2020","count":"119.5"},{"name":"2/2018","count":"131.75"},{"name":"2/2019","count":"129.0"},{"name":"2/2020","count":"125.8333333333333333"},{"name":"3/2018","count":"133.2"},{"name":"3/2019","count":"123.1428571428571429"},{"name":"3/2020","count":"112.0"},{"name":"4/2018","count":"131.25"},{"name":"4/2019","count":"100.0"},{"name":"4/2020","count":"131.0"},{"name":"5/2018","count":"127.0"},{"name":"5/2019","count":"176.0"},{"name":"6/2018","count":"110.3333333333333333"},{"name":"6/2019","count":"132.0"},{"name":"6/2020","count":"141.0"}]}]},{"title":"Precio","series":[{"data":[{"name":"1/2018","count":"3165.0"},{"name":"1/2019","count":"1836.5"},{"name":"1/2020","count":"2034.0"},{"name":"2/2018","count":"1956.75"},{"name":"2/2019","count":"2149.75"},{"name":"2/2020","count":"2334.3333333333333333"},{"name":"3/2018","count":"1487.4"},{"name":"3/2019","count":"1213.2857142857142857"},{"name":"3/2020","count":"4703.0"},{"name":"4/2018","count":"3113.75"},{"name":"4/2019","count":"2162.0"},{"name":"4/2020","count":"1953.0"},{"name":"5/2018","count":"1308.5"},{"name":"5/2019","count":"731.0"},{"name":"6/2018","count":"1405.0"},{"name":"6/2019","count":"2504.0"},{"name":"6/2020","count":"2431.5"}]}]},{"title":"Precio Unitario","series":[{"data":[{"name":"1/2018","count":"25.1"},{"name":"1/2019","count":"13.9833333333333333"},{"name":"1/2020","count":"17.45"},{"name":"2/2018","count":"15.65"},{"name":"2/2019","count":"17.475"},{"name":"2/2020","count":"19.45"},{"name":"3/2018","count":"10.86"},{"name":"3/2019","count":"10.5857142857142857"},{"name":"3/2020","count":"42.0"},{"name":"4/2018","count":"25.425"},{"name":"4/2019","count":"21.6"},{"name":"4/2020","count":"14.9"},{"name":"5/2018","count":"10.1"},{"name":"5/2019","count":"4.2"},{"name":"6/2018","count":"13.0333333333333333"},{"name":"6/2019","count":"19.0"},{"name":"6/2020","count":"20.4"}]}]},{"title":"Volúmen Mercado","series":[{"data":[{"name":"1/2018","count":"3165.0"},{"name":"1/2019","count":"11019.0"},{"name":"1/2020","count":"4068.0"},{"name":"2/2018","count":"7827.0"},{"name":"2/2019","count":"8599.0"},{"name":"2/2020","count":"14005.9999999999999998"},{"name":"3/2018","count":"7437.0"},{"name":"3/2019","count":"8492.9999999999999999"},{"name":"3/2020","count":"4703.0"},{"name":"4/2018","count":"12455.0"},{"name":"4/2019","count":"2162.0"},{"name":"4/2020","count":"1953.0"},{"name":"5/2018","count":"2617.0"},{"name":"5/2019","count":"731.0"},{"name":"6/2018","count":"4215.0"},{"name":"6/2019","count":"2504.0"},{"name":"6/2020","count":"4863.0"}]}]},{"title":"Superficie Útil (barras)","series":[{"data":[{"name":"1","count":"122.1"},{"name":"2","count":"131.2"},{"name":"3","count":"125.2"},{"name":"4","count":"136.1"},{"name":"5","count":"124.0"},{"name":"6","count":"111.1"}]}]},{"title":"Precio (barras)","series":[{"data":[{"name":"1","count":"2165.0"},{"name":"2","count":"1336.5"},{"name":"3","count":"2134.0"},{"name":"4","count":"1356.75"},{"name":"5","count":"2449.75"},{"name":"6","count":"2134.3333333333333333"}]}]},{"title":"Precio Unitario (barras)","series":[{"data":[{"name":"1","count":"23.1"},{"name":"2","count":"23.9833333333333333"},{"name":"3","count":"19.45"},{"name":"4","count":"25.65"},{"name":"5","count":"13.475"},{"name":"6","count":"29.45"}]}]},{"title":"Superficie por UF","series":[{"data":[{"name":"29.5","count":"23.1","radius":"23.1"},{"name":"32.5","count":"132.9833333333333333","radius":"23.1"},{"name":"33.6","count":"123.45","radius":"23.1"},{"name":"44.1","count":"121.65","radius":"23.1"},{"name":"20.5","count":"110.475","radius":"23.1"},{"name":"15.5","count":"123.45","radius":"23.1"}]}]}]')


        },
        error: function (jqxhr, textstatus, errorthrown) {
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
    labelsChart = [];
    dataChart = [];
    radioChart = [];
    $(charts).each(function () {
        if ($(this)[0]['title'] == 'Cantidad') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChart.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChart.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartCantidad = new Chart(cantidadChart, {
                type: 'line',
                data: {
                    labels: labelsChart,
                    datasets: [{
                        data: dataChart,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChart = [];
            dataChart = [];
        }
        if ($(this)[0]['title'] == 'Superficie Útil') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChart.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChart.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartSupUtil = new Chart(supUtilChart, {
                type: 'line',
                data: {
                    labels: labelsChart,
                    datasets: [{
                        data: dataChart,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChart = [];
            dataChart = [];
        }
        if ($(this)[0]['title'] == 'Precio') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChart.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChart.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartPrecio = new Chart(precioChart, {
                type: 'line',
                data: {
                    labels: labelsChart,
                    datasets: [{
                        data: dataChart,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChart = [];
            dataChart = [];
        }
        if ($(this)[0]['title'] == 'Precio Unitario') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChart.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChart.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartPrecioUnitario = new Chart(precioUnitarioChart, {
                type: 'line',
                data: {
                    labels: labelsChart,
                    datasets: [{
                        data: dataChart,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChart = [];
            dataChart = [];
        }
        if ($(this)[0]['title'] == 'Volúmen Mercado') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChart.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChart.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartVolMercado = new Chart(volMercadoChart, {
                type: 'line',
                data: {
                    labels: labelsChart,
                    datasets: [{
                        data: dataChart,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChart = [];
            dataChart = [];
        }
        if ($(this)[0]['title'] == 'Superficie Útil (barras)') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChart.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChart.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartSupUtilBarras = new Chart(supUtilBarrasChart, {
                type: 'bar',
                data: {
                    labels: labelsChart,
                    datasets: [{
                        data: dataChart,
                        label: "",
                        backgroundColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChart = [];
            dataChart = [];
        }
        if ($(this)[0]['title'] == 'Precio (barras)') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChart.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChart.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartPrecioBarras = new Chart(precioBarrasChart, {
                type: 'bar',
                data: {
                    labels: labelsChart,
                    datasets: [{
                        data: dataChart,
                        label: "",
                        backgroundColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChart = [];
            dataChart = [];
        }
        if ($(this)[0]['title'] == 'Precio Unitario (barras)') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChart.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChart.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartPrecioUnitarioBarras = new Chart(precioUnitarioBarrasChart, {
                type: 'bar',
                data: {
                    labels: labelsChart,
                    datasets: [{
                        data: dataChart,
                        label: "",
                        backgroundColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChart = [];
            dataChart = [];
        }
        if ($(this)[0]['title'] == 'Superficie por UF') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                radioChart.push
                (
                    {
                        x: $(this)[0]['series'][0]['data'][i]['name'],
                        y: $(this)[0]['series'][0]['data'][i]['count'],
                        r: $(this)[0]['series'][0]['data'][i]['radius']
                    }
                );
            }
            console.log(radioChart);
            var chartSupUF = new Chart(supUFChart, {
                type: 'bubble',
                data: {
                    labels: labelsChart,
                    datasets: [{
                        data: radioChart,
                        label: "",
                        backgroundColor: 'rgb(69,254,237)',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            radioChart = [];
        }
    });
}
