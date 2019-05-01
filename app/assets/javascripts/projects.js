Congo.namespace('projects.action_dashboards');

Congo.projects.config= {
  county_name: '',
  county_id: '',
  layer_type: 'projects_info'
}

Congo.projects.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();  

  }

  indicator_projects = function(){

    $.ajax({
      type: 'GET',
      url: '/projects/projects_summary.json',
      datatype: 'json',
      data: {to_year:"2018", locale:"es", periods_quantity: "5", to_period: "6", county_id:"52" },
      success: function(data){
        console.log(data);
      }
    })
  }

  return {
    init: init,
    indicator_projects: indicator_projects
  }
}();

