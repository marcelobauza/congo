class Admin::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  include NumberFormatter
  layout 'admin'

  def export_data
    @transactions = Transaction.new
  end

  def generate_csv
    file = Transaction.get_csv_data(params)
    send_file file, :type => 'text/csv', :disposition => "inline", :filename => "transactions.csv"
  end


  def export_data_sii
    @counties = County.order(name: :asc)
    @transactions = Transaction.new
  end

  def generate_csv_sii
    file = Transaction.get_csv_data_sii(params)
    send_file file, :type => 'text/csv', :disposition => "inline", :filename => "transactions.csv"
  end

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.where(nil)
    @transactions = @transactions.number_filter(params[:number]) if params.has_key? :number
    @transactions = @transactions.role_filter(params[:role]) if params.has_key? :role
    @transactions = @transactions.property_type_filter(params[:property_type_id]) if params.has_key? :property_type_id
    @transactions = @transactions.inscription_date_filter(params[:inscription_date]) if params.has_key? :inscription_date
    @transactions = @transactions.all.paginate(page: params[:page])
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
        format.html { redirect_to admin_transactions_path(), notice: 'Transaction was successfully updated.' }
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
      format.html { redirect_to admin_transactions_url, notice: 'Transaction was successfully destroyed.' }
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
    params.require(:transaction).permit(:property_type_id, :address, :sheet, :number, :inscription_date, :buyer_name, :seller_type_id, :department, :blueprint, :uf_value, :real_value, :calculated_value, :quarter,:year, :sample_factor, :county_id, :the_geom, :cellar, :parkingi, :role, :seller_name, :buller_rut, :uf_m2, :tome, :lot, :block, :village, :surface, :requiring_entity, :commments, :user_id, :surveyor_id, :active, :bimester, :code_sii, :total_surface_building, :total_surface_terrain, :uf_m2_u, :uf_m2_t, :building_regulation, :role_1, :role_2, :code_destination, :code_material, :year_sii, :latitude, :longitude).merge(user_id: current_user.id)
  end
end
