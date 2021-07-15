function clearTable() {
    $('tr.genTable').remove();
}

function update_table() {
    clearTable();

    $("#sel-box").css('display', 'block');
    $("#sel-box").on('click', function(){
        if( $(this).is(':checked') ) {
            $("#table .form-check-input").each(function(){
                $(this).attr('checked', true);
            });
        } else {
            $("#table .form-check-input").each(function(){
                $(this).removeAttr('checked');
            });
        }
    });

    $(table_data).each(function (index) {
        $('#table tr:last').after(
            '<tr class="genTable">' +
            '<td class="for-order input-checkbox"><input class="form-check-input" type="checkbox" value="' + ($(this)[0]['id']) + '" checked></td>' +
            '<td class="for-order">' + ($(this)[0]["property_typee"]) + '</td>' +
            '<td class="for-order">' + ($(this)[0]['inscription_date']) + '</td>' +
            '<td class="for-order">' + ($(this)[0]["address"]) + '</td>' +
            '<td class="for-order">' + ($(this)[0]['seller']) + '</td>' +
            '<td class="for-order">' + ($(this)[0]['building_surface']) + '</td>' +
            '<td class="for-order">' + ($(this)[0]['terrain_surface']) + '</td>' +
            '<td class="for-order">' + ($(this)[0]['parking_lot']) + '</td>' +
            '<td class="for-order">' + ($(this)[0]['cellar']) + '</td>' +
            '<td class="for-order">' + ($(this)[0]['price']) + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '<td class="hidden">' + ($(this)[0]['id']) + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '</tr>'
        );
    });
    $("#cantidad-registros-tabla").text('Registros encontrados: ' + $(table_data).length)
    // sort table

    if ($(table_data).length > 0) {
      $('[data-generate]').removeClass('d-none');
    }

    var table = $('table');

    $('#utilm2_sort, #e_sort, #uf_sort')
        .wrapInner('<span title="ordenar esta columna"/>')
        .each(function(){

            var th = $(this),
                thIndex = th.index(),
                inverse = false;

            th.click(function(){

                table.find('td.for-order').filter(function(){

                    return $(this).index() === thIndex;

                }).sortElements(function(a, b){

                    if( $.text([a]) == $.text([b]) )
                        return 0;

                    return $.text([a]) > $.text([b]) ?
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
        .each(function(){

            var th = $(this),
                thIndex = th.index(),
                inverse = false;

            th.click(function(){

                table.find('td.for-order').filter(function(){

                    return $(this).index() === thIndex;

                }).sortElements(function(a, b){

                    if( $.text([a]).split(/\d\s/).reverse().join(" ") == $.text([b]).split(/\d\s/).reverse().join(" ") )
                        return 0;

                    return $.text([a]).split(/\d\s/).reverse().join(" ") > $.text([b]).split(/\d\s/).reverse().join(" ") ?
                       inverse ? -1 : 1
                       : inverse ? 1 : -1;

                }, function(){

                    // parentNode is the element we want to move
                    return this.parentNode;

                });

                inverse = !inverse;

            });

        });

}
