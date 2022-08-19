var street_name_search = function(m){
  // m.addControl(new L.Control.Search({
  //   url: 'https://nominatim.openstreetmap.org/search?format=json&q={s}&countrycodes=cl',
  //   jsonpParam: 'json_callback',
  //   propertyName: 'display_name',
  //   markerLocation: true,
  //   propertyLoc: ['lat', 'lon'],
  //   marker: L.circleMarker([0, 0], {
  //     radius: 30
  //   }),
  //   autoCollapse: true,
  //   autoType: false,
  //   minLength: 2,
  //   zoom: 16
  // }));
var geocoder = new L.Control.geocoder({
  defaultMarkGeocode: false
})
    .on('markgeocode', function(e) {
        var bbox = e.geocode.bbox;
        var poly = L.polygon([
              bbox.getSouthEast(),
              bbox.getNorthEast(),
              bbox.getNorthWest(),
              bbox.getSouthWest()
            ]).addTo(m);
        m.fitBounds(poly.getBounds());
      })
    .addTo(m);
}
