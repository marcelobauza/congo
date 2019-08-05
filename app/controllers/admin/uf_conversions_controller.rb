class Admin::UfConversionsController < ApplicationController
  before_action :set_uf_conversion, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  
  # GET /uf_conversions
  # GET /uf_conversions.json
  def index
    @uf_conversions = UfConversion.all.paginate(page: params[:page])
    
  end

  # GET /uf_conversions/1
  # GET /uf_conversions/1.json
  def show
  end

  # GET /uf_conversions/new
  def new
    @uf_conversion = UfConversion.new
  end

  # GET /uf_conversions/1/edit
  def edit
  end

  # POST /uf_conversions
  # POST /uf_conversions.json
  def create
    UfConversion.load_file params[:uf_conversion][:file]
    redirect_to admin_uf_conversions_path()
  end

  # PATCH/PUT /uf_conversions/1
  # PATCH/PUT /uf_conversions/1.json
  def update
    respond_to do |format|
      if @uf_conversion.update(uf_conversion_params)
        format.html { redirect_to @uf_conversion, notice: 'Uf conversion was successfully updated.' }
        format.json { render :show, status: :ok, location: @uf_conversion }
      else
        format.html { render :edit }
        format.json { render json: @uf_conversion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uf_conversions/1
  # DELETE /uf_conversions/1.json
  def destroy
    @uf_conversion.destroy
    respond_to do |format|
      format.html { redirect_to uf_conversions_url, notice: 'Uf conversion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_uf_conversion
    @uf_conversion = UfConversion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def uf_conversion_params
    params.require(:uf_conversion).permit(:uf_date, :uf_value, :file)
  end
end
