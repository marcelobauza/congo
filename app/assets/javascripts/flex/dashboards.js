Congo.namespace('flex_dashboards.action_index');

Congo.flex_dashboards.config = {
  geo_selection: ''
}

//filters
var parsed_data = "";
var table_data = "";
var dataFromTable = []; // variable que captura ids de la tabla
var dataForCharts = {transactions: dataFromTable}; // variable para los charts
var userData = [];
dataInsc_date = {};
dataPrices = {};
dataUnit_prices = {};
dataTerrain_surfaces = {};
dataBuilding_surfaces = {};
dataDensity = {};
dataMaxHeight = {};
var filteredData = {};

function exportToExcel() {
    $("#table").table2excel({
        // exclude CSS class
        exclude: ".noExl",
        name: "Datos descargados",
        filename: "planilla de resultados", //do not include extension
        fileext: ".xls" // file extension
    });
}

function genCharts() {
    $("#table .form-check-input").each(function () {
        if (!$(this).is(":checked")) {
            dataFromTable.push($(this).val()); //variable que captura los datos de la tabla
        }
    });
    $(".user_data").each(function () {
        userData.push([$(this).attr('name'), $(this).val()]); //variable que captura los datos ingresados por el usuario
    })

    data = {transactions: dataFromTable};
    // TODO: Agregar a data un array con los ids de los registros a graficar

    // Ejemplo:
    // data = { transactions: [3929666,3898209,2615973,2597245,2594402,2506068,2503657,2503587,2482173,2464137,2307090,2303584,2261290,2261019,2255696,2254176,2189686,2189029,2186890,2186605,2185362,2165865,2165542,2163594,2163184,2156936,2155103,2122455,2095374,2095232,2091701,2066314,2019829,2010087,2003976,1990372,1968867,1968673,1968366,1909958,1904943,1902446,1901418,1887898,20611,20493,20264,19586,16595,16173,15621] }

    console.log('Parámetros charts');
    console.log(data);

    $.ajax({
        async: false,
        type: 'get',
        url: 'flex/dashboards/search_data_for_charts.json',
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
                        borderColor: 'rgb(0,162,255)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
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
                        borderColor: 'rgb(0,162,255)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
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
                        borderColor: 'rgb(0,162,255)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
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
                        borderColor: 'rgb(0,162,255)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
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
                        borderColor: 'rgb(0,162,255)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
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
                        backgroundColor: 'rgb(0,162,255)',
                        tension: 0.1,
                        borderWidth: 2
                    }]
                },
                options: {
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
                        backgroundColor: 'rgb(0,162,255)',
                        tension: 0.1,
                        borderWidth: 2
                    }]
                },
                options: {
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
                        backgroundColor: 'rgb(0,162,255)',
                        tension: 0.1,
                        borderWidth: 2
                    }]
                },
                options: {
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
                        backgroundColor: 'rgb(0,162,255)',
                        borderWidth: 2
                    }]
                },
                options: {
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

function clearTable() {
    $('tr.genTable').remove();
}

function update_table() {
    $(table_data).each(function (index) {
        $('#table tr:last').after(
            '<tr class="genTable">' +
            '<td><input class="form-check-input" type="checkbox" value="' + ($(this)[0]['id']) + '" checked></td>' +
            '<td>' + ($(this)[0]["property_typee"]) + '</td>' +
            '<td>' + ($(this)[0]['inscription_date']) + '</td>' +
            '<td>' + ($(this)[0]["address"]) + '</td>' +
            '<td>' + ($(this)[0]['c_name']) + '</td>' +
            '<td>' + ($(this)[0]['seller']) + '</td>' +
            '<td>' + ($(this)[0]['building_surface']) + '</td>' +
            '<td>' + ($(this)[0]['terrain_surface']) + '</td>' +
            '<td>' + ($(this)[0]['parking_lot']) + '</td>' +
            '<td>' + ($(this)[0]['cellar']) + '</td>' +
            '<td>' + ($(this)[0]['price']) + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '<td class="hidden">' + ($(this)[0]['id']) + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '</tr>'
        );
    });
    // sort table
    var table = $('table');

    $('#address_sort, #utilm2_sort, #e_sort, #uf_sort')
        .wrapInner('<span title="ordenar esta columna"/>')
        .each(function(){

            var th = $(this),
                thIndex = th.index(),
                inverse = false;

            th.click(function(){

                table.find('td').filter(function(){

                    return $(this).index() === thIndex;

                }).sortElements(function(a, b){

                    if( $.text([a]) == $.text([b]) )
                        return 0;

                    return $.text([a]) > $.text([b]) ?
                        inverse ? -1 : 1
                        : inverse ? 1 : -1;

                }, function(){

                    // parentNode is the element we want to move
                    return this.parentNode;

                });

                inverse = !inverse;

            });

        });
}

function getFilteredData() {

    // TODO: seller_types y property_types se deben enviar en un array con los ids seleccionados
    propertyTypes = $("#prop_type").val();
    sellerTypes = $("#seller_type").val();
    land_useType = $("#land_use").val();

    geom = Congo.flex_dashboards.config.geo_selection

    // TODO: agregar density_types (array con ids) y max_height (min y max)
    data = {
        geom: geom,
        property_types: propertyTypes,
        seller_types: sellerTypes,
        inscription_dates: dataInsc_date,
        max_height: dataMaxHeight,
        density_types: dataDensity,
        land_use: land_useType,
        building_surfaces: dataBuilding_surfaces,
        terrain_surfaces: dataTerrain_surfaces,
        prices: dataPrices,
        unit_prices: dataUnit_prices
    }

    console.log('Parámetros tabla');
    console.log(data);

    $.ajax({
        async: false,
        type: 'get',
        url: 'flex/dashboards/search_data_for_table.json',
        datatype: 'json',
        data: data,
        success: function (data) {

            console.log('Datos tabla');
            console.log(data);

            table_data = data

            // Ejemplo:
            // table_data = JSON.parse('[{"id":2558054,"address":"1509 Conferencia","inscription_date":"2019-12-10","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"107.0","terrain_surface":"110.0","parking_lot":0,"price":"1273.0"},{"id":2558054,"address":"1509 Conferencia","inscription_date":"2019-12-10","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"107.0","terrain_surface":"110.0","parking_lot":0,"price":"1273.0"},{"id":3930229,"address":"1587 Oriente","inscription_date":"2020-12-17","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"70.0","terrain_surface":"71.0","parking_lot":0,"price":"1060.0"},{"id":3930229,"address":"1587 Oriente","inscription_date":"2020-12-17","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"70.0","terrain_surface":"71.0","parking_lot":0,"price":"1060.0"},{"id":2554314,"address":"2990 Antofagasta","inscription_date":"2019-10-16","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"EMPRESA","building_surface":"116.0","terrain_surface":"0.0","parking_lot":0,"price":"1355.0"},{"id":2554314,"address":"2990 Antofagasta","inscription_date":"2019-10-16","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"EMPRESA","building_surface":"116.0","terrain_surface":"0.0","parking_lot":0,"price":"1355.0"},{"id":2193095,"address":"1534 Conferencia","inscription_date":"2018-08-09","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"104.0","terrain_surface":"104.0","parking_lot":0,"price":"1397.0"},{"id":2193095,"address":"1534 Conferencia","inscription_date":"2018-08-09","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"104.0","terrain_surface":"104.0","parking_lot":0,"price":"1397.0"},{"id":2202023,"address":"1598 Oriente","inscription_date":"2019-03-18","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"97.0","terrain_surface":"71.0","parking_lot":0,"price":"1814.0"},{"id":2438121,"address":"2910 Antofagasta","inscription_date":"2019-07-08","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"EMPRESA","building_surface":"61.0","terrain_surface":"0.0","parking_lot":0,"price":"1220.0"},{"id":2438121,"address":"2910 Antofagasta","inscription_date":"2019-07-08","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"EMPRESA","building_surface":"61.0","terrain_surface":"0.0","parking_lot":0,"price":"1220.0"},{"id":2202023,"address":"1598 Oriente","inscription_date":"2019-03-18","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"97.0","terrain_surface":"71.0","parking_lot":0,"price":"1814.0"},{"id":2441205,"address":"1507 Los Canelos","inscription_date":"2019-08-13","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"193.0","terrain_surface":"383.0","parking_lot":0,"price":"3576.0"},{"id":2007156,"address":"2912 Antofagasta","inscription_date":"2018-06-28","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"64.0","terrain_surface":"0.0","parking_lot":0,"price":"1399.0"},{"id":2007156,"address":"2912 Antofagasta","inscription_date":"2018-06-28","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"64.0","terrain_surface":"0.0","parking_lot":0,"price":"1399.0"},{"id":2441205,"address":"1507 Los Canelos","inscription_date":"2019-08-13","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"193.0","terrain_surface":"383.0","parking_lot":0,"price":"3576.0"},{"id":2008283,"address":"2990 Antofagasta","inscription_date":"2018-07-12","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"111.0","terrain_surface":"0.0","parking_lot":0,"price":"2759.0"},{"id":2045819,"address":"3035 Manuel De Amat","inscription_date":"2018-11-23","cellar":0,"property_typee":"SITIO","c_name":"Santiago","seller":"EMPRESA","building_surface":"416.0","terrain_surface":"437.0","parking_lot":0,"price":"5323.0"},{"id":2045819,"address":"3035 Manuel De Amat","inscription_date":"2018-11-23","cellar":0,"property_typee":"SITIO","c_name":"Santiago","seller":"EMPRESA","building_surface":"416.0","terrain_surface":"437.0","parking_lot":0,"price":"5323.0"},{"id":2008283,"address":"2990 Antofagasta","inscription_date":"2018-07-12","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"111.0","terrain_surface":"0.0","parking_lot":0,"price":"2759.0"},{"id":23750,"address":"898 Nueva San Martin","inscription_date":"2020-04-16","cellar":1,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"INMOBILIARIA","building_surface":null,"terrain_surface":null,"parking_lot":0,"price":"2372.0"},{"id":17555,"address":"898 Nueva San Martin","inscription_date":"2020-03-04","cellar":1,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"INMOBILIARIA","building_surface":null,"terrain_surface":null,"parking_lot":0,"price":"2694.0"},{"id":5075,"address":"3056 Manuel De Amat","inscription_date":"2020-02-10","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"62.0","terrain_surface":"0.0","parking_lot":0,"price":"2446.0"},{"id":23750,"address":"898 Nueva San Martin","inscription_date":"2020-04-16","cellar":1,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"INMOBILIARIA","building_surface":null,"terrain_surface":null,"parking_lot":0,"price":"2372.0"},{"id":17555,"address":"898 Nueva San Martin","inscription_date":"2020-03-04","cellar":1,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"INMOBILIARIA","building_surface":null,"terrain_surface":null,"parking_lot":0,"price":"2694.0"},{"id":23776,"address":"2990 Antofagasta","inscription_date":"2020-05-05","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"112.0","terrain_surface":"0.0","parking_lot":0,"price":"3105.0"},{"id":2260195,"address":"2910 Antofagasta","inscription_date":"2019-04-29","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"61.0","terrain_surface":"0.0","parking_lot":0,"price":"1220.0"},{"id":23776,"address":"2990 Antofagasta","inscription_date":"2020-05-05","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"112.0","terrain_surface":"0.0","parking_lot":0,"price":"3105.0"},{"id":2260195,"address":"2910 Antofagasta","inscription_date":"2019-04-29","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"61.0","terrain_surface":"0.0","parking_lot":0,"price":"1220.0"},{"id":2093017,"address":"1663 Conferencia","inscription_date":"2018-11-06","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"133.0","terrain_surface":"270.0","parking_lot":0,"price":"1656.0"},{"id":5075,"address":"3056 Manuel De Amat","inscription_date":"2020-02-10","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"62.0","terrain_surface":"0.0","parking_lot":0,"price":"2446.0"},{"id":2107991,"address":"1592 Longavi","inscription_date":"2019-01-21","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"70.0","terrain_surface":"71.0","parking_lot":0,"price":"508.0"},{"id":2289332,"address":"3020 Manuel De Amat","inscription_date":"2019-07-23","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"108.0","terrain_surface":"420.0","parking_lot":0,"price":"5187.0"},{"id":2289332,"address":"3020 Manuel De Amat","inscription_date":"2019-07-23","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"108.0","terrain_surface":"420.0","parking_lot":0,"price":"5187.0"},{"id":2107991,"address":"1592 Longavi","inscription_date":"2019-01-21","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"70.0","terrain_surface":"71.0","parking_lot":0,"price":"508.0"},{"id":2128478,"address":"1545 Longavi","inscription_date":"2018-11-21","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"70.0","terrain_surface":"70.0","parking_lot":0,"price":"1028.0"},{"id":2093017,"address":"1663 Conferencia","inscription_date":"2018-11-06","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"133.0","terrain_surface":"270.0","parking_lot":0,"price":"1656.0"},{"id":2124649,"address":"1533 Longavi","inscription_date":"2018-08-08","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"70.0","terrain_surface":"70.0","parking_lot":0,"price":"368.0"},{"id":1972058,"address":"2990 Antofagasta","inscription_date":"2018-08-06","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"BANCO","building_surface":"116.0","terrain_surface":"0.0","parking_lot":0,"price":"250.0"},{"id":2124649,"address":"1533 Longavi","inscription_date":"2018-08-08","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"70.0","terrain_surface":"70.0","parking_lot":0,"price":"368.0"},{"id":2553827,"address":"1482 Oriente","inscription_date":"2019-08-01","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"BANCO","building_surface":"58.0","terrain_surface":"0.0","parking_lot":0,"price":"668.0"},{"id":2553827,"address":"1482 Oriente","inscription_date":"2019-08-01","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"BANCO","building_surface":"58.0","terrain_surface":"0.0","parking_lot":0,"price":"668.0"},{"id":2632299,"address":"1577 Los Canelos","inscription_date":"2020-10-28","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"INMOBILIARIA","building_surface":"73.0","terrain_surface":"0.0","parking_lot":0,"price":"600.0"},{"id":2128478,"address":"1545 Longavi","inscription_date":"2018-11-21","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"70.0","terrain_surface":"70.0","parking_lot":0,"price":"1028.0"},{"id":2558042,"address":"2956 Antofagasta","inscription_date":"2019-12-10","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"111.0","terrain_surface":"0.0","parking_lot":0,"price":"1237.0"},{"id":2558042,"address":"2956 Antofagasta","inscription_date":"2019-12-10","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"111.0","terrain_surface":"0.0","parking_lot":0,"price":"1237.0"},{"id":1972058,"address":"2990 Antofagasta","inscription_date":"2018-08-06","cellar":0,"property_typee":"DEPARTAMENTO","c_name":"Santiago","seller":"BANCO","building_surface":"116.0","terrain_surface":"0.0","parking_lot":0,"price":"250.0"},{"id":2632299,"address":"1577 Los Canelos","inscription_date":"2020-10-28","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"INMOBILIARIA","building_surface":"73.0","terrain_surface":"0.0","parking_lot":0,"price":"600.0"},{"id":2594664,"address":"3030 Manuel De Amat","inscription_date":"2020-03-13","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"142.0","terrain_surface":"300.0","parking_lot":0,"price":"250.0"},{"id":2594664,"address":"3030 Manuel De Amat","inscription_date":"2020-03-13","cellar":0,"property_typee":"CASA","c_name":"Santiago","seller":"PROPIETARIO","building_surface":"142.0","terrain_surface":"300.0","parking_lot":0,"price":"250.0"}]');

        },
        error: function (jqxhr, textstatus, errorthrown) {
            console.log("algo malo paso");
        }
    })
    update_table();
}

function update_filters() {
    $('tr.genTable').remove();
    $(".chartjs-render-monitor").removeAttr('class').removeAttr('style').removeAttr('width').removeAttr('height');

    $(parsed_data['property_types']).each(function () {
        $("#prop_type").append($('<option>').val($(this)[1]).text($(this)[0]));
    });
    $(parsed_data['seller_types']).each(function () {
        $("#seller_type").append($('<option>').val($(this)[1]).text($(this)[0]));
    });
    for (i = 0; i < $(parsed_data['land_use']).length; i++) {
        $("#land_use").append($('<option>').val($(parsed_data['land_use'])[i]).text($(parsed_data['land_use'])[i]));
    }
    $(parsed_data['inscription_dates']).each(function () {
        var lang = "es-ES";
        var yearBegin = parseInt($(parsed_data['inscription_dates'])[0]['from'].split("-")[0]);
        var yearTo = parseInt($(parsed_data['inscription_dates'])[0]['to'].split("-")[0]);

        //var year = 2018;

        function dateToTS(date) {
            return date.valueOf();
        }

        function tsToDate(ts) {
            var d = new Date(ts);

            return d.toLocaleDateString(lang, {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
        }

        $("#insc_date").ionRangeSlider({
            skin: "flat",
            type: "double",
            grid: true,
            min: dateToTS(new Date($(this)[0]['from'])),
            max: dateToTS(new Date($(this)[0]['to'])),
            from: dateToTS(new Date($(this)[0]['from'])),
            to: dateToTS(new Date($(this)[0]['to'])),
            prettify: tsToDate,
            onFinish: function (data) {
                dataInsc_date = {"from: ": (data.from_pretty), "to: ": (data.to_pretty)}
            }
        });
    });
    $(parsed_data['max_height']).each(function () {
        var from = parseFloat($(this)[0]['from']);
        var to = parseFloat($(this)[0]['to']);
        $("#max_height").ionRangeSlider({
            type: "double",
            min: from,
            max: to,
            from: from,
            to: to,
            drag_interval: true,
            min_interval: null,
            max_interval: null,
            onFinish: function (data) {
                dataMaxHeight = {"from: ": (data.from), "to: ": (data.to)}
            }
        });
    });
    $(parsed_data['prices']).each(function () {
        var from = parseFloat($(this)[0]['from']);
        var to = parseFloat($(this)[0]['to']);
        $("#price").ionRangeSlider({
            type: "double",
            min: from,
            max: to,
            from: from,
            to: to,
            drag_interval: true,
            min_interval: null,
            max_interval: null,
            onFinish: function (data) {
                dataPrices = {"from: ": (data.from), "to: ": (data.to)}
            }
        });
    });
    $(parsed_data['unit_prices']).each(function () {
        var from = parseFloat($(this)[0]['from']);
        var to = parseFloat($(this)[0]['to']);
        $("#u_price").ionRangeSlider({
            type: "double",
            min: from,
            max: to,
            from: from,
            to: to,
            drag_interval: true,
            min_interval: null,
            max_interval: null,
            onFinish: function (data) {
                dataUnit_prices = {"from: ": (data.from), "to: ": (data.to)}
            }
        });
    });
    $(parsed_data['terrain_surfaces']).each(function () {
        var from = parseFloat($(this)[0]['from']);
        var to = parseFloat($(this)[0]['to']);
        $("#t_surface").ionRangeSlider({
            type: "double",
            min: from,
            max: to,
            from: from,
            to: to,
            drag_interval: true,
            min_interval: null,
            max_interval: null,
            onFinish: function (data) {
                dataTerrain_surfaces = {"from: ": (data.from), "to: ": (data.to)}
            }
        });
    });
    $(parsed_data['building_surfaces']).each(function () {
        var from = parseFloat($(this)[0]['from']);
        var to = parseFloat($(this)[0]['to']);
        $("#building_surfaces").ionRangeSlider({
            type: "double",
            min: from,
            max: to,
            from: from,
            to: to,
            drag_interval: true,
            min_interval: null,
            max_interval: null,
            onFinish: function (data) {
                dataBuilding_surfaces = {"from: ": (data.from), "to: ": (data.to)}
            }
        });
    });
    $(parsed_data['density']).each(function () {
        var from = parseFloat($(this)[0]['from']);
        var to = parseFloat($(this)[0]['to']);
        $("#density").ionRangeSlider({
            type: "double",
            min: from,
            max: to,
            from: from,
            to: to,
            drag_interval: true,
            min_interval: null,
            max_interval: null,
            onFinish: function (data) {
                dataDensity = {"from: ": (data.from), "to: ": (data.to)}
            }
        });
    });
    $(document).ready(function () {
        $('#prop_type').multiselect({
            includeSelectAllOption: true
        });
        $('#seller_type').multiselect({
            includeSelectAllOption: true
        });
        $('#land_use').multiselect({
            includeSelectAllOption: true
        });
    });
    $("#intro").remove();
    $("#select-box").removeClass("d-none");
    $("#map_flex").css('height', '100%');
}

////////////////////////////////////////////////////////

Congo.flex_dashboards.action_index = function () {
    let map_admin, marker, flexMap;

    let init = function () {
        let flexMap = create_map();
        let fgr = L.featureGroup().addTo(flexMap);

        add_control(flexMap, fgr);

        flexMap.on('draw:created', function (e) {
            let data = draw_geometry(e, fgr);

            Congo.flex_dashboards.config.geo_selection = data
            if ('error' in data) {
                $('#alerts').append(data['error']);

                setTimeout(() => {
                    $('#alerts').empty();
                }, 5000)
            } else {
                geoserver_data(data, flexMap, fgr);

                console.log('Parámetros filtros');
                console.log(data);

                $.ajax({
                    async: false,
                    type: 'get',
                    url: 'flex/dashboards/search_data_for_filters.json',
                    datatype: 'json',
                    data: data,
                    success: function (data) {

                        console.log('Datos filtros');
                        console.log(data);

                        // parsed_data = data;

                        // Ejemplo
                        parsed_data = JSON.parse('{\"property_types\":[[\"Casas\",1],[\"Departamentos\",2],[\"Oficinas\",3],[\"Local Comercial\",4],[\"Oficina y Local Comercial\",5]],\"inscription_dates\":{\"from\":\"2018-02-15\",\"to\":\"2020-12-30\"},\"seller_types\":[[\"PROPIETARIO\",1],[\"INMOBILIARIA\",2],[\"EMPRESA\",3],[\"BANCO\",4]],\"land_use\":[\"EA12\",\"EA12 pa\",\"EA7\",\"PzVec\",\"ZEP AE\",\"EC2+A8\",\"ZIM\"],\"max_height\":{\"from\":0,\"to\":99},\"density\":{\"from\":0,\"to\":1100},\"building_surfaces\":{\"from\":0,\"to\":520},\"terrain_surfaces\":{\"from\":0,\"to\":2147},\"prices\":{\"from\":64,\"to\":42900},\"unit_prices\":{\"from\":0,\"to\":2247}}');

                    },
                    error: function (jqxhr, textstatus, errorthrown) {
                        console.log("algo malo paso");
                    }
                });

            update_filters();
            }
        });
    }
    return {
        init: init,
    }
}();
