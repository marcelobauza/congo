$(document).ready(function(){
  $('.search_county_id').attr('hidden', true)
  $('.search_polygon_id').attr('hidden', true)

  $('#search_kpi_type').on('change', function(){
    var type = $(this).val();
    $('.search_county_id').attr('hidden', true)
    $('.search_polygon_id').attr('hidden', true)

    if (type == '1'){
      $('.search_polygon_id').removeAttr('hidden')
    }
    if (type =='2'){
      $('.search_county_id').removeAttr('hidden')
    }
  })
})
