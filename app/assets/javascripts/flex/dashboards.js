$(document).on('click', '.add_fields', function(event) {
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('#up_table').after($(this).data('fields').replace(regexp, time))
  event.preventDefault()
})

$(document).on('click', '.r_ten', function(event) {
  $(this).closest('div.line').remove()
  event.preventDefault();
});

$(document).on('click', '[data-flex-filter]', function(event) {
  let data              = Congo.flex_flex_reports.config.geo_selection;
  let flexMap           = Congo.flex_flex_reports.config.map;
  let fgr               = Congo.flex_flex_reports.config.fgr;
  let transaction_layer = Congo.flex_flex_reports.config.transactions_layer;

  fgr.removeLayer(transaction_layer)
  geoserver_data(data, flexMap, fgr);
})

$(document).on('click', '.flex_arrow', function(e) {

  closed_map = $('.flex_arrow').hasClass('closed_map');
  closed_table = $('#flex_table_arrow').hasClass('closed_table');

  if (closed_map) {
    $(".mh-1248").css("height", "calc(100vh - 40vh - 169px)");
    $(".map-box").removeClass('d-none')
    $('.flex_arrow').removeClass('closed_map');
  } else if (closed_table) {
    $("#map_flex").css("height", "40vh");
    $(".table-box").removeClass('d-none')
    $('.flex_arrow').removeClass('closed_table');
  } else {
    arrow = e.target.id
    if (arrow == 'flex_map_arrow') {
      $(".mh-1248").css("height", "calc(100vh - 122px)");
      $(".map-box").addClass('d-none')
      $('.flex_arrow').addClass('closed_map');
    } else {
      $("#map_flex").css("height", "calc(100vh - 122px)");
      $(".table-box").addClass('d-none')
      $('.flex_arrow').addClass('closed_table');

      let map = Congo.flex_flex_reports.config.map;

      map.invalidateSize()
    }
  }
});

Congo.namespace('flex_flex_reports.action_new');
Congo.flex_flex_reports.config = {
  geo_selection: '',
  map: '',
  controls: '',
  fgr: '',
  transactions_layer: ''
}

var table_data            = "";
var dataFromTable         = []; // variable que captura ids de la tabla
var dataForCharts         = { transactions: dataFromTable }; // variable para los charts
var userData              = [];
var dataInsc_date         = {};
var dataPrices            = {};
var dataUnit_prices       = {};
var dataTerrain_surfaces  = {};
var dataBuilding_surfaces = {};
var dataDensity           = {};
var dataMaxHeight         = {};
var filteredData          = {};
var inscriptionDate       = {};
let insc_date_range

////////////////////////////////////////////////////////

Congo.flex_flex_reports.action_new = function () {
    let map_admin, marker, flexMap;

    let init = function () {
        let flexMap  = create_map();
        let fgr      = L.featureGroup().addTo(flexMap);
        let controls = add_control(flexMap, fgr);

        Congo.flex_flex_reports.config.map      = flexMap;
        Congo.flex_flex_reports.config.controls = controls;
        Congo.flex_flex_reports.config.fgr      = fgr;

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
