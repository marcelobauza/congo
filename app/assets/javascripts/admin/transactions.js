Congo.namespace('admin_transactions.action_index');
Congo.namespace('admin_transactions.action_new');
Congo.namespace('admin_transactions.action_edit');

Congo.admin_transactions.action_index = function(){

  init = function(){
  }
  return {
    init: init,
  }
}();

Congo.admin_transactions.action_new = function(){
  init = function(){
    Congo.admin_map_utils.init();
  }
  return {
    init: init,
  }
}();

Congo.admin_transactions.action_edit = function(){
  init = function(){
    Congo.admin_map_utils.init();
  }
  return {
    init: init,
  }
}();
