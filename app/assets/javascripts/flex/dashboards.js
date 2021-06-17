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

                        parsed_data = data;

                        // Ejemplo
                        // parsed_data = JSON.parse('{\"property_types\":[[\"Casas\",1],[\"Departamentos\",2],[\"Oficinas\",3],[\"Local Comercial\",4],[\"Oficina y Local Comercial\",5]],\"inscription_dates\":{\"from\":\"2018-02-15\",\"to\":\"2020-12-30\"},\"seller_types\":[[\"PROPIETARIO\",1],[\"INMOBILIARIA\",2],[\"EMPRESA\",3],[\"BANCO\",4]],\"land_use\":[\"EA12\",\"EA12 pa\",\"EA7\",\"PzVec\",\"ZEP AE\",\"EC2+A8\",\"ZIM\"],\"max_height\":{\"from\":0,\"to\":99},\"density\":{\"from\":0,\"to\":1100},\"building_surfaces\":{\"from\":0,\"to\":520},\"terrain_surfaces\":{\"from\":0,\"to\":2147},\"prices\":{\"from\":64,\"to\":42900},\"unit_prices\":{\"from\":0,\"to\":2247}}');

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
