Congo.namespace('building_regulations.action_dashboards');

Congo.building_regulations.config= {
  county_name: '',
  county_id: '',
  layer_type: 'building_regulations_info'
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
    
    if (county_id != '') {
      data = {
        county_id: county_id
      };
    } else if (centerPoint != '') {
      data = {
        centerpt: centerPoint,
        radius: radius
      };
    } else {
      data = {
        wkt: wkt
      };
    };

    $.ajax({
      type: 'GET',
      url: '/building_regulations/building_regulations_filters.json',
      datatype: 'json',
      data: data,
      success: function(data){
      console.log(data);


      }
    })

  }
  return {
    init: init,
    indicator_building_regulations: indicator_building_regulations
  }
}();
