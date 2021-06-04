Congo.namespace('flex_dashboards.action_index');

//filters
var parsed_data = ""
var table_data = ""
dataInsc_date = {}; dataPrices = {}; dataUnit_prices = {}; dataTerrain_surfaces = {}; dataBuilding_surfaces = {}; dataLand_use = {};

var filteredData = {} ;

function update_table() {
    $(table_data).each(function(index){
        $('#table tr:last').after(
            '<tr class="table-bg1">' +
            '<td><input class="form-check-input" type="checkbox" value="' + index + '"></td>' +
            '<td>' + ($(this)[0]["property_typee"]) + '</td>' +
            '<td>' + ($(this)[0]["address"]) + '</td>' +
            '<td>' + ($(this)[0]['c_name']) + '</td>' +
            '<td>' + '' + '</td>' +
            '<td>' + ($(this)[0]['cellar']) + '</td>' +
            '<td>' + ($(this)[0]['id']) + '</td>' +
            '<td>' + ($(this)[0]['inscription_date']) + '</td>' +
            '<td>' + ($(this)[0]['seller']) + '</td>' +
            '<td>' + ($(this)[0]['building_surface']) + '</td>' +
            '<td>' + ($(this)[0]['terrain_surface']) + '</td>' +
            '<td>' + '' + '</td>' +
            '<td>' + '' + '</td>' +
            '<td>' + '' + '</td>' +
            '<td>' + '' + '</td>' +
            '<td>' + '' + '</td>' +
            '</tr>'
        );
    });
}

