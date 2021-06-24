function downloadPDF() {
    $('.hidden.charts').css('display', 'inline');

    var cantidadChartPDF = $("#chartCantidadPDF");
    var supUtilChartPDF = $("#chartSupUtilPDF");
    var precioChartPDF = $("#chartPrecioPDF");
    var precioUnitarioChartPDF = $("#chartPrecioUnitarioPDF");
    var volMercadoChartPDF = $("#chartVolMercadoPDF");
    var supUtilBarrasChartPDF = $("#chartSupUtil-barrasPDF");
    var precioBarrasChartPDF = $("#chartPrecio-barrasPDF");
    var precioUnitarioBarrasChartPDF = $("#chartPrecioUnitario-barrasPDF");
    var supUFChartPDF = $("#chartSupUFPDF");
    labelsChartPDF = [];
    dataChartPDF = [];
    radioChartPDF = [];
    $(charts).each(function () {
        if ($(this)[0]['title'] == 'Cantidad') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChartPDF.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChartPDF.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartCantidadPDF = new Chart(cantidadChartPDF, {
                type: 'line',
                data: {
                    labels: labelsChartPDF,
                    datasets: [{
                        data: dataChartPDF,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChartPDF = [];
            dataChartPDF = [];
        }
        if ($(this)[0]['title'] == 'Superficie Útil') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChartPDF.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChartPDF.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartSupUtilPDF = new Chart(supUtilChartPDF, {
                type: 'line',
                data: {
                    labels: labelsChartPDF,
                    datasets: [{
                        data: dataChartPDF,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChartPDF = [];
            dataChartPDF = [];
        }
        if ($(this)[0]['title'] == 'Precio') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChartPDF.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChartPDF.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartPrecioPDF = new Chart(precioChartPDF, {
                type: 'line',
                data: {
                    labels: labelsChartPDF,
                    datasets: [{
                        data: dataChartPDF,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChartPDF = [];
            dataChartPDF = [];
        }
        if ($(this)[0]['title'] == 'Precio Unitario') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChartPDF.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChartPDF.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartPrecioUnitarioPDF = new Chart(precioUnitarioChartPDF, {
                type: 'line',
                data: {
                    labels: labelsChartPDF,
                    datasets: [{
                        data: dataChartPDF,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChartPDF = [];
            dataChartPDF = [];
        }
        if ($(this)[0]['title'] == 'Volúmen Mercado') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChartPDF.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChartPDF.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartVolMercadoPDF = new Chart(volMercadoChartPDF, {
                type: 'line',
                data: {
                    labels: labelsChartPDF,
                    datasets: [{
                        data: dataChartPDF,
                        label: "",
                        fill: false,
                        borderColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        backgroundColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChartPDF = [];
            dataChartPDF = [];
        }
        if ($(this)[0]['title'] == 'Superficie Útil (barras)') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChartPDF.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChartPDF.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartSupUtilBarrasPDF = new Chart(supUtilBarrasChartPDF, {
                type: 'bar',
                data: {
                    labels: labelsChartPDF,
                    datasets: [{
                        data: dataChartPDF,
                        label: "",
                        backgroundColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChartPDF = [];
            dataChartPDF = [];
        }
        if ($(this)[0]['title'] == 'Precio (barras)') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChartPDF.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChartPDF.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartPrecioBarrasPDF = new Chart(precioBarrasChartPDF, {
                type: 'bar',
                data: {
                    labels: labelsChartPDF,
                    datasets: [{
                        data: dataChartPDF,
                        label: "",
                        backgroundColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChartPDF = [];
            dataChartPDF = [];
        }
        if ($(this)[0]['title'] == 'Precio Unitario (barras)') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                labelsChartPDF.push($(this)[0]['series'][0]['data'][i]['name'])
                dataChartPDF.push($(this)[0]['series'][0]['data'][i]['count'])
            }
            var chartPrecioUnitarioBarrasPDF = new Chart(precioUnitarioBarrasChartPDF, {
                type: 'bar',
                data: {
                    labels: labelsChartPDF,
                    datasets: [{
                        data: dataChartPDF,
                        label: "",
                        backgroundColor: 'rgb(69,254,237)',
                        tension: 0.1,
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            labelsChartPDF = [];
            dataChartPDF = [];
        }
        if ($(this)[0]['title'] == 'Superficie por UF') {
            for (i = 0; i < $(this)[0]['series'][0]['data'].length; i++) {
                radioChartPDF.push
                (
                    {
                        x: $(this)[0]['series'][0]['data'][i]['name'],
                        y: $(this)[0]['series'][0]['data'][i]['count'],
                        r: $(this)[0]['series'][0]['data'][i]['radius']
                    }
                );
            }
            var chartSupUFPDF = new Chart(supUFChartPDF, {
                type: 'bubble',
                data: {
                    labels: labelsChartPDF,
                    datasets: [{
                        data: radioChartPDF,
                        label: "",
                        backgroundColor: 'rgb(69,254,237)',
                        borderWidth: 2
                    }]
                },
                options: {
                    animation: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        enabled: false
                    },
                    plugins: {
                        datalabels: {
                            display: false
                        }
                    }
                }
            });
            radioChartPDF = [];
        }
    });

    var pdf = new jsPDF('l', 'pt', 'a4');

    // for each chart.js chart
    $(".hidden canvas").each(function(item) {
        pdf.addImage($(this)[0], 'PNG', 0, 0);
        if(item < $('.hidden canvas').length - 1){
            pdf.addPage();
        }
    });

    // download the pdf
    pdf.save('filename.pdf');
    $('.hidden.charts').css('display', 'none');
};