class Flex::FlexReportsController < ApplicationController
  before_action :set_flex_report, only: [:show]

  layout 'flex_dashboard', except: [:index]

  # GET /flex/reports
  # GET /flex/reports.json
  def index
    @flex_reports = FlexReport.all.paginate(page: params[:page], per_page: 10)
    render layout: 'flex'
  end

  # GET /flex/reports/1
  # GET /flex/reports/1.json
  def show

    @transactions = Transaction.where(id: @flex_report.transaction_ids)

    @tr_ids_array = []
    @transactions.each do |tr|
      @tr_ids_array << tr.id
    end

    respond_to do |format|
      format.js
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Flex_report.xlsx"'
      }
    end
  end

  # GET /flex/reports/new
  def new
    @flex_report = FlexReport.new
  end

  # POST /flex/reports
  # POST /flex/reports.json
  def create
    @flex_report = FlexReport.new(flex_report_params)
    @flex_report[:transaction_ids] = params[:flex_report][:transaction_ids].split(',').map(&:to_i)
    @flex_report[:filters] = session[:data]

    respond_to do |format|
      if @flex_report.save
        format.js
        format.html { redirect_to @flex_report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @flex_report }
      else
        format.js
        format.html { render :new }
        format.json { render json: @flex_report.errors, status: :unprocessable_entity }
      end
    end
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
      'seller_types': seller_types,
      'land_use': building_zone,
      'inscription_dates': {
        'from': inscription_date.min,
        'to': inscription_date.max
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
    geom              = params[:geom]
    property_types    = params[:property_types]
    seller_types      = params[:seller_types]
    land_use          = params[:land_use]
    inscription_dates = params[:inscription_dates]
    terrain_surfaces  = params[:terrain_surfaces]
    building_surfaces = params[:building_surfaces]
    prices            = params[:prices]
    unit_prices       = params[:unit_prices]

    session[:data] = params

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
    @data = @data.where(:seller_type_id => seller_types) unless seller_types.nil?
    @data = @data.where(building_regulations: {:building_zone => land_use}) unless land_use.nil?
    @data = @data.where('inscription_date BETWEEN ? AND ?', inscription_dates[:from].to_date, inscription_dates[:to].to_date) unless inscription_dates.nil?
    @data = @data.where('transactions.total_surface_terrain BETWEEN ? AND ?', terrain_surfaces[:from], terrain_surfaces[:to]) unless terrain_surfaces.nil?
    @data = @data.where('transactions.total_surface_building BETWEEN ? AND ?', building_surfaces[:from], building_surfaces[:to]) unless building_surfaces.nil?
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

    avg_quantity = quantity.map(&:clone)
    total = []
    avg_quantity.each do |a|
      count = a['count']
      count = 0.0 if a['count'].nil?
      total << count
    end
    avg = total.sum / total.size.to_f
    avg_quantity.each do |b|
      b['count'] = '%.2f' % avg
    end

    result.push({"title": "Cantidad", "series": [{'name': 'Cantidad', "data": quantity}, {'name': 'Promedio', "data": avg_quantity}] })


    # Superficie Útil

    building_surface = data
      .select("CONCAT(bimester,'/',year) as name, AVG(total_surface_building) as count")
      .group("CONCAT(bimester,'/',year)")
      .order("CONCAT(bimester,'/',year)")

    building_surface = building_surface.as_json(:except => :id)

    avg_building_surface = building_surface.map(&:clone)
    total = []
    avg_building_surface.each do |a|
      count = a['count']
      count = 0.0 if a['count'].nil?
      total << count
    end
    avg = total.sum / total.size.to_f
    avg_building_surface.each do |b|
      b['count'] = '%.2f' % avg
    end

    result.push({"title": "Superficie Útil", "series": [{'name': 'Promedio Bimestre', "data": building_surface}, {'name': 'Promedio Muestra', "data": avg_building_surface}] })


    # Precio

    price = data
      .select("CONCAT(bimester,'/',year) as name, AVG(calculated_value) as count")
      .group("CONCAT(bimester,'/',year)")
      .order("CONCAT(bimester,'/',year)")

    price = price.as_json(:except => :id)

    avg_price = price.map(&:clone)
    total = []
    avg_price.each do |a|
      count = a['count']
      count = 0.0 if a['count'].nil?
      total << count
    end
    avg = total.sum / total.size.to_f
    avg_price.each do |b|
      b['count'] = '%.2f' % avg
    end

    result.push({"title": "Precio", "series": [{'name': 'Promedio Bimestre', "data": price}, {'name': 'Promedio Muestra', "data": avg_price}] })


    # Precio Unitario

    unit_price = data
      .select("CONCAT(bimester,'/',year) as name, AVG(uf_m2_u) as count")
      .group("CONCAT(bimester,'/',year)")
      .order("CONCAT(bimester,'/',year)")

    unit_price = unit_price.as_json(:except => :id)

    avg_unit_price = unit_price.map(&:clone)
    total = []
    avg_unit_price.each do |a|
      count = a['count']
      count = 0.0 if a['count'].nil?
      total << count
    end
    avg = total.sum / total.size.to_f
    avg_unit_price.each do |b|
      b['count'] = '%.2f' % avg
    end

    result.push({"title": "Precio Unitario", "series": [{'name': 'Promedio Bimestre', "data": unit_price}, {'name': 'Promedio Muestra', "data": avg_unit_price}] })


    # Volúmen Mercado

    market_volume = data
      .select("CONCAT(bimester,'/',year) as name, (AVG(calculated_value) * COUNT(*)) as count")
      .group("CONCAT(bimester,'/',year)")
      .order("CONCAT(bimester,'/',year)")

    market_volume = market_volume.as_json(:except => :id)

    avg_market_volume = market_volume.map(&:clone)
    total = []
    avg_market_volume.each do |a|
      count = a['count']
      count = 0.0 if a['count'].nil?
      total << count
    end
    avg = total.sum / total.size.to_f
    avg_market_volume.each do |b|
      b['count'] = '%.2f' % avg
    end

    result.push({"title": "Volúmen Mercado", "series": [{'name': 'Promedio Bimestre', "data": market_volume}, {'name': 'Promedio Muestra', "data": avg_market_volume}] })



    # Traemos los registros del usuario para armar las otras series

    user_rows = Tenement.order(:id).where("created_at::date = current_date")
    # Superficie Útil (barras)
    # # # # # # # # # # # # #

    # Datos para serie usuario
    user_building_surface = user_rows.pluck("building_surface")

    # convierte a float (user)
    bsr_fixed = []
    user_building_surface.each { |e| bsr_fixed << e.to_f }
    user_building_surface = bsr_fixed

    # Datos para serie base
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

    # Arma la serie del usuario
    values_range_1 = []
    values_range_2 = []
    values_range_3 = []
    values_range_4 = []
    values_range_5 = []
    values_range_6 = []

    user_building_surface.each do |sup|
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

    user_bs_final = [
      {name: '1', count: values_range_1.count},
      {name: '2', count: values_range_2.count},
      {name: '3', count: values_range_3.count},
      {name: '4', count: values_range_4.count},
      {name: '5', count: values_range_5.count},
      {name: '6', count: values_range_6.count},
    ]

    result.push({"title": "Superficie Útil (barras)", "series": [{"name": "Registros Base", "data": sup_final}, {"name": "Registros Usuario", "data": user_bs_final}] })



    # Precio (barras)
    # # # # # # # # # # # # #

    ## Datos para serie usuario
    user_calculated_value = user_rows.pluck("uf")

    # convierte a float (user)
    bsr_fixed = []
    user_calculated_value.each { |e| bsr_fixed << e.to_f }
    user_calculated_value = bsr_fixed


    ## Datos para serie base
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

    # Arma la serie del usuario
    values_range_1 = []
    values_range_2 = []
    values_range_3 = []
    values_range_4 = []
    values_range_5 = []
    values_range_6 = []

    user_calculated_value.each do |sup|
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

    user_cv_final = [
      {name: '1', count: values_range_1.count},
      {name: '2', count: values_range_2.count},
      {name: '3', count: values_range_3.count},
      {name: '4', count: values_range_4.count},
      {name: '5', count: values_range_5.count},
      {name: '6', count: values_range_6.count},
    ]

    result.push({"title": "Precio (barras)", "series": [{"name": "Registros Base", "data": pri_final}, {"name": "Registros Usuario", "data": user_cv_final}] })


    # Precio Unitario (barras)
    # # # # # # # # # # # # #

    ## Datos para serie usuario
    user_uf_m2_u = user_rows.select("uf").select("uf")

    uf_m2_array = []
    for i in 0..(user_calculated_value.size - 1)
      uf_m2_array << user_calculated_value[i] * user_building_surface[i]
    end
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

    # Arma la serie del usuario
    values_range_1 = []
    values_range_2 = []
    values_range_3 = []
    values_range_4 = []
    values_range_5 = []
    values_range_6 = []

    uf_m2_array.each do |sup|
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

    user_ufm2_final = [
      {name: '1', count: values_range_1.count},
      {name: '2', count: values_range_2.count},
      {name: '3', count: values_range_3.count},
      {name: '4', count: values_range_4.count},
      {name: '5', count: values_range_5.count},
      {name: '6', count: values_range_6.count},
    ]

    result.push({"title": "Precio Unitario (barras)", "series": [{"name": "Registros Base", "data": pri_u_final}, {"name": "Registros Usuario", "data": user_ufm2_final}] })



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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flex_report
      @flex_report = FlexReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flex_report_params
       params.require(:flex_report).permit(
         :name, :filters, transaction_ids: [],
         tenements_attributes: [:id, :county_id, :property_type_id,
                                :address, :parking, :cellar, :buidling_surface,
                                :terrain_surface, :uf]
       ).merge(user_id: current_user.id)
    end
end
