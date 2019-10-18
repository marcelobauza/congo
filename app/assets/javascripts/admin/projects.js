$(document).ready(function(){
  $('#polygons').css('display', 'none');
  $('#counties').css('display', 'none');

  $('#kpi_type').on('click',function(){

    if( $('#kpi_type').val() == 1 )
    {
      $('#polygons').css('display', 'block');
      $('#counties').css('display', 'none');
    }else
    {
      $('#polygons').css('display', 'none');
      $('#counties').css('display', 'block');
    }

  });

})
