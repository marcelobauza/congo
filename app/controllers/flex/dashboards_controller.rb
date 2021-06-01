class Flex::DashboardsController < ApplicationController

  layout 'flex'

  def index
  end

  def search_data_for_filters

    polygon = params[:polygon]
    property_type_id = []
    inscription_date = []
    seller_type_id = []
    total_surface_building = []
    total_surface_terrain = []
    calculated_value = []
    uf_m2_u = []
    osinciti = []
    aminciti = []

    data = Transaction
      .select("
        transactions.property_type_id,
        transactions.inscription_date,
        transactions.seller_type_id,
        transactions.total_surface_building,
        transactions.total_surface_terrain,
        transactions.calculated_value,
        transactions.uf_m2_u,
        building_regulations.osinciti,
        building_regulations.aminciti
      ")
      .joins("JOIN building_regulations ON (ST_Contains(building_regulations.the_geom, transactions.the_geom))")
      .where("ST_Contains(ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"Polygon\", \"coordinates\": #{polygon}}'), 4326), transactions.the_geom)")
      .where("ST_Intersects(ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"Polygon\", \"coordinates\": #{polygon}}'), 4326), building_regulations.the_geom)")
      .order(id: :desc)
      .limit(500)

    data.each do |tr|
      property_type_id << tr.property_type_id unless property_type_id.include? tr.property_type_id
      inscription_date << tr.inscription_date unless inscription_date.include? tr.inscription_date
      seller_type_id << tr.seller_type_id unless seller_type_id.include? tr.seller_type_id
      total_surface_building << tr.total_surface_building.to_f unless total_surface_building.include? tr.total_surface_building
      total_surface_terrain << tr.total_surface_terrain.to_f unless total_surface_terrain.include? tr.total_surface_terrain
      calculated_value << tr.calculated_value.to_f unless calculated_value.include? tr.calculated_value
      uf_m2_u << tr.uf_m2_u.to_f unless uf_m2_u.include? tr.uf_m2_u
      osinciti << tr.osinciti.to_f unless osinciti.include? tr.osinciti
      aminciti << tr.aminciti.to_f unless aminciti.include? tr.aminciti
    end

    project_types = ProjectType.where(:id => property_type_id).map { |prop| [prop.name, prop.id] }
    seller_types = SellerType.where(:id => seller_type_id).map { |seller| [seller.name, seller.id] }

    result = {
      'property_types': project_types,
      'inscription_dates': {
        'from': inscription_date.min,
        'to': inscription_date.max
      },
      'seller_types': seller_types,
      'land_use': {
        'from': osinciti.min,
        'to': osinciti.max
      },
      'max_height': {
        'from': aminciti.min,
        'to': aminciti.max
      },
      'building_surfaces': {
        'from': total_surface_building.min,
        'to': total_surface_building.max
      },
      'terrain_surfaces': {
        'from': total_surface_terrain.min,
        'to': total_surface_terrain.max
      },
      'prices': {
        'from': calculated_value.min,
        'to': calculated_value.max
      },
      'unit_prices': {
        'from': uf_m2_u.min,
        'to': uf_m2_u.max
      }
    }
    render json: result
  end

  def search_data_for_table

    property_type = params[:property_types]
    inscription_date = params[:inscription_date]
    seller_types = params[:seller_types]
    land_use = params[:land_use]
    max_height = params[:max_height]
    building_surfaces = params[:building_surfaces]
    terrain_surfaces = params[:terrain_surfaces]
    prices = params[:prices]
    unit_prices = params[:unit_prices]

    @data = Transaction
      .select("
        transactions.id,
        property_types.name AS property_typee,
        transactions.inscription_date,
        transactions.address,
        counties.name AS c_name,
        seller_types.name AS seller,
        transactions.total_surface_building AS building_surface,
        transactions.total_surface_terrain AS terrain_surface,
        transactions.parkingi AS parking_lot,
        transactions.cellar,
        transactions.calculated_value AS price
      ")
      .joins("JOIN building_regulations ON (ST_Contains(building_regulations.the_geom, transactions.the_geom))")
      .joins("INNER JOIN property_types ON (property_types.id = transactions.property_type_id)")
      .joins("INNER JOIN seller_types ON (seller_types.id = transactions.seller_type_id)")
      .joins("INNER JOIN counties ON (counties.id = transactions.county_id)")
      .where("ST_Contains(ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"Polygon\", \"coordinates\":[[[\"-70.74010848999025\", \"-33.43007977475543\"], [\"-70.74010848999025\", \"-33.46796263238644\"], [\"-70.67994117736818\", \"-33.44461900927522\"], [\"-70.74010848999025\", \"-33.43007977475543\"]]]}'), 4326), transactions.the_geom)")
      .where("ST_Intersects(ST_SetSRID(ST_GeomFromGeoJSON('{\"type\":\"Polygon\", \"coordinates\":[[[\"-70.74010848999025\", \"-33.43007977475543\"], [\"-70.74010848999025\", \"-33.46796263238644\"], [\"-70.67994117736818\", \"-33.44461900927522\"], [\"-70.74010848999025\", \"-33.43007977475543\"]]]}'), 4326), building_regulations.the_geom)")
      .order(id: :desc)
      .limit(500)

    @data = @data.where(:property_type_id => property_type) unless property_type.nil?
    @data = @data.where('inscription_date BETWEEN ? AND ?', inscription_date[:from], inscription_date[:to]) unless inscription_date.nil?
    @data = @data.where(:seller_type_id => seller_types) unless seller_types.nil?
    @data = @data.where('building_regulations.osinciti BETWEEN ? AND ?', land_use[:from], land_use[:to]) unless land_use.nil?
    @data = @data.where('building_regulations.aminciti BETWEEN ? AND ?', max_height[:from], max_height[:to]) unless max_height.nil?
    @data = @data.where('transactions.total_surface_building BETWEEN ? AND ?', building_surfaces[:from], building_surfaces[:to]) unless building_surfaces.nil?
    @data = @data.where('transactions.total_surface_building BETWEEN ? AND ?', building_surfaces[:from], building_surfaces[:to]) unless building_surfaces.nil?
    @data = @data.where('transactions.total_surface_terrain BETWEEN ? AND ?', terrain_surfaces[:from], terrain_surfaces[:to]) unless terrain_surfaces.nil?
    @data = @data.where('transactions.calculated_value BETWEEN ? AND ?', prices[:from], prices[:to]) unless prices.nil?
    @data = @data.where('transactions.uf_m2_u BETWEEN ? AND ?', unit_prices[:from], unit_prices[:to]) unless unit_prices.nil?

    render :json => @data


    harcoded_data = [{"id":3929666,"address":"632 Cruchaga Montt","inscription_date":"2020-12-14","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"172.0","terrain_surface":"172.0","parking_lot":0,"price":"1032.0"},{"id":3898209,"address":"4588 Pasaje Elvira Davila","inscription_date":"2020-11-23","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"110.0","terrain_surface":"196.0","parking_lot":0,"price":"3831.0"},{"id":2615973,"address":"793 Pedro Antonio Gonzalez","inscription_date":"2020-08-18","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"131.0","terrain_surface":"147.0","parking_lot":0,"price":"1953.0"},{"id":2597245,"address":"4739 Porto Seguro","inscription_date":"2020-05-04","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"EMPRESA","building_surface":"112.0","terrain_surface":"194.0","parking_lot":0,"price":"4703.0"},{"id":2594402,"address":"437 Radal","inscription_date":"2020-03-11","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"104.0","terrain_surface":"176.0","parking_lot":0,"price":"3560.0"},{"id":2506068,"address":"530 Herbert Hoover","inscription_date":"2019-11-14","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"132.0","terrain_surface":"163.0","parking_lot":0,"price":"2504.0"},{"id":2503657,"address":"622 Cantinera","inscription_date":"2019-06-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"126.0","terrain_surface":"108.0","parking_lot":0,"price":"1400.0"},{"id":2503587,"address":"148 Calle Little Rock","inscription_date":"2019-06-04","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"146.0","terrain_surface":"172.0","parking_lot":0,"price":"779.0"},{"id":2482173,"address":"392 Ladislao Gallego","inscription_date":"2019-08-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"100.0","terrain_surface":"162.0","parking_lot":0,"price":"2162.0"},{"id":2464137,"address":"4406 Catedral","inscription_date":"2019-10-18","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"176.0","terrain_surface":"199.0","parking_lot":0,"price":"731.0"},{"id":2307090,"address":"16 La Plazuela Del Jaracanda","inscription_date":"2019-06-20","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"100.0","terrain_surface":"162.0","parking_lot":0,"price":"2543.0"},{"id":2303584,"address":"262 Gaspar De Orense","inscription_date":"2019-06-03","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"100.0","terrain_surface":"200.0","parking_lot":0,"price":"756.0"},{"id":2261290,"address":"953 General Velasquez","inscription_date":"2019-05-07","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"108.0","terrain_surface":"140.0","parking_lot":0,"price":"1625.0"},{"id":2261019,"address":"98 Santa Petronila","inscription_date":"2019-05-06","cellar":0,"property_typee":"CASA","c_name":"Estación Central","seller":"PROPIETARIO","building_surface":"134.0","terrain_surface":"140.0","parking_lot":0,"price":"542.0"},{"id":2255696,"address":"404 Pasaje Marinero Ojeda","inscription_date":"2019-03-06","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"159.0","terrain_surface":"162.0","parking_lot":0,"price":"2431.0"},{"id":2254176,"address":"793 Pedro Antonio Gonzalez","inscription_date":"2019-02-22","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"131.0","terrain_surface":"147.0","parking_lot":0,"price":"1927.0"},{"id":2189686,"address":"307 Pardo Villalon","inscription_date":"2019-02-07","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"108.0","terrain_surface":"162.0","parking_lot":0,"price":"726.0"},{"id":2189029,"address":"5848 Caldera","inscription_date":"2019-02-05","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"INMOBILIARIA","building_surface":"121.0","terrain_surface":"162.0","parking_lot":0,"price":"2104.0"},{"id":2186890,"address":"6159 Isla Walton","inscription_date":"2019-01-24","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"178.0","terrain_surface":"162.0","parking_lot":0,"price":"3267.0"},{"id":2186605,"address":"1132 Estados Unidos","inscription_date":"2019-01-22","cellar":0,"property_typee":"CASA","c_name":"Cerro Navia","seller":"PROPIETARIO","building_surface":"105.0","terrain_surface":"147.0","parking_lot":0,"price":"2088.0"},{"id":2185362,"address":"5982 Canal Ballenero","inscription_date":"2019-01-09","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"133.0","terrain_surface":"193.0","parking_lot":0,"price":"907.0"},{"id":2165865,"address":"6124 Jiroz","inscription_date":"2019-05-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"148.0","terrain_surface":"162.0","parking_lot":0,"price":"848.0"},{"id":2165542,"address":"8041 Lago Ontario","inscription_date":"2019-04-24","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"108.0","terrain_surface":"162.0","parking_lot":0,"price":"1270.0"},{"id":2163594,"address":"6137 Capitan Pedro De Cordova","inscription_date":"2019-03-28","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"148.0","terrain_surface":"162.0","parking_lot":0,"price":"1814.0"},{"id":2163184,"address":"134 Los Pinos","inscription_date":"2019-03-26","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"101.0","terrain_surface":"162.0","parking_lot":0,"price":"3084.0"},{"id":2156936,"address":"6474 Lo Prado","inscription_date":"2018-10-10","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"EMPRESA","building_surface":"144.0","terrain_surface":"190.0","parking_lot":0,"price":"1644.0"},{"id":2155103,"address":"517 Froilan Bijou","inscription_date":"2018-08-21","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"100.0","terrain_surface":"162.0","parking_lot":0,"price":"3027.0"},{"id":2122455,"address":"379 Ministro Gana","inscription_date":"2018-03-09","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"175.0","terrain_surface":"162.0","parking_lot":0,"price":"1491.0"},{"id":2095374,"address":"854 Los Lirios","inscription_date":"2018-11-23","cellar":1,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"106.0","terrain_surface":"200.0","parking_lot":0,"price":"727.0"},{"id":2095232,"address":"8058 Tacora","inscription_date":"2018-11-21","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"120.0","terrain_surface":"127.0","parking_lot":0,"price":"909.0"},{"id":2091701,"address":"313 Chiclayo","inscription_date":"2018-10-25","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"110.0","terrain_surface":"162.0","parking_lot":0,"price":"973.0"},{"id":2066314,"address":"5851 Ingeniero Jiroz","inscription_date":"2018-12-06","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"105.0","terrain_surface":"162.0","parking_lot":0,"price":"2579.0"},{"id":2019829,"address":"125 Cruchaga Montt","inscription_date":"2018-05-07","cellar":0,"property_typee":"CASA","c_name":"Quinta Normal","seller":"PROPIETARIO","building_surface":"146.0","terrain_surface":"136.0","parking_lot":0,"price":"2554.0"},{"id":2010087,"address":"5411 Islas Hebridas","inscription_date":"2018-08-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"129.0","terrain_surface":"162.0","parking_lot":0,"price":"4040.0"},{"id":2003976,"address":"498 Las Rejas Norte","inscription_date":"2018-02-28","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"126.0","terrain_surface":"199.0","parking_lot":0,"price":"3165.0"},{"id":1990372,"address":"633 Las Torres","inscription_date":"2018-07-24","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"103.0","terrain_surface":"170.0","parking_lot":0,"price":"2702.0"},{"id":1968867,"address":"6474 Lo Prado","inscription_date":"2018-05-10","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"144.0","terrain_surface":"190.0","parking_lot":0,"price":"1665.0"},{"id":1968673,"address":"155 Ministro Gana","inscription_date":"2018-05-07","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"145.0","terrain_surface":"162.0","parking_lot":0,"price":"1666.0"},{"id":1968366,"address":"6149 Santa Luisa","inscription_date":"2018-05-02","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"102.0","terrain_surface":"200.0","parking_lot":0,"price":"815.0"},{"id":1909958,"address":"5885 Eleusis","inscription_date":"2018-07-06","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"193.0","terrain_surface":"162.0","parking_lot":0,"price":"2686.0"},{"id":1904943,"address":"477 Los Ediles","inscription_date":"2018-06-21","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"129.0","terrain_surface":"162.0","parking_lot":0,"price":"737.0"},{"id":1902446,"address":"162 Juan Dee Fuca","inscription_date":"2018-03-22","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"127.0","terrain_surface":"184.0","parking_lot":0,"price":"2442.0"},{"id":1901418,"address":"5455 Islas De Man","inscription_date":"2018-03-13","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"114.0","terrain_surface":"162.0","parking_lot":0,"price":"705.0"},{"id":1887898,"address":"5937 Diego Aracena","inscription_date":"2018-04-10","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"111.0","terrain_surface":"162.0","parking_lot":0,"price":"3189.0"},{"id":20611,"address":"6135 Territorio Antartico","inscription_date":"2020-04-07","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"146.0","terrain_surface":"162.0","parking_lot":0,"price":"996.0"},{"id":20493,"address":"7030 Los Arrayanes","inscription_date":"2020-04-06","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"129.0","terrain_surface":"167.0","parking_lot":0,"price":"2741.0"},{"id":20264,"address":"879 Gabriela Mistral","inscription_date":"2020-04-02","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"152.0","terrain_surface":"176.0","parking_lot":0,"price":"2320.0"},{"id":19586,"address":"517 Pasaje Piura","inscription_date":"2020-03-23","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"112.0","terrain_surface":"170.0","parking_lot":0,"price":"1575.0"},{"id":16595,"address":"531 Puerto Williams","inscription_date":"2020-03-02","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"112.0","terrain_surface":"160.0","parking_lot":0,"price":"2814.0"},{"id":16173,"address":"572 La Quidora","inscription_date":"2020-02-14","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"125.0","terrain_surface":"162.0","parking_lot":0,"price":"1057.0"},{"id":15621,"address":"119 Little Rock","inscription_date":"2020-01-07","cellar":0,"property_typee":"CASA","c_name":"Lo Prado","seller":"PROPIETARIO","building_surface":"114.0","terrain_surface":"160.0","parking_lot":0,"price":"3011.0"}]






  end
end
