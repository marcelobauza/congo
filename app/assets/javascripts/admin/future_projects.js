Congo.namespace('admin_future_projects.action_index');
Congo.namespace('admin_future_projects.action_new');
Congo.namespace('admin_future_projects.action_edit');
Congo.namespace('admin_future_projects.action_update');

Congo.admin_future_projects.action_index = function(){

  init = function(){
  }
  return {
    init: init,
  }
}();

Congo.admin_future_projects.action_new = function(){
  init = function(){
 Congo.admin_future_projects.action_edit.init();
  }
  return {
    init: init,
  }
}();

Congo.admin_future_projects.action_edit = function(){
  init = function(){
    Congo.admin_map_utils.init();
  }
  return {
    init: init,
  }
}();

Congo.admin_future_projects.action_update = function(){
  init = function(){
 Congo.admin_future_projects.action_edit.init();
  }
  return {
    init: init,
  }
}();
