Congo.namespace('future_projects.action_dashboards');

Congo.future_projects.config= {
  county_name: '',
  county_id: '',
  layer_type: 'future_projects_info'
}

Congo.future_projects.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();  

  }

  indicator_future_projects = function(){

    $.ajax({
      type: 'GET',
      url: '/future_projects/future_projects_summary.json',
      datatype: 'json',
      data: {to_year:"2018", locale:"es", periods_quantity: "5", to_period: "6", county_id:"52" },
      success: function(data){
        console.log(data);
      }
    })
  }

  return {
    init: init,
    indicator_future_projects: indicator_future_projects
  }
}();

