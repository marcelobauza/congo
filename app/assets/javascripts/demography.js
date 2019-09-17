Congo.namespace('demography.action_dashboards');

Congo.demography.action_dashboards = function(){
  init=function(){
    Congo.map_utils.init();
  }

  indicator_demography = function(){
  
    county_id = [];
    $.each(Congo.dashboards.config.county_id, function(a,b){
       county_id =b;
    })

    radius = Congo.dashboards.config.radius;
    centerPoint = Congo.dashboards.config.centerpt;
    wkt = Congo.dashboards.config.size_box;
    type_geometry = Congo.dashboards.config.typeGeometry;
    layer_type = Congo.dashboards.config.layer_type;
    style_layer = Congo.dashboards.config.style_layer;

      if (county_id != '') {

        // Agregamos filtro Comuna
        Congo.dashboards.action_index.add_county_filter_item()

        data = {
          county_id: county_id,
          type_geometry:type_geometry,
          layer_type: layer_type,
          style_layer: style_layer
        };
      }

      $.ajax({
        type: 'GET',
        url: '/demography/general.json',
        datatype: 'json',
        data: data,
        beforeSend: function() {

          // Mostramos el spinner y deshabilitamos los botones
          $("#spinner").show();
          $('.btn').addClass('disabled')
          $('.close').prop('disabled', true);
          $("#time_slider").data("ionRangeSlider").update({
            block: true
          });

          // Establece el nombre de la capa en el navbar
          $('#layer-name').text('Expedientes Municipales');

          // Mostramos el icono de Puntos Proporcionales correspondiente
          $("#prop-prv").hide();
          $("#prop-cbr").hide();
          $("#prop-em").show();

          // Mostramos el icono de Heatmap correspondiente
          $("#heat-prv").hide();
          $("#heat-cbr").hide();
          $("#heat-em-norm-dem").show();

          // Eliminamos los chart-containter de la capa anterior
          $(".chart-container").remove();

          // Mostramos el filtro de la capa y ocultamos los demás
          $('.filter-building-regulations').hide();
          $('.filter-transactions').hide();
          $('.filter-projects').hide();
          $('.filter-future-projects').show();

        },
        success: function(data) {
              console.log(data);
        }
      });



  }
  return {
    init: init,
    indicator_demography: indicator_demography
  }
}();
