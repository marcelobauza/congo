Congo.namespace('admin_projects.action_new');
Congo.namespace('admin_projects.action_create');
Congo.namespace('admin_projects.action_edit');
Congo.admin_projects.config = {
'latitude': [],
'longitude': []

}

$(document).ready(function(){
  $('#polygons').css('display', 'none');
  $('#counties').css('display', 'none');

  $('#kpi_type').on('click',function(){

    if( $('#kpi_type').val() == 1 )
    {
      $('#polygons').css('display', 'block');
      $('#counties').css('display', 'none');
    }else
    {
      $('#polygons').css('display', 'none');
      $('#counties').css('display', 'block');
    }
  });
})

Congo.admin_projects.action_create = function(){
  init = function(){
    Congo.admin_projects.action_new.init();
  }
  return {
    init: init,
  }
}();

  Congo.admin_projects.action_new = function(){

  init = function(){
    Congo.admin_map_utils.init();
    $('#search_address').on('click', function(){
    county= $("#project_county_id").children("option:selected").text();
    address = $('#project_address').val(); 
    complete_address = address + " " + county +" Chile";
    Congo.admin_map_utils.geocoding(complete_address);
    })
  }
  return {
    init: init,
  }
}();
Congo.admin_projects.action_edit = function(){

  init = function(){
    Congo.admin_map_utils.init();
    latitude= Congo.admin_projects.config.latitude[0];
    longitude= Congo.admin_projects.config.longitude[0];
    Congo.admin_map_utils.addMarker(latitude, longitude, 'projects');
  }
  return {
    init: init,
  }
}();
