function downloadPDF() {
    $('.hidden.charts').css('display', 'inline');

    var cantidadChartPDF             = $("#chartCantidadPDF");
    var supUtilChartPDF              = $("#chartSupUtilPDF");
    var precioChartPDF               = $("#chartPrecioPDF");
    var precioUnitarioChartPDF       = $("#chartPrecioUnitarioPDF");
    var volMercadoChartPDF           = $("#chartVolMercadoPDF");
    var supUtilBarrasChartPDF        = $("#chartSupUtil-barrasPDF");
    var precioBarrasChartPDF         = $("#chartPrecio-barrasPDF");
    var precioUnitarioBarrasChartPDF = $("#chartPrecioUnitario-barrasPDF");
    var supUFChartPDF                = $("#chartSupUFPDF");
    var labelsChartPDF               = [];
    var dataChartPDF                 = [];
    var radioChartPDF                = [];

    var pdf = new jsPDF();

    // Título
    pdf.setFontStyle("bold");
    pdf.setFontSize(22);
    pdf.text('Informe de Flex', 105, 20, null, null, 'center');

    // Título del gráfico
    pdf.setFontSize(16);
    pdf.setFontStyle("bold");

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

            pdf.text('Cantidad', 105, 30, null, null, 'center');

            var pic_chartCantidadPDF = chartCantidadPDF.toBase64Image();
            var img_height = (chartCantidadPDF.height * 190) / chartCantidadPDF.width
            pdf.addImage(pic_chartCantidadPDF, 'JPEG', 9, 40, 190, img_height);

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

            pdf.text('Superficie Útil', 105, 160, null, null, 'center');

            var pic_chartSupUtilPDF = chartSupUtilPDF.toBase64Image();
            var img_height = (chartSupUtilPDF.height * 190) / chartSupUtilPDF.width
            pdf.addImage(pic_chartSupUtilPDF, 'JPEG', 9, 170, 190, img_height);
            pdf.addPage();

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

            pdf.text('Precio', 105, 30, null, null, 'center');

            var pic_chartPrecioPDF = chartPrecioPDF.toBase64Image();
            var img_height = (chartPrecioPDF.height * 190) / chartPrecioPDF.width
            pdf.addImage(pic_chartPrecioPDF, 'JPEG', 9, 40, 190, img_height);

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

            pdf.text('Precio Unitario', 105, 160, null, null, 'center');

            var pic_chartPrecioUnitarioPDF = chartPrecioUnitarioPDF.toBase64Image();
            var img_height = (chartPrecioUnitarioPDF.height * 190) / chartPrecioUnitarioPDF.width
            pdf.addImage(pic_chartPrecioUnitarioPDF, 'JPEG', 9, 170, 190, img_height);
            pdf.addPage();

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

            pdf.text('Volúmen Mercado', 105, 30, null, null, 'center');

            var pic_chartVolMercadoPDF = chartVolMercadoPDF.toBase64Image();
            var img_height = (chartVolMercadoPDF.height * 190) / chartVolMercadoPDF.width
            pdf.addImage(pic_chartVolMercadoPDF, 'JPEG', 9, 40, 190, img_height);

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

            pdf.text('Superficie Útil', 105, 160, null, null, 'center');

            var pic_chartSupUtilBarrasPDF = chartSupUtilBarrasPDF.toBase64Image();
            var img_height = (chartSupUtilBarrasPDF.height * 190) / chartSupUtilBarrasPDF.width
            pdf.addImage(pic_chartSupUtilBarrasPDF, 'JPEG', 9, 170, 190, img_height);
            pdf.addPage();

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

            pdf.text('Precio', 105, 30, null, null, 'center');

            var pic_chartPrecioBarrasPDF = chartPrecioBarrasPDF.toBase64Image();
            var img_height = (chartPrecioBarrasPDF.height * 190) / chartPrecioBarrasPDF.width
            pdf.addImage(pic_chartPrecioBarrasPDF, 'JPEG', 9, 40, 190, img_height);

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

            pdf.text('Precio Unitario', 105, 160, null, null, 'center');

            var pic_chartPrecioUnitarioBarrasPDF = chartPrecioUnitarioBarrasPDF.toBase64Image();
            var img_height = (chartPrecioUnitarioBarrasPDF.height * 190) / chartPrecioUnitarioBarrasPDF.width
            pdf.addImage(pic_chartPrecioUnitarioBarrasPDF, 'JPEG', 9, 170, 190, img_height);
            pdf.addPage();

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

            pdf.text('Superficie por UF', 105, 30, null, null, 'center');

            var pic_chartSupUFPDF = chartSupUFPDF.toBase64Image();
            var img_height = (chartSupUFPDF.height * 190) / chartSupUFPDF.width
            pdf.addImage(pic_chartSupUFPDF, 'JPEG', 9, 40, 190, img_height);

            radioChartPDF = [];
        }
    });

    // download the pdf
    pdf.save('Informe_Flex.pdf');
    $('.hidden.charts').css('display', 'none');
};
