Congo.namespace('dashboards.action_index');

Congo.dashboards.config= {
  county_name: '',
  county_id: '',
  layer_type: 'transactions_info'
}

Congo.dashboards.action_index = function(){
  init= function(){
    Congo.map_utils.init();  
  }

  /*  indicators = function(){

    $.ajax({
      type: 'GET',
      url: '/transactions/transactions_summary.json',
      datatype: 'json',
      data: {to_year:"2018", locale:"es", periods_quantity: "5", to_period: "6", county_id:"52" },
      success: function(data){
        console.log(data);
      }
    })
  }
*/
  return {
    init: init,
  //  indicators: indicators
  }
}();
