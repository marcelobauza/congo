function getFilteredData() {

    propertyTypes = $("#prop_type").val();
    sellerTypes = $("#seller_type").val();
    land_useType = $("#land_use").val();

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