function getFilteredData() {
    propertyTypes = $("#prop_type").val();
    sellerTypes = $("#seller_type").val();

    filteredData = {
        property_types : propertyTypes,
        seller_types : sellerTypes,
        inscription_dates : dataInsc_date,
        prices : dataPrices,
        unit_prices : dataUnit_prices,
        terrain_surfaces : dataTerrain_surfaces,
        building_surfaces : dataBuilding_surfaces,
        land_use : dataLand_use
    }
    ////// DESPUES BORRA ESTO SI NO NECESITAS QUE SALGA EN CONSOLA
    console.log(filteredData);

    $.ajax({
        async: false,
        type: 'get',
        url: 'flex/dashboards/search_data_for_table.json',
        datatype: 'json',
        data: data,
        success: function (data) {

            table_data = [{"id":3929666,"address":"632 Cruchaga Montt","inscription_date":"2020-12-14","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"172.0","terrain_surface":"172.0","parking_lot":0,"price":"1032.0"},{"id":3898209,"address":"4588 Pasaje Elvira Davila","inscription_date":"2020-11-23","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"110.0","terrain_surface":"196.0","parking_lot":0,"price":"3831.0"},{"id":2615973,"address":"793 Pedro Antonio Gonzalez","inscription_date":"2020-08-18","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"131.0","terrain_surface":"147.0","parking_lot":0,"price":"1953.0"},{"id":2597245,"address":"4739 Porto Seguro","inscription_date":"2020-05-04","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"EMPRESA","building_surface":"112.0","terrain_surface":"194.0","parking_lot":0,"price":"4703.0"},{"id":2594402,"address":"437 Radal","inscription_date":"2020-03-11","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"104.0","terrain_surface":"176.0","parking_lot":0,"price":"3560.0"},{"id":2506068,"address":"530 Herbert Hoover","inscription_date":"2019-11-14","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"132.0","terrain_surface":"163.0","parking_lot":0,"price":"2504.0"},{"id":2503657,"address":"622 Cantinera","inscription_date":"2019-06-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"126.0","terrain_surface":"108.0","parking_lot":0,"price":"1400.0"},{"id":2503587,"address":"148 Calle Little Rock","inscription_date":"2019-06-04","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"146.0","terrain_surface":"172.0","parking_lot":0,"price":"779.0"},{"id":2482173,"address":"392 Ladislao Gallego","inscription_date":"2019-08-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"100.0","terrain_surface":"162.0","parking_lot":0,"price":"2162.0"},{"id":2464137,"address":"4406 Catedral","inscription_date":"2019-10-18","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"176.0","terrain_surface":"199.0","parking_lot":0,"price":"731.0"},{"id":2307090,"address":"16 La Plazuela Del Jaracanda","inscription_date":"2019-06-20","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"100.0","terrain_surface":"162.0","parking_lot":0,"price":"2543.0"},{"id":2303584,"address":"262 Gaspar De Orense","inscription_date":"2019-06-03","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"100.0","terrain_surface":"200.0","parking_lot":0,"price":"756.0"},{"id":2261290,"address":"953 General Velasquez","inscription_date":"2019-05-07","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"108.0","terrain_surface":"140.0","parking_lot":0,"price":"1625.0"},{"id":2261019,"address":"98 Santa Petronila","inscription_date":"2019-05-06","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"134.0","terrain_surface":"140.0","parking_lot":0,"price":"542.0"},{"id":2255696,"address":"404 Pasaje Marinero Ojeda","inscription_date":"2019-03-06","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"159.0","terrain_surface":"162.0","parking_lot":0,"price":"2431.0"},{"id":2254176,"address":"793 Pedro Antonio Gonzalez","inscription_date":"2019-02-22","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"131.0","terrain_surface":"147.0","parking_lot":0,"price":"1927.0"},{"id":2189686,"address":"307 Pardo Villalon","inscription_date":"2019-02-07","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"108.0","terrain_surface":"162.0","parking_lot":0,"price":"726.0"},{"id":2189029,"address":"5848 Caldera","inscription_date":"2019-02-05","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"INMOBILIARIA","building_surface":"121.0","terrain_surface":"162.0","parking_lot":0,"price":"2104.0"},{"id":2186890,"address":"6159 Isla Walton","inscription_date":"2019-01-24","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"178.0","terrain_surface":"162.0","parking_lot":0,"price":"3267.0"},{"id":2186605,"address":"1132 Estados Unidos","inscription_date":"2019-01-22","cellar":0,"property_typee":"CASA","c_name":"Cerro Navia","seller":"PROPIETARIO","building_surface":"105.0","terrain_surface":"147.0","parking_lot":0,"price":"2088.0"},{"id":2185362,"address":"5982 Canal Ballenero","inscription_date":"2019-01-09","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"133.0","terrain_surface":"193.0","parking_lot":0,"price":"907.0"},{"id":2165865,"address":"6124 Jiroz","inscription_date":"2019-05-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"148.0","terrain_surface":"162.0","parking_lot":0,"price":"848.0"},{"id":2165542,"address":"8041 Lago Ontario","inscription_date":"2019-04-24","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"108.0","terrain_surface":"162.0","parking_lot":0,"price":"1270.0"},{"id":2163594,"address":"6137 Capitan Pedro De Cordova","inscription_date":"2019-03-28","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"148.0","terrain_surface":"162.0","parking_lot":0,"price":"1814.0"},{"id":2163184,"address":"134 Los Pinos","inscription_date":"2019-03-26","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"101.0","terrain_surface":"162.0","parking_lot":0,"price":"3084.0"},{"id":2156936,"address":"6474 Lo Prado","inscription_date":"2018-10-10","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"EMPRESA","building_surface":"144.0","terrain_surface":"190.0","parking_lot":0,"price":"1644.0"},{"id":2155103,"address":"517 Froilan Bijou","inscription_date":"2018-08-21","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"100.0","terrain_surface":"162.0","parking_lot":0,"price":"3027.0"},{"id":2122455,"address":"379 Ministro Gana","inscription_date":"2018-03-09","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"175.0","terrain_surface":"162.0","parking_lot":0,"price":"1491.0"},{"id":2095374,"address":"854 Los Lirios","inscription_date":"2018-11-23","cellar":1,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"106.0","terrain_surface":"200.0","parking_lot":0,"price":"727.0"},{"id":2095232,"address":"8058 Tacora","inscription_date":"2018-11-21","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"120.0","terrain_surface":"127.0","parking_lot":0,"price":"909.0"},{"id":2091701,"address":"313 Chiclayo","inscription_date":"2018-10-25","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"110.0","terrain_surface":"162.0","parking_lot":0,"price":"973.0"},{"id":2066314,"address":"5851 Ingeniero Jiroz","inscription_date":"2018-12-06","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"105.0","terrain_surface":"162.0","parking_lot":0,"price":"2579.0"},{"id":2019829,"address":"125 Cruchaga Montt","inscription_date":"2018-05-07","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"146.0","terrain_surface":"136.0","parking_lot":0,"price":"2554.0"},{"id":2010087,"address":"5411 Islas Hebridas","inscription_date":"2018-08-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"129.0","terrain_surface":"162.0","parking_lot":0,"price":"4040.0"},{"id":2003976,"address":"498 Las Rejas Norte","inscription_date":"2018-02-28","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"126.0","terrain_surface":"199.0","parking_lot":0,"price":"3165.0"},{"id":1990372,"address":"633 Las Torres","inscription_date":"2018-07-24","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"103.0","terrain_surface":"170.0","parking_lot":0,"price":"2702.0"},{"id":1968867,"address":"6474 Lo Prado","inscription_date":"2018-05-10","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"144.0","terrain_surface":"190.0","parking_lot":0,"price":"1665.0"},{"id":1968673,"address":"155 Ministro Gana","inscription_date":"2018-05-07","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"145.0","terrain_surface":"162.0","parking_lot":0,"price":"1666.0"},{"id":1968366,"address":"6149 Santa Luisa","inscription_date":"2018-05-02","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"102.0","terrain_surface":"200.0","parking_lot":0,"price":"815.0"},{"id":1909958,"address":"5885 Eleusis","inscription_date":"2018-07-06","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"193.0","terrain_surface":"162.0","parking_lot":0,"price":"2686.0"},{"id":1904943,"address":"477 Los Ediles","inscription_date":"2018-06-21","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"129.0","terrain_surface":"162.0","parking_lot":0,"price":"737.0"},{"id":1902446,"address":"162 Juan Dee Fuca","inscription_date":"2018-03-22","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"127.0","terrain_surface":"184.0","parking_lot":0,"price":"2442.0"},{"id":1901418,"address":"5455 Islas De Man","inscription_date":"2018-03-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"114.0","terrain_surface":"162.0","parking_lot":0,"price":"705.0"},{"id":1887898,"address":"5937 Diego Aracena","inscription_date":"2018-04-10","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"111.0","terrain_surface":"162.0","parking_lot":0,"price":"3189.0"},{"id":20611,"address":"6135 Territorio Antartico","inscription_date":"2020-04-07","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"146.0","terrain_surface":"162.0","parking_lot":0,"price":"996.0"},{"id":20493,"address":"7030 Los Arrayanes","inscription_date":"2020-04-06","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"129.0","terrain_surface":"167.0","parking_lot":0,"price":"2741.0"},{"id":20264,"address":"879 Gabriela Mistral","inscription_date":"2020-04-02","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"152.0","terrain_surface":"176.0","parking_lot":0,"price":"2320.0"},{"id":19586,"address":"517 Pasaje Piura","inscription_date":"2020-03-23","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"112.0","terrain_surface":"170.0","parking_lot":0,"price":"1575.0"},{"id":16595,"address":"531 Puerto Williams","inscription_date":"2020-03-02","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"112.0","terrain_surface":"160.0","parking_lot":0,"price":"2814.0"},{"id":16173,"address":"572 La Quidora","inscription_date":"2020-02-14","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"125.0","terrain_surface":"162.0","parking_lot":0,"price":"1057.0"},{"id":15621,"address":"119 Little Rock","inscription_date":"2020-01-07","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"114.0","terrain_surface":"160.0","parking_lot":0,"price":"3011.0"}];
            console.log(table_data);

        },
        error: function (jqxhr, textstatus, errorthrown) {
            console.log("algo malo paso");
        }
    })
    update_table();
}

function update_filters() {
    $(parsed_data['property_types']).each(function () {
        $("#prop_type").append($('<option>').val($(this)[0]).text($(this)[0]));
    });
    $(parsed_data['seller_types']).each(function () {
        $("#seller_type").append($('<option>').val($(this)[0]).text($(this)[0]));
    });
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
            min: dateToTS(new Date(yearBegin, 10, 1)),
            max: dateToTS(new Date(yearTo, 11, 1)),
            from: dateToTS(new Date($(this['from']))),
            to: dateToTS(new Date($(this['to']))),
            prettify: tsToDate,
            onFinish: function (data) {
                dataInsc_date = {"from: ": (data.from_pretty), "to: ": (data.to_pretty)}
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
        $("#zone").ionRangeSlider({
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
    $(parsed_data['land_use']).each(function () {
        var from = parseFloat($(this)[0]['from']);
        var to = parseFloat($(this)[0]['to']);
        $("#surface").ionRangeSlider({
            type: "double",
            min: from,
            max: to,
            from: from,
            to: to,
            drag_interval: true,
            min_interval: null,
            max_interval: null,
            onFinish: function (data) {
                dataLand_use = {"from: ": (data.from), "to: ": (data.to)}
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
    });
    $("#intro").remove();
    $("#select-box").removeClass("d-none");
}

////////////////////////////////////////////////////////

Congo.flex_dashboards.action_index = function () {
    var map_admin, marker, flexMap;

    var init = function () {
        var streets = L.tileLayer('https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
            attribution: '',
            id: 'streets-v11',
            accessToken: 'pk.eyJ1IjoiZmxhdmlhYXJpYXMiLCJhIjoiY2ppY2NzMm55MTN6OTNsczZrcGFkNHpoOSJ9.cL-mifEoJa6szBQUGnLmrA',
            updateWhenIdle: true,
            reuseTiles: true
        });

        flexMap = L.map('map_flex', {
            fadeAnimation: true,
            markerZoomAnimation: false,
            zoom: 11,
            center: [-33.4372, -70.6506],
            zoomControl: false,
            zoomAnimation: true,
            layers: [streets]
        });

        fgr = L.featureGroup().addTo(flexMap);

        var drawControl = new L.Control.Draw({
            draw: {
                marker: false,
                polyline: false,
                rectangle: false,
                circlemarker: false,
            },
            edit: {
                featureGroup: fgr
            }
        }).addTo(flexMap);

        flexMap.on('draw:created', function (e) {
            size_box = [];
            fgr.eachLayer(function (layer) {
                fgr.removeLayer(layer);
            });

            fgr.addLayer(e.layer);
            layerType = e.layerType;

            if (layerType == 'polygon') {
                polygon = e.layer.getLatLngs();
                arr1 = []

                polygon.forEach(function (entry) {
                    arr1 = Congo.map_utils.LatLngsToCoords(entry)
                    arr1.push(arr1[0])
                    size_box = [arr1];
                })
            }
            data = {polygon: JSON.stringify(size_box)}

            $.ajax({
                async: false,
                type: 'get',
                url: 'flex/dashboards/search_data_for_filters.json',
                datatype: 'json',
                data: data,
                success: function (data) {

                    parsed_data = JSON.parse("{\"property_types\":[[\"Casas\",1],[\"Departamentos\",2],[\"Oficinas\",3],[\"Local Comercial\",4],[\"Oficina y Local Comercial\",5],[\"Equipamiento\",6],[\"Departamento y Local Comercial\",10]],\"inscription_dates\":{\"from\":\"2008-01-02\",\"to\":\"2020-12-03\"},\"seller_types\":[[\"PROPIETARIO\",1],[\"INMOBILIARIA\",2],[\"EMPRESA\",3],[\"BANCO\",4]],\"land_use\":{\"from\":0,\"to\":0.8},\"max_height\":{\"from\":0,\"to\":99},\"building_surfaces\":{\"from\":0,\"to\":699},\"terrain_surfaces\":{\"from\":0,\"to\":2071},\"prices\":{\"from\":60,\"to\":131681},\"unit_prices\":{\"from\":0,\"to\":741.17}}")

                    console.log('Data hacodeada');
                    console.log(parsed_data);

                },
                error: function (jqxhr, textstatus, errorthrown) {
                    console.log("algo malo paso");
                }
            })
            update_filters();
        })
    }
    return {
        init: init,
    }
}();

