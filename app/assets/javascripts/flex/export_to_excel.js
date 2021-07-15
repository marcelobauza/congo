function exportToExcel() {
    // check - uncheck for excel
    $('.genTable .form-check-input').change(function(item){
        $(this).closest('tr').toggleClass('noExl');
        $(this).is(':checked') ? $(this).closest('td').css('background-color','#45feed') : $(this).closest('td').css('background-color','#ed36be');
    });
    $('.user-data .form-check-input').change(function(item){
        $(this).closest('tr').toggleClass('noExl');
        $(this).is(':checked') ? $(this).closest('td').css('background-color','#45feed') : $(this).closest('td').css('background-color','#ed36be');
    });

    $("#table").table2excel({
        // exclude CSS class
        exclude: ".noExl",
        name: "Datos descargados",
        filename: "planilla de resultados", //do not include extension
        fileext: ".xls" // file extension
    });
}