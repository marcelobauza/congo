Congo.namespace("reports");

Congo.reports = function(){

  layer_type = Congo.dashboards.config.layer_type;
  kind_reports = Congo.dashboards.config.kind_reports; 
  let url;
  switch (layer_type) {
    case 'future_projects_info':
      switch(kind_reports){
        case 'graph':
          url = '/reports/future_projects_data.xlsx';
          break;
        case 'base':
          url = '/reports/future_projects_summary.xlsx';
          break;
      }
      break;
    case 'transactions_info':
      switch(kind_reports){
        case 'graph':
          url = '/reports/transactions_data.xlsx';
          break;
        case 'base':
          url = '/reports/transactions_summary.xlsx';
          break;
      }
      break;
    case 'projects_feature_info':
      switch(kind_reports){
        case 'graph':
          url = '/reports/projects_data.xlsx';
          break;
        case 'base':
          url = '/reports/projects_summary.xlsx';
          break;
      }
      break;


    default:

  }
  window.open(url, '_blank');
}
