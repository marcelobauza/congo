Congo.namespace("reports");
Congo.reports = function(){

  layer_type = Congo.dashboards.config.layer_type;
  kind_reports = Congo.dashboards.config.kind_reports;
  let url;
  var area              = Congo.dashboards.config.area;
  var radius            = Congo.dashboards.config.radius;
  var smdProjects       = Congo.dashboards.config.square_meters_download_projects;
  var mdrProjects       = Congo.dashboards.config.meters_download_radius_projects;
  var smdFutureProjects = Congo.dashboards.config.square_meters_download_future_projects;
  var mdrFutureProjects = Congo.dashboards.config.meters_download_radius_future_projects;
  var smdTransactions   = Congo.dashboards.config.square_meters_download_transactions;
  var mdrTransactions   = Congo.dashboards.config.meters_download_radius_transactions;

  switch (layer_type) {
    case 'future_projects_info':
      switch(kind_reports){
        case 'graph':
          if ((area > 0 && area < smda) || (radius > 0 && radius < mdr)) {
            url = '/reports/future_projects_summary.xlsx';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }
          break;
        case 'base':
          if ((area > 0 && area < smdFutureProjects) || (radius > 0 && radius < mdrFutureProjects)) {
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
        case 'kml':
          if ((area > 0 && area < smdFutureProjects) || (radius > 0 && radius < mdrFutureProjects)) {
            url = '/reports/future_projects_data_kml.kml';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }
            break;
      }
      break;
    case 'transactions_info':
      switch(kind_reports){
        case 'graph':
            url = '/reports/transactions_summary.xlsx';
            window.open(url, '_blank');
          break;
        case 'base':
          if ((area > 0 && area < smdTransactions) || (radius > 0 && radius < mdrTransactions)) {
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
        case 'kml':
          if ((area > 0 && area < smdTransactions) || (radius > 0 && radius < mdrTransactions)) {
            url = '/reports/transactions_data_kml.kml';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }
            break;
      }
      break;
    case 'projects_feature_info':
      switch(kind_reports){
        case 'graph':
          url = '/reports/projects_summary.xlsx';
          window.open(url, '_blank');
          break;
        case 'base':

          if ((area > 0 && area < smdProjects) || (radius > 0 && radius < mdrProjects)) {
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
        case 'kml':
          if ((area > 0 && area < smdProjects) || (radius > 0 && radius < mdrProjects)) {
            url = '/reports/projects_data_kml.kml';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }
            break;
      }
      break;
    case 'building_regulations_info':
      switch(kind_reports){
        case 'pdf':
          url = building_regulations_report_pdf();
          break;
        case 'kml':
          if ((area > 0 && area < smdProjects) || (radius > 0 && radius < mdrProjects)) {
            url = '/reports/building_regulations_kml.kml';
            window.open(url, '_blank');
          }else{
            var alert = '<div class="alert m-2 alert-warning alert-dismissible fade show" role="alert">El tamaño de la selección excede el permitido. Por favor, intente nuevamente.<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">×</span> </button></div>'
            $('#alerts').append(alert);
          }
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
}
