Congo.namespace('building_regulations.action_dashboards');

Congo.building_regulations.config= {
  county_name: '',
  county_id: '',
  layer_type: 'building_regulations_info',
  from_construct: '',
  to_construct: '',
  from_land_ocupation: '',
  to_land_ocupation: '',
  allowed_use_ids: []
}

Congo.building_regulations.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();

  }

  indicator_building_regulations = function(){

    county_id = Congo.dashboards.config.county_id;
    radius = Congo.map_utils.radius * 1000;
    centerPoint = Congo.map_utils.centerpt;
    wkt = Congo.map_utils.size_box;
    from_construct = Congo.building_regulations.config.from_construct;
    to_construct = Congo.building_regulations.config.to_construct;
    from_land_ocupation = Congo.building_regulations.config.from_land_ocupation;
    to_land_ocupation = Congo.building_regulations.config.to_land_ocupation;
    allowed_use_ids = Congo.building_regulations.config.allowed_use_ids;

    if (county_id != '') {
      data = {
        from_construct: from_construct,
        to_construct: to_construct,
        from_land_ocupation: from_land_ocupation,
        to_land_ocupation: to_land_ocupation,
        allowed_use_ids: allowed_use_ids,
        county_id: county_id
      };
    } else if (centerPoint != '') {
      data = {
        from_construct: from_construct,
        to_construct: to_construct,
        from_land_ocupation: from_land_ocupation,
        to_land_ocupation: to_land_ocupation,
        allowed_use_ids: allowed_use_ids,
        centerpt: centerPoint,
        radius: radius
      };
    } else {
      data = {
        from_construct: from_construct,
        to_construct: to_construct,
        from_land_ocupation: from_land_ocupation,
        to_land_ocupation: to_land_ocupation,
        allowed_use_ids: allowed_use_ids,
        wkt: wkt
      };
    };

    $.ajax({
      type: 'GET',
      url: '/building_regulations/building_regulations_filters.json',
      datatype: 'json',
      data: data,
      beforeSend: function() {
        // Mostramos el spinner
        $("#spinner").show();

        // Establece el nombre de la capa en el navbar
        $('#layer-name').text('Normativa');

        // Eliminamos los chart-containter de la capa anterior
        $(".chart-container").remove();

        // Eliminamos los filtros de la capa anterior
        $('.filter-future-projects').remove();
        $('.filter-transactions').remove();
        $('.filter-projects').remove();
      },
      success: function(data){

        // Ocultamos el spinner
        $("#spinner").hide();

        // Comprobamos si el overlay no está creado y adjuntado
        if ($('.overlay').length == 0) {

          // Creamos y adjuntamos el overlay
          var overlay = document.createElement('div');
          overlay.className = 'overlay';
          $('#map').before(overlay);

        };

        // Creamos el div contenedor
        var chart_container = document.createElement('div');
        chart_container.className = 'chart-container card';
        chart_container.id = 'chart-container';

        // Creamos el card-header
        var card_header = document.createElement('div');
        card_header.className = 'card-header';
        card_header.id = 'header';

        // Creamos el collapse
        var collapse = document.createElement('div');
        collapse.className = 'collapse show';
        collapse.id = 'collapse';

        // Creamos el card-body
        var card_body = document.createElement('div');
        card_body.className = 'card-body';
        card_body.id = 'body';

        // TODO: Crear título y boton minimizar dinámicos

        // Creamos título y boton minimizar
        var card_header_button = '<button type="button" class="close" data-toggle="collapse" data-target="#collapse" aria-expanded="true" aria-controls="collapse" aria-label="Minimize"><i class="fas fa-window-minimize"></i></button>'
        var card_header_title = '<b>Filtrar Información por:</b>'

        // Adjuntamos los elementos
        $('.overlay').append(chart_container);
        $('#chart-container').append(card_header, collapse);
        $('#collapse').append(card_body);
        $('#header').append(card_header_button, card_header_title);

      }
    })

  }
  return {
    init: init,
    indicator_building_regulations: indicator_building_regulations
  }
}();
