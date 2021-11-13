Congo.namespace("downloads");

Congo.downloads = function(){

  layer_type = Congo.dashboards.config.layer_type;

  console.log(layer_type);
  switch (layer_type) {
    case 'transactions_info':
          url = '/downloads/transactions_csv.csv';
          window.open(url, '_blank');
    break;
    case 'projects_feature_info':
          url = '/downloads/projects_csv.csv';
          window.open(url, '_blank');
    break;
  }
}
