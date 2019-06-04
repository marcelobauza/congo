Congo.namespace("reports");

Congo.reports = function(){

    layer_type = Congo.dashboards.config.layer_type

    switch (layer_type) {
      case 'future_projects_info':
    county_id = Congo.dashboards.config.county_id;
    to_year = Congo.dashboards.config.year;
    to_bimester = Congo.dashboards.config.bimester;
    radius = Congo.map_utils.radius * 1000;
    centerPoint = Congo.map_utils.centerpt;
    wkt = Congo.map_utils.size_box;

    if (county_id != ''){
      data ={to_year: to_year, to_period: to_bimester, county_id: county_id};
    }else if(centerPoint !=''){
      data = {to_year: to_year, to_period: to_bimester, centerpt: centerPoint, radius: radius};
    }else{
      data = {to_year: to_year, to_period: to_bimester, wkt: wkt};
    }

let url = '/reports/future_projects_data.xlsx';

/*    $.ajax({
      async: true,
      type: 'GET',
      url: url,
      datatype: 'xlsx',
      data: {county_id:"52" },
      success: function(data){
        //var blob = new Blob([data], { type: 'data:application/vnd.ms-excel' });
        console.log(data);
//    window.location = url;yy
      } });*/
    window.location = url;
        break;
      
      default:
        
    }
}
