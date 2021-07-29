street_name_search = function(m){
  m.addControl(new L.Control.Search({
    url: 'https://nominatim.openstreetmap.org/search?format=json&q={s}&countrycodes=cl',
    jsonpParam: 'json_callback',
    propertyName: 'display_name',
    markerLocation: true,
    propertyLoc: ['lat', 'lon'],
    marker: L.circleMarker([0, 0], {
      radius: 30
    }),
    autoCollapse: true,
    autoType: false,
    minLength: 2,
    zoom: 16
  }));
}
