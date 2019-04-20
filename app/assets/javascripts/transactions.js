Congo.namespace('transactions.action_dashboards');

Congo.transactions.config= {
  county_name: '',
  county_id: '',
  layer_type: 'transactions_info'
}

Congo.transactions.action_dashboards = function(){

  init=function(){

    Congo.map_utils.init();  

  }

  indicator_transactions = function(){

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

  return {
    init: init,
    indicator_transactions: indicator_transactions
  }
}();

