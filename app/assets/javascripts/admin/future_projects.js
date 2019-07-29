Congo.namespace('admin_future_projects.action_index');
Congo.namespace('admin_future_projects.action_new');

Congo.admin_future_projects.action_index = function(){

  init = function(){
  }
  return {
    init: init,
  }
}();

Congo.admin_future_projects.action_new = function(){
  init = function(){
    Congo.admin_map_utils.init();
  }
  return {
    init: init,
  }
}();
