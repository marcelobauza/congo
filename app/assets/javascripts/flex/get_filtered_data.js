function getFilteredData() {

    land_useType = $("#land_use").val();

    // Tipo Propiedad
    checkboxes = $('input[name="prop_type_chk"]')
    propertyTypes = [];
    checkboxes.each(function(i){
      if ($(this).is(':checked')) {
        propertyTypes.push($(this).val());
      }
    })

    // Tipo Vendedor
    checkboxes = $('input[name="seller_type_chk"]')
    sellerTypes = [];
    checkboxes.each(function(i){
      if ($(this).is(':checked')) {
        sellerTypes.push($(this).val());
      }
    })

    // Superficie Útil
    from_bs = $("#from_bs").val()
    if (from_bs == '') {
      from_bs = $("#from_bs").attr('placeholder')
    }
    to_bs = $("#to_bs").val()
    if (to_bs == '') {
      to_bs = $("#to_bs").attr('placeholder')
    }
    dataBuilding_surfaces = {
      "from": from_bs,
      "to": to_bs
    }

    // Superficie Terreno
    from_ts = $("#from_ts").val()
    if (from_ts == '') {
      from_ts = $("#from_ts").attr('placeholder')
    }
    to_ts = $("#to_ts").val()
    if (to_ts == '') {
      to_ts = $("#to_ts").attr('placeholder')
    }
    dataTerrain_surfaces = {
      "from": from_ts,
      "to": to_ts
    }

    // Precio UF
    from_p = $("#from_p").val()
    if (from_p == '') {
      from_p = $("#from_p").attr('placeholder')
    }
    to_p = $("#to_p").val()
    if (to_p == '') {
      to_p = $("#to_p").attr('placeholder')
    }
    dataPrices = {
      "from": from_p,
      "to": to_p
    }

    // Precio UFm2
    from_up = $("#from_up").val()
    if (from_up == '') {
      from_up = $("#from_up").attr('placeholder')
    }
    to_up = $("#to_up").val()
    if (to_up == '') {
      to_up = $("#to_up").attr('placeholder')
    }
    dataUnit_prices = {
      "from": from_up,
      "to": to_up
    }

    geom = Congo.flex_flex_reports.config.geo_selection

    data = {
        geom: geom,
        property_types: propertyTypes,
        seller_types: sellerTypes,
        inscription_dates: dataInsc_date,
        max_height: dataMaxHeight,
        density_types: dataDensity,
        land_use: land_useType,
        building_surfaces: dataBuilding_surfaces,
        terrain_surfaces: dataTerrain_surfaces,
        prices: dataPrices,
        unit_prices: dataUnit_prices
    }

    console.log('PARAMS search_data_for_table');
    console.log(data);

    $.ajax({
        async: false,
        type: 'get',
        url: 'search_data_for_table.json',
        datatype: 'json',
        data: data,
        success: function (data) {

          console.log('RESPONSE search_data_for_table');
          console.log(data);

            table_data = data

        },
        error: function (jqxhr, textstatus, errorthrown) {
            console.log("algo malo paso");
        }
    })
    update_table();
}
