class SellerTypesController < ApplicationController
  before_action :set_seller_type, only: [:show, :edit, :update, :destroy]

  # GET /seller_types
  # GET /seller_types.json
  def index
    @seller_types = SellerType.all
  end

  # GET /seller_types/1
  # GET /seller_types/1.json
  def show
  end

  # GET /seller_types/new
  def new
    @seller_type = SellerType.new
  end

  # GET /seller_types/1/edit
  def edit
  end

  # POST /seller_types
  # POST /seller_types.json
  def create
    @seller_type = SellerType.new(seller_type_params)

    respond_to do |format|
      if @seller_type.save
        format.html { redirect_to @seller_type, notice: 'Seller type was successfully created.' }
        format.json { render :show, status: :created, location: @seller_type }
      else
        format.html { render :new }
        format.json { render json: @seller_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seller_types/1
  # PATCH/PUT /seller_types/1.json
  def update
    respond_to do |format|
      if @seller_type.update(seller_type_params)
        format.html { redirect_to @seller_type, notice: 'Seller type was successfully updated.' }
        format.json { render :show, status: :ok, location: @seller_type }
      else
        format.html { render :edit }
        format.json { render json: @seller_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seller_types/1
  # DELETE /seller_types/1.json
  def destroy
    @seller_type.destroy
    respond_to do |format|
      format.html { redirect_to seller_types_url, notice: 'Seller type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seller_type
      @seller_type = SellerType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seller_type_params
      params.require(:seller_type).permit(:name)
    end
end
