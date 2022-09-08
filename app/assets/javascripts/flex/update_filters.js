function update_filters() {

  String.prototype.toSentenceCase = function() {
    return this.charAt(0).toUpperCase() + this.slice(1).toLowerCase();
  };

    $(".multiselect-native-select option").remove()
    $('tr.genTable').remove();
    $(".chartjs-render-monitor").removeAttr('class').removeAttr('style').removeAttr('width').removeAttr('height');

    // Tipo Propiedad
    $("#prop_type").empty()
    $(parsed_data['property_types']).each(function() {
      $("#prop_type").append(
        $('<div>', {
          'class': 'custom-control custom-switch col-6 text-left pr-1'
        }).append(
          $('<input>', {
            'class': 'custom-control-input',
            'type': 'checkbox',
            'id': 'prop_check_' + $(this)[1],
            'name': 'prop_type_chk',
            'value': $(this)[1],
            'checked': 'checked'
          }),
          $('<label>', {
            'class': 'custom-control-label custom-flex-colour',
            'for': 'prop_check_' + $(this)[1],
            'text': $(this)[0].toSentenceCase()
          })
        )
      )
    });

    // Tipo Vendedor
    $("#seller_type").empty()
    $(parsed_data['seller_types']).each(function() {
      $("#seller_type").append(
        $('<div>', {
          'class': 'custom-control custom-switch col-6 text-left pr-1'
        }).append(
          $('<input>', {
            'class': 'custom-control-input',
            'type': 'checkbox',
            'id': 'seller_check_' + $(this)[1],
            'name': 'seller_type_chk',
            'value': $(this)[1],
            'checked': 'checked'
          }),
          $('<label>', {
            'class': 'custom-control-label custom-flex-colour',
            'for': 'seller_check_' + $(this)[1],
            'text': $(this)[0].toSentenceCase()
          })
        )
      )
    });

    // Normativa
    for (i = 0; i < $(parsed_data['building_regulation']).length; i++) {
        $("#land_use").append($('<option>').val($(parsed_data['building_regulation'])[i]).text($(parsed_data['building_regulation'])[i]));
    }

    // Rango Fechas Inscripciones
    $(parsed_data['inscription_dates']).each(function() {

      inscriptionDate = parsed_data['inscription_dates']

      var from = dateToTS(new Date($(this)[0]['from']));
      var to = dateToTS(new Date($(this)[0]['to']));
      var lang = "es-ES";

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

      // Si ya existe, se elimina
      if (insc_date_range) {
        insc_date_range.destroy()
      }

      $("#insc_date").ionRangeSlider({
        skin: "flat",
        type: "double",
        grid: false,
        min: from,
        max: to,
        from: from,
        to: to,
        prettify: tsToDate,
        onStart: function(data) {
          var fromDate = data.min_pretty.split('/');
          var inscriptionFromDate = new Date(fromDate[2], fromDate[1] - 1, fromDate[0])
          var toDate = data.max_pretty.split('/');
          var inscriptionToDate = new Date(toDate[2], toDate[1] - 1, toDate[0])
          // Fecha para filtrar la tabla
          dataInsc_date = {
            "from": (data.min_pretty),
            "to": (data.max_pretty)
          }
          // Fecha para cqlfilter
          inscriptionDate = {
            "from": (inscriptionFromDate).toDateString(),
            "to": (inscriptionToDate).toDateString()
          }
        },
        onFinish: function(data) {
          var fromDate = data.from_pretty.split('/');
          var inscriptionFromDate = new Date(fromDate[2], fromDate[1] - 1, fromDate[0])
          var toDate = data.to_pretty.split('/');
          var inscriptionToDate = new Date(toDate[2], toDate[1] - 1, toDate[0])
          // Fecha para filtrar la tabla
          dataInsc_date = {
            "from": (data.from_pretty),
            "to": (data.to_pretty)
          }
          // Fecha para cqlfilter
          inscriptionDate = {
            "from": (inscriptionFromDate).toDateString(),
            "to": (inscriptionToDate).toDateString()
          }
        }
      });

      insc_date_range = $("#insc_date").data("ionRangeSlider");

      insc_date_range.update({
        min: from,
        max: to,
        from: from,
        to: to,
      });

    });

    // Superficie Útil
    $("#from_bs").val('');
    $("#to_bs").val('');
    $(parsed_data['building_surfaces']).each(function() {
      var from = parseFloat($(this)[0]['from']);
      var to = parseFloat($(this)[0]['to']);
      $('#from_bs').attr('placeholder', from)
      $('#to_bs').attr('placeholder', to)
    });

    // Superficie Terreno
    $('#from_ts').val('');
    $('#to_ts').val('');
    $(parsed_data['terrain_surfaces']).each(function() {
      var from = parseFloat($(this)[0]['from']);
      var to = parseFloat($(this)[0]['to']);
      $('#from_ts').attr('placeholder', from)
      $('#to_ts').attr('placeholder', to)
    });

    // Precio UF
    $('#from_p').val('');
    $('#to_p').val('');
    $(parsed_data['prices']).each(function() {
      var from = parseFloat($(this)[0]['from']);
      var to = parseFloat($(this)[0]['to']);
      $('#from_p').attr('placeholder', from)
      $('#to_p').attr('placeholder', to)
    });

    // Precio UFm2
    $('#from_up').val('');
    $('#to_up').val('');
    $(parsed_data['unit_prices']).each(function() {
      var from = parseFloat($(this)[0]['from']);
      var to = parseFloat($(this)[0]['to']);
      $('#from_up').attr('placeholder', from)
      $('#to_up').attr('placeholder', to)
    });

    $(document).ready(function () {
        $('#land_use').multiselect({
          maxHeight: 500,
          buttonClass: 'form-control form-control-sm',
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

  $("[data-building-regulations-pdf]").empty()
  $.each(parsed_data['county_codes'], function(code, name){
    $('[data-building-regulations-pdf]').append(
      $('<a>', {
        'class': 'btn btn-primary btn-sm text-center',
        'href': 'building_regulation_download?county_id=' + code,
        'role': 'button',
        'text': 'PRC/' + name
      })
    )
  })
}
