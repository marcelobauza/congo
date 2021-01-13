legend_points = function(params, m){
  var options = [];
  $.each(params, function(a,value){
    color = value['color']
    color = color.replace('#','');
    options.push({
      name: value['name'],
      elements: [{
        html: '',
        style: {
          'background-color': '#'+color,
          'width': '10px',
          'height': '10px'
        }
      }]
    }
    )
  })

  htmlLegend = L.control.htmllegend({
    position: 'bottomleft',
    legends: options,
    collapseSimple: true,
    detectStretched: true,
    collapsedOnInit: true,
    defaultOpacity: 1,
    visibleIcon: 'icon icon-eye',
    hiddenIcon: 'icon icon-eye-slash'
  })

  Congo.dashboards.config.legends = htmlLegend;
  m.addControl(htmlLegend)
}

remove_legend = function(){
  map = Congo.dashboards.config.map
  htmlLegend = Congo.dashboards.config.legends;

  if(typeof(htmlLegend)!=='undefined'){
    map.removeControl(htmlLegend);
  }
}
