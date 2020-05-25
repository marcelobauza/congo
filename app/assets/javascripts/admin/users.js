Congo.namespace('admin_users.action_new');
Congo.namespace('admin_users.action_edit');

Congo.admin_users.action_new = function(){

  init = function(){
    Congo.admin_users.action_edit.init()
  }
  return {
    init: init
  }
}();

Congo.admin_users.action_edit = function(){
  init = function(){
    $('#user_region_ids').on('change',function(){
      ids = $(this).val()
      data = {ids: ids}
      $.ajax({
        type: 'GET',
        url: '/regions/search_regions.json',
        datatype: 'json',
        data: data,
        success: function(data) {
          var sel = $('#user_county_ids')
          for (var i = 0, len = sel[0].length; i < len; i++) {
            if (data.includes(parseInt(sel[0].options[i].value))){
              sel[0].options[i].selected = true
            }else{
              sel[0].options[i].selected = false
            }
          }
        }
      }
      )
    })
  }
  return {
    init: init
  }
}();
