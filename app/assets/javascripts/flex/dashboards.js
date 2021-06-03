Congo.namespace('flex_dashboards.action_index');

//filters
var parsed_data = ""
dataInsc_date = {}; dataPrices = {}; dataUnit_prices = {}; dataTerrain_surfaces = {}; dataBuilding_surfaces = {}; dataLand_use = {};

var filteredData = {} ;

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

