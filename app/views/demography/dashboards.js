county = Congo.dashboards.config.county_id;
centerpt = Congo.dashboards.config.centerpt;
size_box = Congo.dashboards.config.size_box;
if (county.length > 0  || centerpt != '' || size_box.length >0){
  Congo.dashboards.config.layer_type = 'demography_info';
  Congo.dashboards.config.style_layer = 'census_voronoi_gse_zn';
  Congo.map_utils.counties();
}else{

  Congo.dashboards.action_index.empty_selection_alert();

}
