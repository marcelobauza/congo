function clearTable() {
    $('tr.genTable').remove();
}

function update_table() {
    $(table_data).each(function (index) {
        $('#table tr:last').after(
            '<tr class="genTable">' +
            '<td><input class="form-check-input" type="checkbox" value="' + ($(this)[0]['id']) + '" checked></td>' +
            '<td>' + ($(this)[0]["property_type_id"]) + '</td>' +
            '<td>' + ($(this)[0]['inscription_date']) + '</td>' +
            '<td>' + ($(this)[0]["address"]) + '</td>' +
            '<td>' + ($(this)[0]['county_id']) + '</td>' +
            '<td>' + ($(this)[0]['seller_type_id']) + '</td>' +
            '<td>' + ($(this)[0]['building_surface']) + '</td>' +
            '<td>' + ($(this)[0]['terrain_surface']) + '</td>' +
            '<td>' + ($(this)[0]['parking_lot']) + '</td>' +
            '<td>' + ($(this)[0]['price']) + '</td>' +
            '<td>' + '' + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '<td class="hidden">' + ($(this)[0]['id']) + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '<td class="hidden">' + '' + '</td>' +
            '</tr>'
        );
    });
    // sort table
    var table = $('table');

    $('#address_sort, #utilm2_sort, #e_sort, #uf_sort')
        .wrapInner('<span title="ordenar esta columna"/>')
        .each(function(){

            var th = $(this),
                thIndex = th.index(),
                inverse = false;

            th.click(function(){

                table.find('td').filter(function(){

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
}