class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  include NumberFormatter

  def graduated_points
      @interval = Transaction.interval_graduated_points(params)
      render json: {data: @interval}
  end

  def dashboards
    respond_to do |f|
      f.js
    end
  end


  def transactions_summary
    result =[]

    begin
      global_transactions = Transaction.find_globals(params)
      general_data = [
        {:label => t(:UF_MIN_VALUE), :value => global_transactions[:uf_min_value]},
        {:label => t(:UF_MAX_VALUE), :value => global_transactions[:uf_max_value]},
        {:label => t(:UF_AVERAGE), :value => global_transactions[:average]},
        {:label => t(:UF_DEVIATION), :value => global_transactions[:deviation]},
        {:label => t(:AVG_TRANSACTIONS_BIMESTER), :value => global_transactions[:avg_trans_count]},
        {:label => t(:AVG_UF_VOLUME_BIMESTER), :value => global_transactions[:avg_uf_volume]}]



      ptypes = property_type
      stypes = seller_type
      transactions_by_periods = Transaction.group_transaction_county_and_bimester(params)
      uf_periods = uf_period
      average_uf_periods = average_uf_period
      transactions_ufs = transactions_uf

      #GENERAL
      #result = {:sheet => "Resumen", :data => []}
      #result[:data] << ["Información General"]

      data =[]
      result=[]
      general_data.each do |item|
        data.push("name": item[:label], "count":item[:value].to_i)
      end
      result.push({"title":"Información General", "data": data})


      #TIPO DE PROPIEDAD
      data =[]

      ptypes.each do |prop|
        data.push("name": prop.name.capitalize, "count": prop.value.to_i)
      end
      result.push({"title":"Tipo de Propiedad", "series":[{"data": data}]})



    #TIPO DE VENDEDOR

      data =[]
      stypes.each do |seller|
        data.push({"name": seller.name.capitalize, "count":seller.value.to_i})
      end

      result.push({"title":"Tipo de Vendedor", "series":[{"data": data}]})

      #TRANSACCIONES POR BIMESTRE

      # data =[]
      # counties_count = (transactions_by_periods.first.size - 3) / 2

      # label = ["Bimestre"]

      # 1.upto(counties_count).each do |idx|
      #   label << transactions_by_periods.first["y#{idx}_label".to_sym]
      # end

      # result[:data] << label

      # transactions_by_periods.each do |tb|
      #   val = [tb[:label]]

      #   1.upto(counties_count).each do |idx|
      #     if tb["y#{idx}_value".to_sym].nil?
      #       val << 0
      #     else
      #       val << tb["y#{idx}_value".to_sym].to_i
      #     end
      #   end

      #   result[:data] << val
      # end

      #UF PERIOD

      data =[]
      uf_periods.each do |ufp|
        data.push({"name": (ufp[:period].to_s + "/" + ufp[:year].to_s[2,3]), "count":   ufp[:value].to_i })
      end
      result.push({"title":"UF / Bimestre", "series":[{"data": data}]})


      #AVERAGE UF PERIOD

      data =[]
      average_uf_periods.each do |aup|
        data.push({"name": (aup[:period].to_s + "/" + aup[:year].to_s[2,3]), "count":   aup[:value].to_i })
      end

      result.push({"title":"Precio Promedio en UF / Bimestre", "series":[{"data": data}]})

      #TRANSACTION UF

      data =[]

      transactions_ufs.each do |aup|
        data.push({"name": NumberFormatter.format(aup[:from], false).to_s + " - " + NumberFormatter.format(aup[:to], false).to_s, "count": aup[:value].to_i})
      end

      result.push({"title":"Transacciones / UF", "series":[{"data": data}]})

    rescue
      result[:data] = ["Sin datos"]
    end


    #file_path = Xls.generate [result], "/xls", {:file_name => "#{Time.now.strftime("%Y-%m-%d_%H.%M")}_transacciones", :clean_directory_path => true}
    #send_file file_path, :type => "application/excel"
   @result = result
   return @result
  end

  def period

    @period = Transaction.get_last_period
    @first_period = Transaction.get_first_period_with_transactions

    unless Transaction.is_periods_distance_allowed?(@first_period, @period.first, @period.size)
      @first_period[:year] = @period.last[:year] unless @period.nil?
      @first_period[:period] = @period.last[:period] unless @period.nil?
    end
  end

  def property_type
    @property_types = PropertyType.group_transactions_by_prop_types(params)
  end

  def seller_type
    @seller_types = SellerType.group_transactions_by_seller_type(params)
  end

  def average_uf_period
    @transactions = Transaction.group_transaction_criteria_by_period(params, Transaction::AVG_CRITERIA)
  end

  def uf_period
    @transactions = Transaction.group_transaction_criteria_by_period(params, Transaction::SUM_CRITERIA)
  end

  def transactions_uf
    @transactions = Transaction.group_transactions_by_uf(params)
  end



  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transaction_params
    params.fetch(:transaction, {})
  end
end
