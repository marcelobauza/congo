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
                month: 'numeric',
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
                dataInsc_date = {"from": (data.from_pretty), "to": (data.to_pretty)}
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
                dataMaxHeight = {"from": (data.from), "to": (data.to)}
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
                dataPrices = {"from": (data.from), "to": (data.to)}
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
                dataUnit_prices = {"from": (data.from), "to": (data.to)}
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
                dataTerrain_surfaces = {"from": (data.from), "to": (data.to)}
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
                dataBuilding_surfaces = {"from": (data.from), "to": (data.to)}
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
                dataDensity = {"from": (data.from), "to": (data.to)}
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
    //$("#map_flex").css('height', '100%');
}