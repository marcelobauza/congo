function update_filters() {
    //parsed_data = data;
    $(".multiselect-native-select option").remove()

    $('tr.genTable').remove();
    $(".chartjs-render-monitor").removeAttr('class').removeAttr('style').removeAttr('width').removeAttr('height');

    //$("#prop_type").empty()

    $(parsed_data['property_types']).each(function () {
        $("#prop_type").append($('<option>').val($(this)[1]).text($(this)[0]));
    });

    $(parsed_data['seller_types']).each(function () {
        $("#seller_type").append($('<option>').val($(this)[1]).text($(this)[0]));
    });

    for (i = 0; i < $(parsed_data['building_regulation']).length; i++) {
        $("#land_use").append($('<option>').val("'" + $(parsed_data['building_regulation'])[i] + "'").text($(parsed_data['building_regulation'])[i]));
    }
    $(parsed_data['inscription_dates']).each(function () {
        var lang      = "es-ES";
        var yearBegin = parseInt($(parsed_data['inscription_dates'])[0]['from'].split("-")[0]);
        var yearTo    = parseInt($(parsed_data['inscription_dates'])[0]['to'].split("-")[0]);

        inscriptionDate = parsed_data['inscription_dates']

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
               var fromDate = data.from_pretty.split('/');
               var inscriptionFromDate =  new Date(fromDate[2], fromDate[1] - 1, fromDate[0])

               var toDate = data.to_pretty.split('/');
               var inscriptionToDate =  new Date(toDate[2], toDate[1] - 1, toDate[0])

                dataInsc_date = {"from": (data.from_pretty), "to": (data.to_pretty)}
                inscriptionDate = {"from": (inscriptionFromDate).toDateString(), "to": (inscriptionToDate).toDateString()}
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
    $(document).ready(function () {
        $('#prop_type').multiselect({
          maxHeight: 500,
          buttonClass: 'form-control form-control-sm',
          // buttonWidth: '100px',
          nonSelectedText: 'Seleccionar',
          allSelectedText: 'Todos',
          numberDisplayed: 1,
          nSelectedText: 'tipos',
          includeFilterClearBtn: false,
          includeSelectAllOption: true,
          selectAllText: 'Todos',
        });
        $('#seller_type').multiselect({
          maxHeight: 500,
          buttonClass: 'form-control form-control-sm',
          // buttonWidth: '100px',
          nonSelectedText: 'Seleccionar',
          allSelectedText: 'Todos',
          numberDisplayed: 1,
          nSelectedText: 'tipos',
          includeFilterClearBtn: false,
          includeSelectAllOption: true,
          selectAllText: 'Todos',
        });
        $('#land_use').multiselect({
          maxHeight: 500,
          buttonClass: 'form-control form-control-sm',
          // buttonWidth: '100px',
          nonSelectedText: 'Seleccionar',
          allSelectedText: 'Todos',
          numberDisplayed: 1,
          nSelectedText: 'tipos',
          includeFilterClearBtn: false,
          includeSelectAllOption: true,
          selectAllText: 'Todos',
        });
    });
    $("#intro").remove();
    $("#select-box").removeClass("d-none");
    //$("#map_flex").css('height', '100%');
}
