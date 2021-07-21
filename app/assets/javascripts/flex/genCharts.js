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
            // charts = JSON.parse('[{"title":"Cantidad","series":[{"name":"Cantidad","data":[{"name":"1/2019","count":17},{"name":"1/2020","count":25},{"name":"1/2021","count":5},{"name":"2/2019","count":39},{"name":"2/2020","count":18},{"name":"3/2019","count":122},{"name":"3/2020","count":12},{"name":"4/2018","count":17},{"name":"4/2019","count":75},{"name":"4/2020","count":6},{"name":"5/2018","count":26},{"name":"5/2019","count":21},{"name":"5/2020","count":13},{"name":"6/2018","count":14},{"name":"6/2019","count":23},{"name":"6/2020","count":11}]},{"name":"Promedio","data":[{"name":"1/2019","count":"27.75"},{"name":"1/2020","count":"27.75"},{"name":"1/2021","count":"27.75"},{"name":"2/2019","count":"27.75"},{"name":"2/2020","count":"27.75"},{"name":"3/2019","count":"27.75"},{"name":"3/2020","count":"27.75"},{"name":"4/2018","count":"27.75"},{"name":"4/2019","count":"27.75"},{"name":"4/2020","count":"27.75"},{"name":"5/2018","count":"27.75"},{"name":"5/2019","count":"27.75"},{"name":"5/2020","count":"27.75"},{"name":"6/2018","count":"27.75"},{"name":"6/2019","count":"27.75"},{"name":"6/2020","count":"27.75"}]}]},{"title":"Superficie Útil","series":[{"name":"Promedio Bimestre","data":[{"name":"1/2019","count":"44.3333333333333333"},{"name":"1/2020","count":"76.6363636363636364"},{"name":"1/2021","count":"32.8"},{"name":"2/2019","count":"45.6666666666666667"},{"name":"2/2020","count":"46.0"},{"name":"3/2019","count":"33.4424778761061947"},{"name":"3/2020","count":"37.75"},{"name":"4/2018","count":"40.8666666666666667"},{"name":"4/2019","count":"31.2957746478873239"},{"name":"4/2020","count":"52.6666666666666667"},{"name":"5/2018","count":"91.9047619047619048"},{"name":"5/2019","count":"35.15"},{"name":"5/2020","count":"45.2"},{"name":"6/2018","count":"42.1"},{"name":"6/2019","count":"36.6666666666666667"},{"name":"6/2020","count":"53.5"}]},{"name":"Promedio Muestra","data":[{"name":"1/2019","count":"46.62"},{"name":"1/2020","count":"46.62"},{"name":"1/2021","count":"46.62"},{"name":"2/2019","count":"46.62"},{"name":"2/2020","count":"46.62"},{"name":"3/2019","count":"46.62"},{"name":"3/2020","count":"46.62"},{"name":"4/2018","count":"46.62"},{"name":"4/2019","count":"46.62"},{"name":"4/2020","count":"46.62"},{"name":"5/2018","count":"46.62"},{"name":"5/2019","count":"46.62"},{"name":"5/2020","count":"46.62"},{"name":"6/2018","count":"46.62"},{"name":"6/2019","count":"46.62"},{"name":"6/2020","count":"46.62"}]}]},{"title":"Precio","series":[{"name":"Promedio Bimestre","data":[{"name":"1/2019","count":"1674.1764705882352941"},{"name":"1/2020","count":"2554.36"},{"name":"1/2021","count":"2221.2"},{"name":"2/2019","count":"2230.8205128205128205"},{"name":"2/2020","count":"2326.6666666666666667"},{"name":"3/2019","count":"2540.4344262295081967"},{"name":"3/2020","count":"2513.75"},{"name":"4/2018","count":"1708.8235294117647059"},{"name":"4/2019","count":"2568.72"},{"name":"4/2020","count":"2256.3333333333333333"},{"name":"5/2018","count":"1649.8846153846153846"},{"name":"5/2019","count":"2464.3333333333333333"},{"name":"5/2020","count":"1927.0769230769230769"},{"name":"6/2018","count":"1438.2857142857142857"},{"name":"6/2019","count":"2716.3478260869565217"},{"name":"6/2020","count":"1970.7272727272727273"}]},{"name":"Promedio Muestra","data":[{"name":"1/2019","count":"2172.62"},{"name":"1/2020","count":"2172.62"},{"name":"1/2021","count":"2172.62"},{"name":"2/2019","count":"2172.62"},{"name":"2/2020","count":"2172.62"},{"name":"3/2019","count":"2172.62"},{"name":"3/2020","count":"2172.62"},{"name":"4/2018","count":"2172.62"},{"name":"4/2019","count":"2172.62"},{"name":"4/2020","count":"2172.62"},{"name":"5/2018","count":"2172.62"},{"name":"5/2019","count":"2172.62"},{"name":"5/2020","count":"2172.62"},{"name":"6/2018","count":"2172.62"},{"name":"6/2019","count":"2172.62"},{"name":"6/2020","count":"2172.62"}]}]},{"title":"Precio Unitario","series":[{"name":"Promedio Bimestre","data":[{"name":"1/2019","count":"55.3106666666666667"},{"name":"1/2020","count":"49.2645"},{"name":"1/2021","count":"59.7325"},{"name":"2/2019","count":"81.218"},{"name":"2/2020","count":"60.44"},{"name":"3/2019","count":"73.0376666666666667"},{"name":"3/2020","count":"56.4844444444444444"},{"name":"4/2018","count":"58.7846666666666667"},{"name":"4/2019","count":"78.4504347826086957"},{"name":"4/2020","count":"43.9433333333333333"},{"name":"5/2018","count":"79.2076190476190476"},{"name":"5/2019","count":"71.385625"},{"name":"5/2020","count":"52.3177777777777778"},{"name":"6/2018","count":"135.453"},{"name":"6/2019","count":"124.419375"},{"name":"6/2020","count":"49.3822222222222222"}]},{"name":"Promedio Muestra","data":[{"name":"1/2019","count":"70.55"},{"name":"1/2020","count":"70.55"},{"name":"1/2021","count":"70.55"},{"name":"2/2019","count":"70.55"},{"name":"2/2020","count":"70.55"},{"name":"3/2019","count":"70.55"},{"name":"3/2020","count":"70.55"},{"name":"4/2018","count":"70.55"},{"name":"4/2019","count":"70.55"},{"name":"4/2020","count":"70.55"},{"name":"5/2018","count":"70.55"},{"name":"5/2019","count":"70.55"},{"name":"5/2020","count":"70.55"},{"name":"6/2018","count":"70.55"},{"name":"6/2019","count":"70.55"},{"name":"6/2020","count":"70.55"}]}]},{"title":"Volúmen Mercado","series":[{"name":"Promedio Bimestre","data":[{"name":"1/2019","count":"28460.9999999999999997"},{"name":"1/2020","count":"63859.0"},{"name":"1/2021","count":"11106.0"},{"name":"2/2019","count":"87001.9999999999999995"},{"name":"2/2020","count":"41880.0000000000000006"},{"name":"3/2019","count":"309932.9999999999999974"},{"name":"3/2020","count":"30165.0"},{"name":"4/2018","count":"29050.0000000000000003"},{"name":"4/2019","count":"192654.0"},{"name":"4/2020","count":"13537.9999999999999998"},{"name":"5/2018","count":"42896.9999999999999996"},{"name":"5/2019","count":"51750.9999999999999993"},{"name":"5/2020","count":"25051.9999999999999997"},{"name":"6/2018","count":"20135.9999999999999998"},{"name":"6/2019","count":"62475.9999999999999991"},{"name":"6/2020","count":"21678.0000000000000003"}]},{"name":"Promedio Muestra","data":[{"name":"1/2019","count":"64477.38"},{"name":"1/2020","count":"64477.38"},{"name":"1/2021","count":"64477.38"},{"name":"2/2019","count":"64477.38"},{"name":"2/2020","count":"64477.38"},{"name":"3/2019","count":"64477.38"},{"name":"3/2020","count":"64477.38"},{"name":"4/2018","count":"64477.38"},{"name":"4/2019","count":"64477.38"},{"name":"4/2020","count":"64477.38"},{"name":"5/2018","count":"64477.38"},{"name":"5/2019","count":"64477.38"},{"name":"5/2020","count":"64477.38"},{"name":"6/2018","count":"64477.38"},{"name":"6/2019","count":"64477.38"},{"name":"6/2020","count":"64477.38"}]}]},{"title":"Superficie Útil (barras)","series":[{"data":[{"name":"1","count":441},{"name":"2","count":1},{"name":"3","count":0},{"name":"4","count":0},{"name":"5","count":1},{"name":"6","count":1}]}]},{"title":"Precio (barras)","series":[{"data":[{"name":"1","count":81},{"name":"2","count":340},{"name":"3","count":21},{"name":"4","count":0},{"name":"5","count":0},{"name":"6","count":2}]}]},{"title":"Precio Unitario (barras)","series":[{"data":[{"name":"1","count":433},{"name":"2","count":4},{"name":"3","count":0},{"name":"4","count":2},{"name":"5","count":3},{"name":"6","count":2}]}]},{"title":"Superficie por UF","series":[{"data":[{"name":"20.0","count":null,"radius":1},{"name":"24.0","count":null,"radius":1},{"name":"25.0","count":null,"radius":1},{"name":"29.0","count":null,"radius":1},{"name":"36.0","count":null,"radius":1},{"name":"44.0","count":null,"radius":1},{"name":"50.0","count":null,"radius":2},{"name":"54.0","count":null,"radius":1},{"name":"55.0","count":null,"radius":1},{"name":"56.0","count":null,"radius":1},{"name":"72.0","count":null,"radius":1},{"name":"73.0","count":null,"radius":2},{"name":"100.0","count":null,"radius":2},{"name":"180.0","count":null,"radius":1},{"name":"183.0","count":"3.0","radius":1},{"name":"250.0","count":"136.5","radius":5},{"name":"256.0","count":null,"radius":1},{"name":"300.0","count":null,"radius":1},{"name":"320.0","count":null,"radius":1},{"name":"350.0","count":null,"radius":2},{"name":"400.0","count":null,"radius":1},{"name":"430.0","count":null,"radius":1},{"name":"481.0","count":"68.0","radius":1},{"name":"490.0","count":"33.0","radius":1},{"name":"509.0","count":"46.0","radius":1},{"name":"663.0","count":"40.0","radius":1},{"name":"688.0","count":"37.0","radius":1},{"name":"806.0","count":null,"radius":1},{"name":"878.0","count":"26.0","radius":1},{"name":"915.0","count":"32.0","radius":1},{"name":"1000.0","count":"37.0","radius":1},{"name":"1024.0","count":"32.0","radius":1},{"name":"1026.0","count":"68.0","radius":1},{"name":"1046.0","count":"50.0","radius":2},{"name":"1056.0","count":"35.0","radius":1},{"name":"1059.0","count":"33.0","radius":1},{"name":"1084.0","count":"32.0","radius":1},{"name":"1091.0","count":"33.0","radius":1},{"name":"1100.0","count":"35.0","radius":1},{"name":"1103.0","count":"71.0","radius":1},{"name":"1117.0","count":"32.0","radius":1},{"name":"1122.0","count":"2.0","radius":1},{"name":"1162.0","count":"47.0","radius":1},{"name":"1312.0","count":"126.0","radius":1},{"name":"1389.0","count":"19.0","radius":3},{"name":"1406.0","count":"38.0","radius":1},{"name":"1451.0","count":"56.0","radius":1},{"name":"1462.0","count":"62.0","radius":1},{"name":"1500.0","count":"18.0","radius":2},{"name":"1514.0","count":"20.0","radius":1},{"name":"1555.0","count":"26.0","radius":2},{"name":"1560.0","count":"19.5","radius":2},{"name":"1579.0","count":"59.0","radius":1},{"name":"1582.0","count":"22.0","radius":1},{"name":"1584.0","count":"63.0","radius":1},{"name":"1586.0","count":"51.0","radius":1},{"name":"1600.0","count":"31.0","radius":1},{"name":"1624.0","count":null,"radius":1},{"name":"1634.0","count":"63.0","radius":1},{"name":"1650.0","count":"32.0","radius":1},{"name":"1685.0","count":"1078.0","radius":1},{"name":"1705.0","count":"31.0","radius":1},{"name":"1742.0","count":"36.0","radius":1},{"name":"1748.0","count":"27.0","radius":1},{"name":"1750.0","count":"32.0","radius":1},{"name":"1770.0","count":"35.0","radius":1},{"name":"1777.0","count":"56.0","radius":1},{"name":"1778.0","count":"30.0","radius":1},{"name":"1780.0","count":"32.0","radius":2},{"name":"1802.0","count":"30.0","radius":1},{"name":"1804.0","count":"51.0","radius":1},{"name":"1805.0","count":"33.0","radius":1},{"name":"1820.0","count":"32.0","radius":1},{"name":"1831.0","count":"46.0","radius":1},{"name":"1850.0","count":"37.0","radius":1},{"name":"1853.0","count":"32.0","radius":1},{"name":"1859.0","count":"52.0","radius":1},{"name":"1869.0","count":"31.0","radius":1},{"name":"1880.0","count":"42.0","radius":1},{"name":"1892.0","count":"49.5","radius":2},{"name":"1900.0","count":"32.5","radius":2},{"name":"1905.0","count":"51.0","radius":1},{"name":"1912.0","count":"32.0","radius":1},{"name":"1950.0","count":"32.0","radius":1},{"name":"1959.0","count":"36.0","radius":1},{"name":"1963.0","count":"30.0","radius":1},{"name":"1982.0","count":"33.0","radius":1},{"name":"1989.0","count":"35.0","radius":1},{"name":"1990.0","count":"35.5","radius":2},{"name":"1993.0","count":"43.0","radius":1},{"name":"1996.0","count":"62.0","radius":1},{"name":"1999.0","count":"30.0","radius":1},{"name":"2000.0","count":"39.0","radius":4},{"name":"2003.0","count":"33.0","radius":1},{"name":"2006.0","count":"32.0","radius":1},{"name":"2037.0","count":"37.0","radius":1},{"name":"2040.0","count":"49.0","radius":1},{"name":"2050.0","count":"28.5","radius":2},{"name":"2068.0","count":"34.0","radius":1},{"name":"2075.0","count":"36.0","radius":1},{"name":"2077.0","count":"39.0","radius":2},{"name":"2084.0","count":"40.0","radius":1},{"name":"2089.0","count":"48.0","radius":1},{"name":"2094.0","count":"33.0","radius":1},{"name":"2099.0","count":"48.0","radius":1},{"name":"2100.0","count":"26.6666666666666667","radius":3},{"name":"2118.0","count":"51.0","radius":1},{"name":"2124.0","count":"33.0","radius":1},{"name":"2129.0","count":"46.0","radius":1},{"name":"2130.0","count":"33.0","radius":1},{"name":"2132.0","count":"32.0","radius":1},{"name":"2138.0","count":"32.0","radius":1},{"name":"2140.0","count":"50.0","radius":2},{"name":"2141.0","count":"34.0","radius":1},{"name":"2148.0","count":"34.0","radius":1},{"name":"2150.0","count":"17.5","radius":2},{"name":"2155.0","count":"30.0","radius":1},{"name":"2159.0","count":"34.0","radius":1},{"name":"2160.0","count":"33.5","radius":2},{"name":"2161.0","count":"0.0","radius":1},{"name":"2165.0","count":"34.0","radius":2},{"name":"2171.0","count":"33.0","radius":1},{"name":"2172.0","count":"32.0","radius":1},{"name":"2186.0","count":"33.0","radius":1},{"name":"2191.0","count":"46.0","radius":1},{"name":"2192.0","count":"38.0","radius":1},{"name":"2195.0","count":"36.0","radius":1},{"name":"2200.0","count":"44.0","radius":3},{"name":"2202.0","count":"35.0","radius":1},{"name":"2209.0","count":"34.0","radius":1},{"name":"2211.0","count":"23.0","radius":2},{"name":"2212.0","count":"46.0","radius":1},{"name":"2218.0","count":"0.0","radius":1},{"name":"2225.0","count":"35.0","radius":1},{"name":"2228.0","count":"32.0","radius":1},{"name":"2238.0","count":"38.0","radius":1},{"name":"2239.0","count":null,"radius":1},{"name":"2241.0","count":"35.0","radius":1},{"name":"2243.0","count":"46.0","radius":1},{"name":"2247.0","count":"36.0","radius":1},{"name":"2248.0","count":"33.0","radius":1},{"name":"2250.0","count":"16.5","radius":2},{"name":"2252.0","count":"33.6666666666666667","radius":3},{"name":"2260.0","count":"38.0","radius":1},{"name":"2264.0","count":"48.0","radius":1},{"name":"2268.0","count":"33.0","radius":1},{"name":"2269.0","count":"0.0","radius":1},{"name":"2270.0","count":"0.0","radius":1},{"name":"2271.0","count":"34.0","radius":1},{"name":"2273.0","count":"33.0","radius":1},{"name":"2281.0","count":"33.0","radius":1},{"name":"2287.0","count":"33.0","radius":1},{"name":"2291.0","count":"32.0","radius":1},{"name":"2292.0","count":"33.0","radius":1},{"name":"2295.0","count":null,"radius":1},{"name":"2298.0","count":"33.0","radius":1},{"name":"2300.0","count":"44.3333333333333333","radius":6},{"name":"2303.0","count":"33.0","radius":1},{"name":"2317.0","count":"33.0","radius":1},{"name":"2318.0","count":"66.0","radius":1},{"name":"2323.0","count":"34.0","radius":1},{"name":"2325.0","count":"30.0","radius":1},{"name":"2327.0","count":"38.0","radius":1},{"name":"2332.0","count":"35.0","radius":1},{"name":"2333.0","count":"43.0","radius":1},{"name":"2339.0","count":"35.5","radius":2},{"name":"2350.0","count":"41.0","radius":3},{"name":"2351.0","count":"38.0","radius":1},{"name":"2353.0","count":"33.0","radius":1},{"name":"2356.0","count":"40.0","radius":1},{"name":"2358.0","count":"38.0","radius":2},{"name":"2361.0","count":"34.5","radius":2},{"name":"2364.0","count":"69.0","radius":1},{"name":"2365.0","count":"34.0","radius":2},{"name":"2367.0","count":"17.5","radius":2},{"name":"2372.0","count":"35.0","radius":1},{"name":"2373.0","count":"40.0","radius":1},{"name":"2375.0","count":null,"radius":1},{"name":"2377.0","count":"34.0","radius":1},{"name":"2383.0","count":"33.0","radius":2},{"name":"2385.0","count":"16.5","radius":2},{"name":"2386.0","count":"34.0","radius":1},{"name":"2388.0","count":"34.0","radius":1},{"name":"2390.0","count":"33.0","radius":2},{"name":"2397.0","count":"36.0","radius":1},{"name":"2398.0","count":"33.0","radius":2},{"name":"2401.0","count":"68.0","radius":1},{"name":"2404.0","count":"33.0","radius":1},{"name":"2407.0","count":"33.5","radius":2},{"name":"2410.0","count":"33.0","radius":1},{"name":"2411.0","count":"48.0","radius":1},{"name":"2412.0","count":"36.0","radius":1},{"name":"2415.0","count":"3.0","radius":1},{"name":"2420.0","count":"0.0","radius":1},{"name":"2424.0","count":"41.5","radius":2},{"name":"2425.0","count":"161.0","radius":1},{"name":"2432.0","count":"34.0","radius":1},{"name":"2434.0","count":"34.0","radius":2},{"name":"2438.0","count":"17.0","radius":3},{"name":"2447.0","count":"0.0","radius":1},{"name":"2448.0","count":"34.0","radius":1},{"name":"2450.0","count":"33.0","radius":1},{"name":"2453.0","count":"34.0","radius":1},{"name":"2463.0","count":"34.0","radius":1},{"name":"2467.0","count":"38.0","radius":1},{"name":"2469.0","count":"0.0","radius":1},{"name":"2470.0","count":"46.0","radius":1},{"name":"2474.0","count":"27.5","radius":2},{"name":"2476.0","count":"68.0","radius":1},{"name":"2477.0","count":"35.0","radius":1},{"name":"2495.0","count":"34.0","radius":1},{"name":"2500.0","count":"50.0","radius":2},{"name":"2501.0","count":"36.0","radius":1},{"name":"2504.0","count":"43.5","radius":2},{"name":"2505.0","count":"51.0","radius":1},{"name":"2506.0","count":"34.0","radius":1},{"name":"2509.0","count":"35.0","radius":1},{"name":"2510.0","count":"0.0","radius":1},{"name":"2514.0","count":"63.0","radius":1},{"name":"2515.0","count":"33.0","radius":1},{"name":"2528.0","count":"33.0","radius":1},{"name":"2538.0","count":"38.0","radius":1},{"name":"2541.0","count":"47.0","radius":1},{"name":"2550.0","count":"59.0","radius":1},{"name":"2552.0","count":"41.3333333333333333","radius":3},{"name":"2567.0","count":"59.0","radius":1},{"name":"2568.0","count":"36.0","radius":1},{"name":"2569.0","count":"32.0","radius":1},{"name":"2581.0","count":"34.0","radius":1},{"name":"2583.0","count":"12.0","radius":1},{"name":"2592.0","count":"33.0","radius":1},{"name":"2602.0","count":"26.0","radius":1},{"name":"2605.0","count":"63.0","radius":1},{"name":"2609.0","count":"46.0","radius":1},{"name":"2625.0","count":"37.0","radius":1},{"name":"2626.0","count":"16.5","radius":2},{"name":"2628.0","count":"34.0","radius":1},{"name":"2631.0","count":"66.0","radius":1},{"name":"2632.0","count":"33.0","radius":1},{"name":"2634.0","count":"34.0","radius":1},{"name":"2636.0","count":"0.0","radius":1},{"name":"2640.0","count":"42.0","radius":2},{"name":"2641.0","count":"43.0","radius":1},{"name":"2650.0","count":"62.0","radius":1},{"name":"2660.0","count":"62.0","radius":1},{"name":"2661.0","count":"48.0","radius":1},{"name":"2664.0","count":"0.0","radius":1},{"name":"2665.0","count":"34.0","radius":1},{"name":"2679.0","count":"41.5","radius":2},{"name":"2683.0","count":"43.0","radius":1},{"name":"2686.0","count":"43.0","radius":1},{"name":"2695.0","count":"0.0","radius":1},{"name":"2700.0","count":"69.0","radius":1},{"name":"2704.0","count":"47.5","radius":2},{"name":"2705.0","count":"59.0","radius":1},{"name":"2724.0","count":null,"radius":1},{"name":"2736.0","count":"34.0","radius":1},{"name":"2737.0","count":"33.0","radius":1},{"name":"2750.0","count":"26.3333333333333333","radius":3},{"name":"2774.0","count":"34.0","radius":1},{"name":"2776.0","count":null,"radius":1},{"name":"2777.0","count":"43.0","radius":1},{"name":"2780.0","count":"70.0","radius":1},{"name":"2784.0","count":"62.0","radius":1},{"name":"2788.0","count":"47.0","radius":1},{"name":"2789.0","count":null,"radius":1},{"name":"2793.0","count":"37.5","radius":2},{"name":"2800.0","count":"47.0","radius":2},{"name":"2801.0","count":"0.0","radius":1},{"name":"2808.0","count":"32.0","radius":1},{"name":"2812.0","count":"32.0","radius":1},{"name":"2837.0","count":"0.0","radius":1},{"name":"2843.0","count":"0.0","radius":1},{"name":"2850.0","count":"56.0","radius":2},{"name":"2861.0","count":null,"radius":1},{"name":"2870.0","count":"0.0","radius":1},{"name":"2875.0","count":"38.0","radius":1},{"name":"2876.0","count":"0.0","radius":1},{"name":"2891.0","count":"43.0","radius":1},{"name":"2898.0","count":"38.0","radius":1},{"name":"2900.0","count":"34.5","radius":2},{"name":"2901.0","count":"32.0","radius":1},{"name":"2903.0","count":"3.0","radius":1},{"name":"2923.0","count":"35.0","radius":1},{"name":"2950.0","count":"41.0","radius":1},{"name":"2957.0","count":"0.0","radius":1},{"name":"2970.0","count":"40.0","radius":1},{"name":"2975.0","count":"0.0","radius":1},{"name":"2980.0","count":"67.0","radius":1},{"name":"2984.0","count":"0.0","radius":1},{"name":"2989.0","count":"44.0","radius":1},{"name":"2990.0","count":"42.0","radius":1},{"name":"3000.0","count":"55.5","radius":2},{"name":"3004.0","count":"68.0","radius":1},{"name":"3010.0","count":"51.0","radius":1},{"name":"3014.0","count":"66.0","radius":1},{"name":"3025.0","count":"0.0","radius":1},{"name":"3040.0","count":"68.0","radius":1},{"name":"3053.0","count":"44.0","radius":1},{"name":"3056.0","count":"0.0","radius":1},{"name":"3064.0","count":"43.0","radius":1},{"name":"3065.0","count":"56.0","radius":1},{"name":"3090.0","count":"68.0","radius":1},{"name":"3092.0","count":"0.0","radius":1},{"name":"3103.0","count":"0.0","radius":1},{"name":"3132.0","count":"44.0","radius":1},{"name":"3141.0","count":"48.0","radius":1},{"name":"3142.0","count":"43.0","radius":1},{"name":"3146.0","count":"50.0","radius":1},{"name":"3179.0","count":"0.0","radius":1},{"name":"3186.0","count":"0.0","radius":1},{"name":"3200.0","count":"47.0","radius":2},{"name":"3211.0","count":"42.0","radius":1},{"name":"3223.0","count":"42.0","radius":1},{"name":"3233.0","count":"0.0","radius":1},{"name":"3240.0","count":"0.0","radius":1},{"name":"3241.0","count":"50.0","radius":1},{"name":"3243.0","count":"48.0","radius":1},{"name":"3254.0","count":"43.0","radius":1},{"name":"3265.0","count":"42.0","radius":1},{"name":"3285.0","count":"44.0","radius":1},{"name":"3292.0","count":"0.0","radius":1},{"name":"3300.0","count":"48.0","radius":1},{"name":"3306.0","count":"68.0","radius":1},{"name":"3312.0","count":"0.0","radius":1},{"name":"3322.0","count":"69.0","radius":1},{"name":"3351.0","count":"32.0","radius":1},{"name":"3362.0","count":"48.0","radius":1},{"name":"3366.0","count":"0.0","radius":1},{"name":"3375.0","count":"35.0","radius":1},{"name":"3377.0","count":"48.0","radius":1},{"name":"3390.0","count":"49.0","radius":1},{"name":"3402.0","count":"47.0","radius":1},{"name":"3413.0","count":"48.0","radius":1},{"name":"3416.0","count":"0.0","radius":1},{"name":"3417.0","count":"47.0","radius":1},{"name":"3434.0","count":"84.0","radius":1},{"name":"3446.0","count":"47.0","radius":1},{"name":"3458.0","count":"0.0","radius":1},{"name":"3470.0","count":"47.0","radius":1},{"name":"3478.0","count":"52.0","radius":1},{"name":"3486.0","count":"0.0","radius":1},{"name":"3490.0","count":"49.0","radius":1},{"name":"3500.0","count":"68.0","radius":1},{"name":"3511.0","count":"51.0","radius":1},{"name":"3522.0","count":"50.0","radius":1},{"name":"3526.0","count":"49.0","radius":1},{"name":"3527.0","count":"50.0","radius":1},{"name":"3542.0","count":"48.0","radius":1},{"name":"3544.0","count":"0.0","radius":1},{"name":"3545.0","count":"52.0","radius":2},{"name":"3555.0","count":"52.0","radius":1},{"name":"3603.0","count":"0.0","radius":1},{"name":"3605.0","count":"0.0","radius":1},{"name":"3616.0","count":"0.0","radius":1},{"name":"3644.0","count":null,"radius":1},{"name":"3649.0","count":"47.0","radius":1},{"name":"3671.0","count":"47.0","radius":1},{"name":"3745.0","count":"47.0","radius":1},{"name":"3783.0","count":"51.0","radius":1},{"name":"3800.0","count":"69.0","radius":1},{"name":"3819.0","count":"58.0","radius":1},{"name":"3826.0","count":"47.0","radius":1},{"name":"3865.0","count":null,"radius":1},{"name":"3930.0","count":"52.0","radius":1},{"name":"3989.0","count":"57.0","radius":1},{"name":"4353.0","count":"168.0","radius":1},{"name":"5236.0","count":"24.0","radius":1},{"name":"8835.0","count":"111.0","radius":1},{"name":"10562.0","count":"794.0","radius":1}]}]}]')


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
                        r: ($(this)[0]['series'][0]['data'][i]['radius'])*2
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
