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

                geoserver_data(data, flexMap, fgr);

                $.ajax({
                    async: false,
                    type: 'get',
                    url: 'search_data_for_filters.json',
                    datatype: 'json',
                    data: data,
                    success: function (data) {
                      update_filters(data);
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
