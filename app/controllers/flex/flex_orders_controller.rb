class Flex::FlexOrdersController < ApplicationController

  def new
    @flex_order = FlexOrder.new
  end

  def create
    require 'mercadopago'
    @flex_order = FlexOrder.new(flex_order_params)
    sdk = Mercadopago::SDK.new(ENV['MP_ACCESS_TOKEN'])
    @unit_price = 5990
    preference_data = {
      items: [
        {
          title: 'Reporte Flex',
          quantity: @flex_order.amount,
          currency_id: 'CLP',
          unit_price: @unit_price
        }
      ],
      binary_mode: true,
      back_urls: {
        success: flex_flex_reports_url,
        failure: flex_flex_reports_url,
        pending: flex_flex_reports_url
      },
      auto_return: 'approved'
    }
    preference_response = sdk.preference.create(preference_data)
    preference = preference_response[:response]
    @preference_id = preference['id']

    @flex_order.preference_id = @preference_id
    @flex_order.unit_price = @unit_price

    respond_to do |format|
      if @flex_order.save
        format.js
        format.html { redirect_to @flex_report, notice: 'La orden se creó correctamente.' }
        format.json { render :show, status: :created, location: @flex_order }
      else
        format.js
        format.html { render :new }
        format.json { render json: @flex_order.errors, status: :unprocessable_entity }
      end
    end

  end

  private

  def flex_order_params
    params.require(:flex_order).permit(:amount).merge(user_id: current_user.id)
  end

end
