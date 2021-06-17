function exportToExcel() {
    $("#table").table2excel({
        // exclude CSS class
        exclude: ".noExl",
        name: "Datos descargados",
        filename: "planilla de resultados", //do not include extension
        fileext: ".xls" // file extension
    });
}