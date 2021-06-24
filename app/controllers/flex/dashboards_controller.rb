class Flex::DashboardsController < ApplicationController

  layout 'flex'

  def index
  end

  def search_data_for_filters

    property_type_id = []
    inscription_date = []
    seller_type_id = []
    total_surface_building = []
    total_surface_terrain = []
    calculated_value = []
    uf_m2_u = []
    building_zone = []
    aminciti = []
    hectarea_inhabitants = []

    data = Transaction
      .select("
        transactions.property_type_id,
        transactions.inscription_date,
        transactions.seller_type_id,
        transactions.total_surface_building,
        transactions.total_surface_terrain,
        transactions.calculated_value,
        transactions.uf_m2_u,
        building_regulations.building_zone,
        building_regulations.aminciti,
        building_regulations.hectarea_inhabitants
      ")
      .joins("JOIN building_regulations ON (ST_Contains(building_regulations.the_geom, transactions.the_geom))")
      .method_selection(params)
      .where("transactions.inscription_date > ?", Date.today - 3.years)

    data.each do |tr|
      property_type_id << tr.property_type_id unless property_type_id.include? tr.property_type_id
      inscription_date << tr.inscription_date unless inscription_date.include? tr.inscription_date
      seller_type_id << tr.seller_type_id unless seller_type_id.include? tr.seller_type_id
      total_surface_building << tr.total_surface_building.to_f unless total_surface_building.include? tr.total_surface_building
      total_surface_terrain << tr.total_surface_terrain.to_f unless total_surface_terrain.include? tr.total_surface_terrain
      calculated_value << tr.calculated_value.to_f unless calculated_value.include? tr.calculated_value
      uf_m2_u << tr.uf_m2_u.to_f unless uf_m2_u.include? tr.uf_m2_u
      building_zone << tr.building_zone unless building_zone.include? tr.building_zone
      aminciti << tr.aminciti.to_f unless aminciti.include? tr.aminciti
      hectarea_inhabitants << tr.hectarea_inhabitants.to_f unless hectarea_inhabitants.include? tr.hectarea_inhabitants
    end

    project_types = PropertyType.where(:id => property_type_id).map { |prop| [prop.name, prop.id] }
    seller_types = SellerType.where(:id => seller_type_id).map { |seller| [seller.name, seller.id] }

    result = {
      'property_types': project_types,
      'inscription_dates': {
        'from': inscription_date.min,
        'to': inscription_date.max
      },
      'seller_types': seller_types,
      'land_use': building_zone,
      'max_height': {
        'from': aminciti.min,
        'to': aminciti.max
      },
      'density': {
        'from': hectarea_inhabitants.min,
        'to': hectarea_inhabitants.max
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

    geom = params[:geom]
    property_types = params[:property_types]
    seller_types = params[:seller_types]
    inscription_dates = params[:inscription_dates]
    land_use = params[:land_use]
    max_height = params[:max_height]
    density_types = params[:density_types]
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
      .method_selection(geom)
      .where("transactions.inscription_date > ?", Date.today - 3.years)

    @data = @data.where(:property_type_id => property_types) unless property_types.nil?
    @data = @data.where('inscription_date BETWEEN ? AND ?', inscription_dates[:from].to_date, inscription_dates[:to].to_date) unless inscription_dates.nil?
    @data = @data.where(:seller_type_id => seller_types) unless seller_types.nil?
    @data = @data.where(building_regulations: {:building_zone => land_use}) unless land_use.nil?
    @data = @data.where('building_regulations.aminciti BETWEEN ? AND ?', max_height[:from], max_height[:to]) unless max_height.nil?
    @data = @data.where(building_regulations: {:density_type_id => density_types}) unless density_types.nil?
    @data = @data.where('transactions.total_surface_building BETWEEN ? AND ?', building_surfaces[:from], building_surfaces[:to]) unless building_surfaces.nil?
    @data = @data.where('transactions.total_surface_terrain BETWEEN ? AND ?', terrain_surfaces[:from], terrain_surfaces[:to]) unless terrain_surfaces.nil?
    @data = @data.where('transactions.calculated_value BETWEEN ? AND ?', prices[:from], prices[:to]) unless prices.nil?
    @data = @data.where('transactions.uf_m2_u BETWEEN ? AND ?', unit_prices[:from], unit_prices[:to]) unless unit_prices.nil?

    render :json => @data

  end

  def search_data_for_charts

    transactions = params[:transactions]
    data = []
    result = []
    data = Transaction.where(:id => transactions)


    # Cantidad

    quantity = data
      .select("CONCAT(bimester,'/',year) as name, COUNT(*)")
      .group("CONCAT(bimester,'/',year)")
      .order("CONCAT(bimester,'/',year)")

    quantity = quantity.as_json(:except => :id)
    result.push({"title": "Cantidad", "series": [{"data": quantity}] })


    # Superficie Útil

    building_surface = data
      .select("CONCAT(bimester,'/',year) as name, AVG(total_surface_building) as count")
      .group("CONCAT(bimester,'/',year)")
      .order("CONCAT(bimester,'/',year)")

    building_surface = building_surface.as_json(:except => :id)
    result.push({"title": "Superficie Útil", "series": [{"data": building_surface}] })


    # Precio

    price = data
      .select("CONCAT(bimester,'/',year) as name, AVG(calculated_value) as count")
      .group("CONCAT(bimester,'/',year)")
      .order("CONCAT(bimester,'/',year)")

    price = price.as_json(:except => :id)
    result.push({"title": "Precio", "series": [{"data": price}] })


    # Precio Unitario

    unit_price = data
      .select("CONCAT(bimester,'/',year) as name, AVG(uf_m2_u) as count")
      .group("CONCAT(bimester,'/',year)")
      .order("CONCAT(bimester,'/',year)")

    unit_price = unit_price.as_json(:except => :id)
    result.push({"title": "Precio Unitario", "series": [{"data": unit_price}] })


    # Volúmen Mercado

    market_volume = data
      .select("CONCAT(bimester,'/',year) as name, (AVG(calculated_value) * COUNT(*)) as count")
      .group("CONCAT(bimester,'/',year)")
      .order("CONCAT(bimester,'/',year)")

    market_volume = market_volume.as_json(:except => :id)
    result.push({"title": "Volúmen Mercado", "series": [{"data": market_volume}] })


    # Superficie Útil (barras)
    # # # # # # # # # # # # #

    building_surface_range = data.pluck("total_surface_building")

    # convierte a float
    bsr_fixed = []
    building_surface_range.each { |e| bsr_fixed << e.to_f }
    building_surface_range = bsr_fixed

    # levanta min y max
    value_min = building_surface_range.min.to_f
    value_max = building_surface_range.max.to_f

    # arma rangos
    val_range = (value_max - value_min)/6
    ranges = []
    new_val = value_min
    ranges << new_val.to_f
    5.times do
      new_val = new_val + val_range
      ranges << new_val.to_f
    end
    ranges << value_max.to_f

    values_range_1 = []
    values_range_2 = []
    values_range_3 = []
    values_range_4 = []
    values_range_5 = []
    values_range_6 = []

    # carga los rangos
    building_surface_range.each do |sup|
      sup = sup.to_f
      case sup
      when ranges[0]..ranges[1]
        values_range_1 << sup
      when ranges[1]..ranges[2]
        values_range_2 << sup
      when ranges[2]..ranges[3]
        values_range_3 << sup
      when ranges[3]..ranges[4]
        values_range_4 << sup
      when ranges[4]..ranges[5]
        values_range_5 << sup
      when ranges[5]..ranges[6]
        values_range_6 << sup
      end
    end

    sup_final = [
      {name: '1', count: values_range_1.count},
      {name: '2', count: values_range_2.count},
      {name: '3', count: values_range_3.count},
      {name: '4', count: values_range_4.count},
      {name: '5', count: values_range_5.count},
      {name: '6', count: values_range_6.count},
    ]

    result.push({"title": "Superficie Útil (barras)", "series": [{"data": sup_final}] })



    # Precio (barras)
    # # # # # # # # # # # # #

    calculated_value_range = data.pluck("calculated_value")

    # convierte a float
    cvr_fixed = []
    calculated_value_range.each { |e| cvr_fixed << e.to_f }
    calculated_value_range = cvr_fixed

    # levanta min y max
    value_min = calculated_value_range.min.to_f
    value_max = calculated_value_range.max.to_f

    # arma rangos
    val_range = (value_max - value_min)/6
    ranges = []
    new_val = value_min
    ranges << new_val.to_f
    5.times do
      new_val = new_val + val_range
      ranges << new_val.to_f
    end
    ranges << value_max.to_f

    values_range_1 = []
    values_range_2 = []
    values_range_3 = []
    values_range_4 = []
    values_range_5 = []
    values_range_6 = []

    # carga los rangos
    calculated_value_range.each do |pri|
      pri = pri.to_f
      case pri
      when ranges[0]..ranges[1]
        values_range_1 << pri
      when ranges[1]..ranges[2]
        values_range_2 << pri
      when ranges[2]..ranges[3]
        values_range_3 << pri
      when ranges[3]..ranges[4]
        values_range_4 << pri
      when ranges[4]..ranges[5]
        values_range_5 << pri
      when ranges[5]..ranges[6]
        values_range_6 << pri
      end
    end

    pri_final = [
      {name: '1', count: values_range_1.count},
      {name: '2', count: values_range_2.count},
      {name: '3', count: values_range_3.count},
      {name: '4', count: values_range_4.count},
      {name: '5', count: values_range_5.count},
      {name: '6', count: values_range_6.count},
    ]

    result.push({"title": "Precio (barras)", "series": [{"data": pri_final}] })



    # Precio Unitario (barras)
    # # # # # # # # # # # # #

    uf_m2_u_range = data.pluck("uf_m2_u")

    # convierte a float
    umur_fixed = []
    uf_m2_u_range.each { |e| umur_fixed << e.to_f }
    uf_m2_u_range = umur_fixed

    # levanta min y max
    value_min = uf_m2_u_range.min.to_f
    value_max = uf_m2_u_range.max.to_f

    # arma rangos
    val_range = (value_max - value_min)/6
    ranges = []
    new_val = value_min
    ranges << new_val.to_f
    5.times do
      new_val = new_val + val_range
      ranges << new_val.to_f
    end
    ranges << value_max.to_f

    values_range_1 = []
    values_range_2 = []
    values_range_3 = []
    values_range_4 = []
    values_range_5 = []
    values_range_6 = []

    # carga los rangos
    uf_m2_u_range.each do |pri_u|
      pri_u = pri_u.to_f
      case pri_u
      when ranges[0]..ranges[1]
        values_range_1 << pri_u
      when ranges[1]..ranges[2]
        values_range_2 << pri_u
      when ranges[2]..ranges[3]
        values_range_3 << pri_u
      when ranges[3]..ranges[4]
        values_range_4 << pri_u
      when ranges[4]..ranges[5]
        values_range_5 << pri_u
      when ranges[5]..ranges[6]
        values_range_6 << pri_u
      end
    end

    pri_u_final = [
      {name: '1', count: values_range_1.count},
      {name: '2', count: values_range_2.count},
      {name: '3', count: values_range_3.count},
      {name: '4', count: values_range_4.count},
      {name: '5', count: values_range_5.count},
      {name: '6', count: values_range_6.count},
    ]

    result.push({"title": "Precio Unitario (barras)", "series": [{"data": pri_u_final}] })



    # Superficie por UF
    # # # # # # # # # #

    sup_x_uf = data
      .select("calculated_value as name, AVG(total_surface_building) as count, COUNT(*) as radius")
      .group(:calculated_value)
      .order(:calculated_value)

    sup_x_uf = sup_x_uf.as_json(:except => :id)

    result.push({"title": "Superficie por UF", "series": [{"data": sup_x_uf}] })

    render :json => result

  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      @transaction.save
      format.js

    end
  end

  def transaction_params
    params.require(:transaction).permit(:property_type_id, :address, :sheet, :number, :inscription_date, :buyer_name, :buyer_rut, :seller_type_id, :department, :blueprint, :uf_value, :real_value, :calculated_value, :quarter,:year, :sample_factor, :county_id, :the_geom, :cellar, :parkingi, :role, :seller_name, :buller_rut, :uf_m2, :tome, :lot, :block, :village, :surface, :requiring_entity, :comments, :user_id, :surveyor_id, :active, :bimester, :code_sii, :total_surface_building, :total_surface_terrain, :uf_m2_u, :uf_m2_t, :building_regulation, :role_1, :role_2, :code_destination, :code_material, :year_sii, :latitude, :longitude, :additional_roles).merge(user_id: current_user.id)
  end
end
