$(document).on('click', '.add_fields', function (event) {
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).before($(this).data('fields').replace(regexp, time))
      event.preventDefault()
})

Congo.namespace('flex_flex_reports.action_new');

Congo.flex_flex_reports.config = {
  geo_selection: '',
  map: '',
  controls: ''
}

//filters
var table_data        = "";
var dataFromTable     = []; // variable que captura ids de la tabla
var dataForCharts     = { transactions: dataFromTable }; // variable para los charts
var userData          = [];
var dataInsc_date         = {};
var dataPrices            = {};
var dataUnit_prices       = {};
var dataTerrain_surfaces  = {};
var dataBuilding_surfaces = {};
var dataDensity           = {};
var dataMaxHeight         = {};
var filteredData      = {};

////////////////////////////////////////////////////////

Congo.flex_flex_reports.action_new = function () {
    let map_admin, marker, flexMap;

    let init = function () {
        let flexMap = create_map();
        let fgr     = L.featureGroup().addTo(flexMap);

        let controls = add_control(flexMap, fgr);

        Congo.flex_flex_reports.config.map = flexMap;
        Congo.flex_flex_reports.config.controls = controls;

        flexMap.on('draw:created', function (e) {
            let data = draw_geometry(e, fgr);

            Congo.flex_flex_reports.config.geo_selection = data

            if ('error' in data) {
                $('#alerts').append(data['error']);

                setTimeout(() => {
                    $('#alerts').empty();
                }, 5000)
            } else {
                flexMap.fitBounds(fgr.getBounds());

                geoserver_building_regulations(data, flexMap, fgr);
                geoserver_data(data, flexMap, fgr);

                $.ajax({
                    async: false,
                    type: 'get',
                    url: 'search_data_for_filters.json',
                    datatype: 'json',
                    data: data,
                    success: function (data) {
                        parsed_data = data

                        // Ejemplo
                        // parsed_data = JSON.parse('{\"property_types\":[[\"Casas\",1],[\"Departamentos\",2],[\"Oficinas\",3],[\"Local Comercial\",4],[\"Oficina y Local Comercial\",5]],\"inscription_dates\":{\"from\":\"2018-02-15\",\"to\":\"2020-12-30\"},\"seller_types\":[[\"PROPIETARIO\",1],[\"INMOBILIARIA\",2],[\"EMPRESA\",3],[\"BANCO\",4]],\"land_use\":[\"EA12\",\"EA12 pa\",\"EA7\",\"PzVec\",\"ZEP AE\",\"EC2+A8\",\"ZIM\"],\"max_height\":{\"from\":0,\"to\":99},\"density\":{\"from\":0,\"to\":1100},\"building_surfaces\":{\"from\":0,\"to\":520},\"terrain_surfaces\":{\"from\":0,\"to\":2147},\"prices\":{\"from\":64,\"to\":42900},\"unit_prices\":{\"from\":0,\"to\":2247}}');
                        // parsed_data = JSON.parse('{\"property_types\":[[\"Casas\",3],[\"Departamentos\",1]],\"inscription_dates\":{\"from\":\"2020-02-15\",\"to\":\"2020-12-25\"},\"seller_types\":[[\"PROPIETARIO\",1],[\"BANCO\",4]],\"land_use\":[\"EA12 pa\",\"EA7\",\"ZIM\"],\"max_height\":{\"from\":0,\"to\":99},\"density\":{\"from\":0,\"to\":1100},\"building_surfaces\":{\"from\":0,\"to\":220},\"terrain_surfaces\":{\"from\":0,\"to\":3147},\"prices\":{\"from\":64,\"to\":5000},\"unit_prices\":{\"from\":0,\"to\":1147}}');

                        console.log('Datos filtros h');
                        console.log(parsed_data);
                        update_filters();
                    },
                    error: function (jqxhr, textstatus, errorthrown) {
                        console.log("algo malo paso");
                    }
                });
            }
        });
    }
    return {
        init: init,
    }
}();
