Congo.namespace('rent_indicators.action_dashboards');

Congo.rent_indicators.action_dashboards = function() {

  console.log("rent_i");

  init = function() {
    Congo.map_utils.init();
  }

  indicators = function() {
    console.log("indicators");
  }

  return {
    init: init,
    indicators: indicators
  }
}();
