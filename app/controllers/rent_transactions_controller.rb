class RentTransactionsController < ApplicationController
  before_action :set_rent_transaction, only: [:show, :edit, :update, :destroy]

  # GET /rent_transactions
  # GET /rent_transactions.json
  def index
    @rent_transactions = RentTransaction.all
  end

  # GET /rent_transactions/1
  # GET /rent_transactions/1.json
  def show
  end

  # GET /rent_transactions/new
  def new
    @rent_transaction = RentTransaction.new
  end

  # GET /rent_transactions/1/edit
  def edit
  end

  # POST /rent_transactions
  # POST /rent_transactions.json
  def create
    @rent_transaction = RentTransaction.new(rent_transaction_params)

    respond_to do |format|
      if @rent_transaction.save
        format.html { redirect_to @rent_transaction, notice: 'Rent transaction was successfully created.' }
        format.json { render :show, status: :created, location: @rent_transaction }
      else
        format.html { render :new }
        format.json { render json: @rent_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rent_transactions/1
  # PATCH/PUT /rent_transactions/1.json
  def update
    respond_to do |format|
      if @rent_transaction.update(rent_transaction_params)
        format.html { redirect_to @rent_transaction, notice: 'Rent transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @rent_transaction }
      else
        format.html { render :edit }
        format.json { render json: @rent_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rent_transactions/1
  # DELETE /rent_transactions/1.json
  def destroy
    @rent_transaction.destroy
    respond_to do |format|
      format.html { redirect_to rent_transactions_url, notice: 'Rent transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rent_transaction
      @rent_transaction = RentTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rent_transaction_params
      params.require(:rent_transaction).permit(:property_type_id, :address, :sheet, :number, :inscription_date, :buyer_name, :seller_type_id, :department, :blueprint, :uf_value, :real_value, :calculated_value, :quarter, :quarter_date, :year, :sample_factor, :county_id, :the_geom, :cellar, :parking, :role, :seller_name, :buyer_rut, :uf_m2, :tome, :lot, :block, :village, :surface, :requirin_entity, :comments, :surveyor_id, :active, :bimester, :code_sii, :total_surface_building, :total_surface_terrain, :uf_m2_u, :uf_m2_t, :role_1, :role_2, :code_destination, :code_material, :year_sii, :role_associated, :additional_roles)
    end
end
