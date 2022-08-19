class Admin::FlexInformationsController < ApplicationController
  layout 'admin'
  before_action :set_flex_information, only: [:edit, :update]

  # GET /flex_informations
  # GET /flex_informations.json
  def index
    @flex_information = FlexInformation.first
  end

  # GET /flex_informations/1/edit
  def edit
  end

  # PATCH/PUT /flex_informations/1
  # PATCH/PUT /flex_informations/1.json
  def update
    respond_to do |format|
      if @flex_information.update(flex_information_params)
        format.html { redirect_to admin_flex_informations_url, notice: 'La Información de Flex se actualizó con éxito.' }
        format.json { render :show, status: :ok, location: @flex_information }
      else
        format.html { render :edit }
        format.json { render json: @flex_information.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flex_information
      @flex_information = FlexInformation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flex_information_params
      params.require(:flex_information).permit(:info, :video_link, :tutorial_link)
    end
end
