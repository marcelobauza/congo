Congo.namespace("reports");
Congo.reports = function(){

  layer_type = Congo.dashboards.config.layer_type;
  kind_reports = Congo.dashboards.config.kind_reports; 
  let url;
  area = Congo.dashboards.config.area;
  radius = Congo.dashboards.config.radius;

  switch (layer_type) {
    case 'future_projects_info':
      switch(kind_reports){
        case 'graph':
          if ((area > 0 && area < 3140000) || (radius > 0 && radius < 1000)) {
            url = '/reports/future_projects_summary.xlsx';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }
          break;
        case 'base':
          if ((area > 0 && area < 3140000) || (radius > 0 && radius < 1000)) {
            url = '/reports/future_projects_data.xlsx';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }

          break;
        case 'pdf':
            url = future_projects_report_pdf();
          break;
      }
      break;
    case 'transactions_info':
      switch(kind_reports){
        case 'graph':
          if ((area > 0 && area < 785398) || (radius > 0 && radius < 500)) {
            url = '/reports/transactions_summary.xlsx';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }

          break;
        case 'base':
          console.log(area);
          if ((area > 0 && area < 785398) || (radius > 0 && radius < 500)) {
            url = '/reports/transactions_data.xlsx';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }

          break;
        case 'pdf':
          url = transactions_report_pdf();
          break;
      }
      break;
    case 'projects_feature_info':
      switch(kind_reports){
        case 'graph':

          if ((area > 0 && area < 3140000) || (radius > 0 && radius < 1000)) {
            url = '/reports/projects_summary.xlsx';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }

          break;
        case 'base':

          if ((area > 0 && area < 3140000) || (radius > 0 && radius < 1000)) {
            url = '/reports/projects_data.xlsx';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }
          break;
        case 'pdf':
          url = projects_report_pdf();
          break;
      }
      break;
    case 'building_regulations_info':
      switch(kind_reports){
        case 'pdf':
          url = building_regulations_report_pdf();
          break;
      }
      break;
    case 'demography_info':
      switch(kind_reports){
        case 'pdf':
        url = demography_report_pdf();
        break;
        }
    default:

  }
  //  window.open(url, '_blank');
}
