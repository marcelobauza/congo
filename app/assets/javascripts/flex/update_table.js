$(document).on('change', '[data-sel-box]', function(){

  values = rowsCheckTable()

  $('[data-flex-transactions-ids]').val(values)
})

function rowsCheckTable() {
  var values = []

  $("[data-sel-box]").each(function() {
    if ($(this).is(":checked")) {
      values.push($(this).val())
    }
  });

  return values
}


function clearTable() {
  $('tr.genTable').remove();
}

function update_table() {
  clearTable();

  $("#sel-box").css('display', 'block');
  $("#sel-box").on('click', function() {

    if($(this).is(':checked')) {
      $("#table .form-check-input").each(function() {
        $(this).prop('checked', true);
        $(".input-checkbox .form-check-input").closest('td').css('background','#45feed');
      });
    } else {
      $("#table .form-check-input").each(function() {
        $(this).prop('checked', false);
        $(".input-checkbox .form-check-input").closest('td').css('background','#ed36be');
      });
    }
  });

  $(table_data).each(function (index) {
    $('#table tr:last').after(
      '<tr class="genTable">' +
      '<td class="for-order input-checkbox"><input class="form-check-input" data-sel-box type="checkbox" value="' + ($(this)[0]['id']) + '" checked></td>' +
      '<td class="for-order">' + ($(this)[0]["property_typee"]) + '</td>' +
      '<td class="for-order">' + ($(this)[0]["address"]) + '</td>' +
      '<td class="for-order">' + ($(this)[0]['seller']) + '</td>' +
      '<td class="for-order">' + ($(this)[0]['price']) + '</td>' +
      '</tr>'
    );
  });

  $("#cantidad-registros-tabla").text('Registros: ' + $(table_data).length)
  // sort table

  if ($(table_data).length > 0) {
    $('[data-generate]').removeClass('d-none');
  }

  var table = $('table');

  $('#uf_sort')
    .wrapInner('<span title="ordenar esta columna"/>')
    .each(function() {
      var th      = $(this),
        thIndex   = th.index(),
        inverse   = false;
      th.click(function() {
        table.find('td.for-order').filter(function() {
          return $(this).index() === thIndex;
        }).sortElements(function(a, b) {
          if( +$.text([a]) == +$.text([b]) )
            return 0;
          return +$.text([a]) > +$.text([b]) ?
            inverse ? -1 : 1
            : inverse ? 1 : -1;
        }, function(){
          // parentNode is the element we want to move
          return this.parentNode;
        });

        inverse = !inverse;
      });
    });

  $('#address_sort')
    .wrapInner('<span title="ordenar esta columna"/>')
    .each(function() {
      var th    = $(this),
        thIndex = th.index(),
        inverse = false;

      th.click(function(){

        table.find('td.for-order').filter(function(){
          return $(this).index() === thIndex;
        }).sortElements(function(a, b) {

          if( $.text([a]).split(/\d\s/).reverse().join(" ") == $.text([b]).split(/\d\s/).reverse().join(" ") )
            return 0;

          return $.text([a]).split(/\d\s/).reverse().join(" ") > $.text([b]).split(/\d\s/).reverse().join(" ") ?
            inverse ? -1 : 1
            : inverse ? 1 : -1;
        }, function(){
          return this.parentNode;
        });

        inverse = !inverse;
      });
    });

  $(".input-checkbox .form-check-input").each(function(){
    $(this).change(function(){
      $(this).is(':checked') ? $(this).closest('td').css('background','#45feed') : $(this).closest('td').css('background','#ed36be');
    });
  })

  values = rowsCheckTable()

  $('[data-flex-transactions-ids]').val(values)
}
